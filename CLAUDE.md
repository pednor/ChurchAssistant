# CLAUDE.md — ChurchAssistant Configuration Repository

This file is the primary guidance for Claude Code working in this repository. Follow it on every interaction.

## Compact Instructions
When context compacts, preserve: current task state, list of modified files, and any validation commands run.

---

## What This Project Is

Home Assistant configuration repository — HAOS instance at the church, synced via GitHub.

```
Mac (/Volumes/FOH_LaCie/VSCode/ChurchAssistant/)  ↕ git push/pull
GitHub (pednor/ChurchAssistant)                    — source of truth (TBD: create repo)
HA (/homeassistant on churchassistant)            ↕ git push/pull (PAT auth, TBD: bootstrap as git repo)
```

- **HA host**: `churchassistant` (LAN hostname)
- **SSH access**: `ssh hassio@churchassistant` (key-based, user `hassio` — sudoer)
- **Main files**: `configuration.yaml` · `automations.yaml` · `scripts.yaml` · `scenes.yaml`

> **Bootstrap status (2026-05-13):** Workspace scaffolded; config rsynced from churchassistant; local git initialized. **Not yet done:** create GitHub repo `pednor/ChurchAssistant`, push initial commit, initialize `/homeassistant` on churchassistant as a git checkout. `/ha-sync` and `/mac-sync` will not function until the HA-side bootstrap is complete.

---

## Guardrails (Never Violate)

### Forbidden Files — NEVER read or access:
- `secrets.yaml` / `secrets.*.yaml` · `.env` / `.env.*`
- `*.pem`, `*.key`, `*.crt` · `*_token*`, `*_credential*`, `*_password*`
- `.storage/auth*`, `.storage/cloud`

### Approval Gates — MUST get approval before:
- Editing more than **two files**
- Adding/removing dependencies
- Running install, build, migration, or destructive commands
- Making network requests

### Commits
- **NEVER commit without explicit user approval** — state intent (files, message) first
- Batch changes during iteration; commit only when user says to
- **Validate then stage after each phase** — do not batch unvalidated work

### Execution
- MUST present a **numbered plan** before making changes
- Use **minimal diffs** — do not refactor unrelated code
- If an error repeats **twice**, stop and escalate
- MUST ask before expanding scope to additional files
- Do not reformat large files unless explicitly asked
- Highlight trade-offs neutrally when a recommendation involves them

### Verify Before Suggesting
- Before recommending any CLI command, HA service call, or MCP tool, verify it exists for the current installed version
- Check `reference/system/HA_SYSTEM_REFERENCE.md` for installed versions (once populated)
- If unsure, say so explicitly — never guess

### Fail Fast
- If data isn't found after **5 tool calls**, stop immediately and report what was tried
- "I don't know" early is better than a wrong answer after 20 tool calls

---

## Session Start Checklist

1. **Map user intent to a skill** (see table below) — invoke matching skill before proceeding
2. **Read `reference/INDEX.md`** — filter by `agent_use` for the current task
3. **Check `reference/system/HA_SYSTEM_REFERENCE.md`** — once populated — for installed versions and pending updates

## Skills

| User says... | Invoke skill |
|---|---|
| `ha status`, `who's here`, `door status` | `/ha-status` |
| `ha health`, `system check`, `pending updates` | `/ha-health` |
| `sync`, `ha sync`, `commit push pull` | `/ha-sync` (Mac → GitHub → HA) |
| `mac sync`, `pull from HA` | `/mac-sync` (HA → GitHub → Mac) |

Full skill definitions: `.claude/skills/`

---

## Development Commands

```bash
ha core check    # validate config before restart
ha core restart  # restart after changes
ha core logs     # view logs
```

## Git Workflow
1. **Always pull before editing** to avoid merge conflicts
2. Mac uses SSH key auth to GitHub; HA uses GitHub PAT in remote URL (set during HA-side bootstrap)
3. Git commands on HA MUST use `sudo` and run from `/homeassistant`

---

## Reference System

All reference docs live in `reference/`. **Always read `reference/INDEX.md` first** — filter by `agent_use`, load max 2–3 docs per task. Full rules: `.claude/rules/reference-system.md`.
