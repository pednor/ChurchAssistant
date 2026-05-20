---
skill: mac-sync
command: /mac-sync
description: "Commit, push from HA, and pull on Mac to sync HA → GitHub → Mac (reverse direction of /ha-sync)"
max_tool_calls: 6
---

# Skill: Mac Sync (ChurchAssistant)

Commit churchassistant-side changes (typically from MCP writes that landed in tracked files like `automations.yaml`, `scripts.yaml`, or `.storage/lovelace.*`), push to GitHub, and pull to Mac — full reverse repo sync.

> **Prerequisite:** `/homeassistant` on `churchassistant` must already be a git repository with `origin` pointing at `pednor/ChurchAssistant` and `main` checked out. Until that one-time bootstrap is done, this skill cannot push from the HA side.

## When to use

Use this after MCP-driven edits that landed in tracked files on HA. Common triggers:
- `ha_config_set_automation` / `ha_config_set_script` (writes to `automations.yaml` / `scripts.yaml`)
- `ha_config_set_dashboard` (writes to `.storage/lovelace.*` — these ARE tracked per `.gitignore` allowlist)
- Direct `ha_write_file` to any tracked file

## Steps

1. **Check HA state** — `ssh hassio@churchassistant "sudo git -C /homeassistant status -s; sudo git -C /homeassistant diff --stat"` to see what HA has uncommitted. Dirt should normally be limited to real config edits (`automations.yaml`, `.storage/lovelace.*`, etc.).
2. **Stage on HA** — add changed tracked files **by name**. Include `.storage/lovelace.*` (UI dashboard edits) and `automations.yaml` / `scripts.yaml` etc. when dirty. Never stage secrets, `.env`, keys, or `.gitignore`d files.
3. **Commit on HA** — descriptive conventional-commit message. Append `Co-Authored-By: Claude Opus 4.7 <noreply@anthropic.com>`.
4. **Self-heal then push from HA** — `ssh hassio@churchassistant "sudo git -C /homeassistant fetch origin && sudo git -C /homeassistant pull --rebase --autostash && sudo git -C /homeassistant push"`. The fetch+rebase auto-handles "your branch is behind" rejections by replaying HA's commit on top of origin's tip; `--autostash` is harmless extra safety on a normally-clean HA. If a real merge conflict surfaces, STOP and report.
5. **Pull on Mac** — `git pull --ff-only` in the Mac working tree.
6. **Report** — confirm Mac, GitHub, HA all at same hash.

## Rules

- Stage only files the user approved — by name, never `git add -A` / `git add .`. Never secrets, `.env`, keys, or `.gitignore`d files
- Treat dirty `.storage/lovelace.*` as user UI edits — stage them by default
- `.storage/core.device_registry` and `.storage/core.entity_registry` are not tracked. If they ever appear dirty, something has changed the `.gitignore` allowlist — investigate before staging
- Use the repo's conventional commit style (`feat:`, `fix:`, `refactor:`, etc.)
- If there are no changes to commit on HA, say so and stop
- `git pull --rebase --autostash` on HA is the default for self-healing behind-upstream cases. Real merge conflicts (not just "behind upstream") → STOP and report
- Mac pull uses `--ff-only` — refuses silent merge commits
- Never force push
