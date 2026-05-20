---
skill: ha-health
command: /ha-health
description: "Structured Home Assistant health check — system, repairs, logs, mesh, batteries, backups, updates, automations (churchassistant)"
agent_use: [diagnostics, system-context]
reference_docs:
  - reference/INDEX.md
  - reference/system/HA_SYSTEM_REFERENCE.md
max_tool_calls: 10
---

# Skill: HA Health Check (ChurchAssistant)

## Goal

Produce a structured health report covering the categories the experienced HA community treats as load-bearing: system + Repairs, log errors, radio mesh, batteries, backups, pending updates, and recurring automation failures. Bounded to 10 tool calls — no open-ended exploration.

The report is a triage feed, not a fix queue. Flag, don't investigate.

## Honor known-offline memory before flagging

Before flagging any add-on `error`, `unavailable` device, or unhealthy sensor, check memory for known-offline operational context (`project_*` memory entries describing intentional offline state). If a finding matches a known-offline entry, suppress it from the report.

## Steps

Each call below is one of the 10-call budget. Call in parallel where independent.

1. **System health (multiplexed)** — `ha_get_system_health(include="repairs,zha_network,zwave_network")`
   Extracts in one call: HA/HAOS/Supervisor versions, disk, DB size, Nabu Casa status, **Repairs items**, **Zigbee mesh**, **Z-Wave nodes**.

2. **Add-ons** — `ha_list_installed_addons`
   Pending updates + add-ons in `error`/`stopped` state (filtered against known-offline memory).

3. **Update entities** — `ha_search_entities(domain_filter="update", limit=80)`
   Catches firmware, HACS, and core/OS updates that don't surface via `ha_list_installed_addons`. Filter to `state=on`.

4. **System log** — `ha_get_logs(level="ERROR")` (or equivalent log-fetch tool available in this MCP install)
   Group by message signature, sort by repetition count DESC. Surface top 5 groups.

5. **Batteries** — `ha_search_entities(query="battery", domain_filter="sensor", limit=50)`
   Two findings to extract: (a) state numeric and < 20%, (b) `last_updated` older than 7 days. Stuck-battery detection matters as much as low-battery.

6. **Backup status** — probe for a backup-status entity:
   - Try `ha_search_entities(query="backup", limit=10)` and look for `sensor.backup_*` / `sensor.last_backup_*` / Nabu Casa backup entity.
   - If none exists, mark backup section "no entity exposed — install HA Backup integration or a backup-age sensor for visibility" and move on.

7. **Unavailable entities (filtered)** — `ha_search_entities` or `ha_get_overview` to enumerate `unavailable`-state entities, with these filters applied **before** counting:
   - Drop entire `device_tracker` domain (mobile/BLE flicker noise)
   - Drop mobile_app `sensor.*` when owning person is `not_home`
   - Drop entities flagged in known-offline memory
   - Drop `update.*` (already covered in step 3)
   - Group remaining by domain; show counts + top 3 examples per domain.

8. **Automation traces** — only if step 4 surfaced automation-related errors, OR if no other steps found anything noteworthy. `ha_get_automation_traces` for the suspect automations. **Only surface failures recurring ≥3× in 24h** — suppress single transient errors.

9–10. **Reserved** for follow-up probes if any of the above returned partial data.

## Output Format

```
## ChurchAssistant Health Check — [YYYY-MM-DD]

### System
| Property      | Value |
|---------------|-------|
| HA Core       | x.x.x |
| HAOS          | x.x   |
| Supervisor    | x.x.x |
| DB Size       | x MiB |
| Disk Used     | x / y GB |
| Nabu Casa     | connected (region, expires YYYY-MM-DD) |

### 🚨 Repairs ([count])
- [issue title] — [integration] — [severity]
- None if zero open

### ⚠️ Log Errors (last 24h, top 5 by repetition)
| Count | Source | Message |
|-------|--------|---------|
| 47    | zha    | Failed to deliver ... |
- None if no ERROR-level entries repeating

### Pending Updates
**Core/Security:**
- HA Core x.x.x → x.x.x
- HAOS x.x → x.x

**Add-ons / HACS / Firmware:**
- [name] x.x.x → x.x.x

- "All current" if nothing pending

### Add-on State
- [name] — error / stopped (only flagged states; honor known-offline memory)
- "All started" if clean

### Radio Mesh
**Zigbee:**
- Weak nodes (LQI < 50 AND RSSI < −80): [name] LQI=x RSSI=y
- Edge nodes with no router neighbor: [name]

**Z-Wave:**
- Dead nodes: [name]
- "Healthy" if no findings (or "N/A — no Z-Wave")

### Batteries
**Low (< 20%):**
- [device] [percent]%

**Stuck (no update > 7d):**
- [device] [percent]% — last update [Nd ago]

- "All healthy" if none

### Backup Status
- Last successful: YYYY-MM-DD HH:MM (Nd ago)
- Destinations: [count]
- Or: "No backup entity exposed — recommend installing HA Backup integration"

### Automation Errors (recurring ≥3× / 24h)
- [automation name] — [error message] (Nx in 24h)
- None if all clean (or "single transient errors suppressed: N")

### Unavailable Entities (filtered)
| Domain | Count | Examples |
|--------|-------|---------|
| sensor | 3 | sensor.foo, ... |

Filters applied: device_tracker dropped, mobile_app sensors when owner not_home, known-offline suppressed.

- None if all available after filters

### Recommendations (only when relevant)
- "Watchman not installed — recommend `dummylabs/thewatchman` for config-reference integrity"
- Flag if HA Core is >2 minor versions behind latest stable
- Flag if DB > 2 GB on SD-card install
```

## Filter rules (apply before counting/flagging)

- **Unavailable entities — drop:** `device_tracker.*`; `update.*`; mobile_app `sensor.*` when owning `person.*` is `not_home`; entities flagged in known-offline memory.
- **Log entries — keep:** ERROR level only; WARNING only if repeating ≥10× / 24h.
- **Add-on state errors — drop** if matched by known-offline memory entry.
- **Update entities — split** into "core/security" (HA Core, HAOS, Supervisor, security-flagged HACS items, controller firmware) vs "cosmetic" (themes, frontend cards, ESPHome node firmware unless flagged).
- **Automation traces — surface only** failures recurring ≥3× in 24h. Single-shot trace errors usually mean a network blip.

## Stop Conditions

- Stop after 10 tool calls regardless of completeness — report what was found and note what was skipped.
- If a step's tool returns too much data (e.g. Repairs > 50 items), summarize counts + top examples; don't paginate.
- Do not investigate root causes — flag issues only, let the user decide what to action.
- If known-offline memory is missing for a device the user has previously described as intentionally offline, suggest saving a `project_*` memory entry rather than re-flagging next time.

## Out of scope (defer to dedicated skills or monthly/quarterly reviews)

- Watchman config-reference scan — noted as a recommendation; not run from this skill.
- Top-N chatty recorder entities (requires SQL) — separate `/ha-recorder-audit` skill if needed.
- Long-lived token / user account review — quarterly security review.
- Backup restore test — quarterly, manual.
- "Automation never triggered in 90d" review — separate `/ha-automation-audit` skill if needed.
