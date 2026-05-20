---
type: plan
status: completed
agent_use: [setup, system-context]
last_updated: 2026-05-19
---

# ChurchAssistant Bootstrap Plan

## Context

Set up a Mac-side project directory at `~/VSCode/ChurchAssistant/` to manage the church Home Assistant instance (now physically deployed at the church). Bootstrapped from the established `~/VSCode/HomeAssistant/` project — bring over universal Claude tooling and patterns, adapt instance-specific config, leave behind home-specific content.

The church HA is reachable from this Mac via Tailscale (validated 2026-05-19 — ping/SSH/HTTP all working via direct peer-to-peer connection). Tailscale device name: `churchassistant`.

## Inventory: from HomeAssistant project

### ✅ Universal — copy as-is

| Source path | Destination | Why |
|---|---|---|
| `.claude/skills/ha-sync/` | `.claude/skills/ha-sync/` | Git sync workflow is identical |
| `.claude/skills/mac-sync/` | `.claude/skills/mac-sync/` | Same |
| `.claude/skills/ha-health/` | `.claude/skills/ha-health/` | Health checks are HA-version-specific, not site-specific |
| `.claude/skills/ha-status/` | `.claude/skills/ha-status/` | Same |
| `.claude/rules/reference-system.md` | `.claude/rules/reference-system.md` | Doc-loading philosophy is universal |
| `.claude/rules/doc-maintenance.md` | `.claude/rules/doc-maintenance.md` | Proactive doc-update pattern, universal |
| `reference/guides/NEW_HA_INSTANCE_PREFLIGHT.md` | `reference/guides/NEW_HA_INSTANCE_PREFLIGHT.md` | Literally built for this church install |
| `reference/guides/GIT_SYNC_STRATEGY.md` | `reference/guides/GIT_SYNC_STRATEGY.md` | Mac ↔ GitHub ↔ HA flow is identical |
| `reference/guides/HA_MCP_TOOLS_REFERENCE.md` | `reference/guides/HA_MCP_TOOLS_REFERENCE.md` | Universal MCP tool docs |
| `reference/guides/HA-MCP-SETUP.md` | `reference/guides/HA-MCP-SETUP.md` | Universal setup guide |
| `.gitignore` | `.gitignore` | Patterns mostly universal — allowlists for `.storage/lovelace.*`, etc. apply equally |

### ✏️ Adapt — rewrite for church specifics

| Source path | Destination | What changes |
|---|---|---|
| `CLAUDE.md` | `CLAUDE.md` | Replace `homeassistant.local` / `192.168.0.32` with `churchassistant` (Tailscale name). Strip home-specific reference doc list. Keep all guardrails / approval gates / commit rules. |
| (new) | `.mcp.json` | Both MCP servers configured to point at `churchassistant`. Secrets are **placeholders** until the matching add-ons are installed on church HA. |
| (new) | `reference/INDEX.md` | Skeleton: controlled vocabulary preserved, content tables empty (church plans/research/integrations build up from scratch as work progresses). |

### ❌ Skip — home-specific or comes from HA via git later

- All HA YAML config (`configuration.yaml`, `automations.yaml`, `scripts.yaml`, etc.) — these live on church HA, pulled via future git sync once church HA has its own GitHub repo
- `.storage/` — never copy state; church HA generates its own
- `templates/` (home's internet_status, hvac_runtime, etc. are home-specific)
- `themes/`, `esphome/`, `mqtt.yaml`, `input_boolean.yaml`, `scenes.yaml`, `groups.yaml`
- `reference/system/`, `/research/`, `/plans/` (other than this one), `/integrations/`, `/incidents/`, `/assets/` — all home-specific content
- `.claude/skills/esp-deploy`, `esp-sync` — no church ESP32 work in scope (add later if/when needed)
- `.claude/rules/esp32-dev.md` — same reason
- `.claude/worktrees/`, `.claude/hooks/`, `.claude/settings.local.json` — workspace-specific state

## Defaults assumed (no answer received from user)

1. **Church HA GitHub repo:** Not yet set up. Bootstrap will create the Mac scaffold; user can `git init` and wire up GitHub remote later. Will need a future `NEW_HA_INSTANCE_PREFLIGHT`-style pass to set up git on the church HA side.
2. **ESP32 work at church:** None in scope. Skip ESP-related skills + rules. Add later if needed.
3. **MCP add-ons on church HA:** Status unknown. `.mcp.json` will be written with structure but placeholder secrets — needs to be filled in once `HA MCP Server` add-on and `HA Vibecode Agent` add-on are installed on church HA.

## Execution phases

### Phase 1 — Directory shell ✅
Done. `~/VSCode/ChurchAssistant/{.claude/{skills,rules},reference/{guides,plans,system}}` created.

### Phase 2 — Plan file ✅
Done. This document.

### Phase 3 — Copy universal files ✅
Done (originally on the other Mac 2026-05-13, reconciled to this Mac 2026-05-19).
- 4 universal skills (ha-sync, mac-sync, ha-health, ha-status) — present, church-adapted
- 2 universal rule files — present
- 4 universal guide docs — present
- `.gitignore` — present (church-cleaned)

### Phase 4 — Generate adapted files ✅
Done.
- `CLAUDE.md` — adapted for church
- `.mcp.json` — placeholder secrets pending MCP add-on install
- `reference/INDEX.md` — populated manifest

### Phase 5 — Verification ✅
- Directory tree verified via `diff -rq` during 2026-05-19 reconciliation
- Tailscale reachability validated 2026-05-19
- No broken references to home paths

> **Reconciliation note (2026-05-19):** This Mac and the original other-Mac scaffold (`/Volumes/FOH_LaCie/VSCode/ChurchAssistant/`) were unaware of each other. Today: stashed this Mac's duplicate scaffold, cloned `pednor/ChurchAssistant` as canonical, merged in stash-only files (`.mcp.json`, 4 universal guides, this plan), kept clone's church-adapted SKILL files and `.gitignore`, hand-merged CLAUDE.md (path) and INDEX.md (structure).

## Open follow-ups (not in this bootstrap)

These are next steps after the scaffold:

1. **Install MCP add-ons on church HA** — `HA MCP Server` and `HA Vibecode Agent` from the add-on store. Capture the token / agent key into `.mcp.json` (currently placeholder values).
2. **Initialize `/homeassistant` on church HA as a git checkout** — `git init` in `/homeassistant`, configure `pednor/ChurchAssistant` remote with PAT auth, initial commit, set `main` upstream. Until this is done, `/ha-sync` and `/mac-sync` will not function.
3. ~~**Clone church HA repo into this Mac directory**~~ ✅ Done 2026-05-19 via cross-Mac reconciliation.
4. **Refresh `/ha-health` and `/ha-status` against church** — `HA_SYSTEM_REFERENCE.md` baseline is from 2026-05-14; re-run after MCP add-ons are wired and refresh that doc.
5. **Restart this Claude Code session from `~/VSCode/ChurchAssistant/`** — so MCP picks up the `.mcp.json` (after step 1) and points at church HA, not home.
