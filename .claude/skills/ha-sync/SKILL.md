---
skill: ha-sync
command: /ha-sync
description: "Commit, push, and pull all repo changes to sync Mac → GitHub → HA (churchassistant)"
max_tool_calls: 7
---

# Skill: HA Sync (ChurchAssistant)

Commit all changed files, push to GitHub, and pull to ChurchAssistant — full repo sync.

> **Prerequisite:** `/homeassistant` on `churchassistant` must already be a git repository with `origin` pointing at `pednor/ChurchAssistant` and `main` checked out. Until that one-time bootstrap is done, this skill cannot pull on the HA side.

## Steps

1. **Pre-flight: is HA clean?** — `ssh hassio@churchassistant "sudo git -C /homeassistant status -s"`. If HA shows uncommitted tracked changes (e.g., `automations.yaml`, `.storage/lovelace.*`), those are real edits — STOP and recommend `/mac-sync` first. **Exception:** user explicitly says recovery/revert ("force Mac state to overwrite HA") — proceed with re-confirmation.
2. **Check Mac state** — run `git status` and `git diff --stat` to confirm what changed locally.
3. **Stage** — add changed/new files **by name** (CLAUDE.md forbids `git add -A` / `git add .`). Do not stage `.gitignore`d files or anything containing secrets/keys/tokens.
4. **Commit** — descriptive conventional-commit message (`feat:`, `fix:`, `docs:`, `chore:`, etc.). Append `Co-Authored-By: Claude Opus 4.7 <noreply@anthropic.com>`.
5. **Self-heal then push** — `git fetch origin && git pull --rebase --autostash && git push`. The fetch+rebase auto-handles "your branch is behind" rejections by replaying the commit on top of origin's tip; `--autostash` covers any uncommitted dirt (rare on Mac). If a real merge conflict surfaces, STOP and report — never auto-resolve.
6. **Pull to HA** — `ssh hassio@churchassistant "sudo git -C /homeassistant pull --ff-only"`. `--ff-only` refuses silent merge commits if anything is unexpectedly diverged.
7. **Validate HA config** — call `mcp__ha-mcp__ha_check_config` (if MCP is wired to churchassistant). Catches semantic errors that YAML syntax checks miss. If invalid, STOP — report the error.
8. **Report** — confirm all steps succeeded; note final hash on Mac, GitHub, and HA. Remind the user which manual reload is needed (`automation.reload`, `homeassistant.reload_all`, or restart).

## Rules

- **Never overwrite HA silently.** Pre-flight HA cleanliness first. If HA is dirty and user hasn't said "recovery", stop.
- Stage by name — never `git add -A` or `git add .`. Never secrets, `.env`, keys, or `.gitignore`d files.
- Use the repo's conventional commit style (`feat:`, `fix:`, `refactor:`, etc.)
- If there are no changes to commit, say so and stop
- Never force push
- `git pull --rebase --autostash` is the default for self-healing behind-upstream cases. If the rebase encounters a real conflict (not just "behind upstream"), STOP and report — never auto-resolve
- HA pulls always use `--ff-only` — refuses silent merge commits
