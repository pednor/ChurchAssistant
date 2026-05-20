# Reference Documentation Index

_Last updated: 2026-05-19_ <!-- Cross-Mac reconciliation: merged stash structure + remote content -->

> **Agent instruction**: Load this file first for any HA task. Filter the table by `agent_use` to find relevant docs. Load only matched docs — do not load the full reference directory.

This is the **ChurchAssistant** project's reference index. Sibling project `~/VSCode/HomeAssistant/` has its own separate index — do not cross-reference home reference docs from church work or vice versa.

---

## Controlled Vocabularies

### `type` values
| Value | Meaning |
|-------|---------|
| `system` | Ground truth of the current HA setup |
| `research` | External research — not yet implemented |
| `plan` | Decided direction with actionable next steps |
| `guide` | Operational how-to and setup instructions |
| `integration` | Built and verified integrations |
| `incident` | Post-mortem of an operational incident — timeline, root cause, lessons learned |

### `status` values
| Value | Meaning |
|-------|---------|
| `active` | Current and authoritative |
| `in-progress` | Work underway, partially complete |
| `draft` | Research collected, no decision made |
| `completed` | Done, kept for historical reference |
| `deprecated` | Superseded — do not act on |

### `agent_use` contexts
| Context | When to load |
|---------|-------------|
| `system-context` | Any task needing knowledge of the current HA setup |
| `automation` | Building or editing automations/scripts |
| `dashboard` | Building or editing Lovelace dashboards |
| `diagnostics` | Health checks, troubleshooting, state analysis |
| `setup` | Installing or configuring integrations/tools |
| `hardware` | Hardware research, specs, or selection |
| `git-workflow` | Git sync, commits, branch operations |

---

## System — Ground truth of the current setup

| File | Summary | Status | Agent Use |
|------|---------|--------|-----------|
| [HA System Reference](system/HA_SYSTEM_REFERENCE.md) | Baseline snapshot — HA Core 2026.5.1 / HAOS 17.3 / rpi5-64. Captured 2026-05-14; re-run `/ha-health` to refresh. | active | system-context, diagnostics, automation, dashboard, setup, hardware |

---

## Research — Evaluated but not yet built

| File | Summary | Status | Agent Use |
|------|---------|--------|-----------|

_(Empty.)_

---

## Plans — Decided direction, actionable specs

| File | Summary | Status | Agent Use |
|------|---------|--------|-----------|
| [Bootstrap Plan](plans/BOOTSTRAP_PLAN.md) | Initial scaffold of the ChurchAssistant project — what's copied from HomeAssistant, what's adapted, what's skipped. Phases 1–5 complete; open follow-ups for HA-side git + MCP add-ons. | completed | setup, system-context |

---

## Guides — Operational how-to and setup docs

| File | Summary | Status | Agent Use |
|------|---------|--------|-----------|
| [Git Sync Strategy](guides/GIT_SYNC_STRATEGY.md) | Mac ↔ GitHub ↔ HA sync workflow, SSH/PAT auth | active | git-workflow |
| [HA MCP Tools Reference](guides/HA_MCP_TOOLS_REFERENCE.md) | Full reference for ha-mcp and home-assistant MCP tools | active | system-context, diagnostics, automation, dashboard |
| [HA MCP Setup](guides/HA-MCP-SETUP.md) | MCP server configuration and connection guide | active | setup |
| [New HA Instance Pre-Flight](guides/NEW_HA_INSTANCE_PREFLIGHT.md) | 11-phase prep for a fresh HA instance — hostname rename to avoid mDNS conflict, baseline onboarding, add-on preload | active | setup |

---

## Integrations — Built and verified

| File | Summary | Status | Agent Use |
|------|---------|--------|-----------|

_(Empty.)_

---

## Incidents — Post-mortems of operational events

| File | Summary | Status | Agent Use |
|------|---------|--------|-----------|

_(Empty.)_
