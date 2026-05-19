---
title: "Git Sync Strategy"
type: guide
status: active
tags: [git, github, workflow, ssh, sync]
agent_use: [git-workflow]
created: 2026-01-28
updated: 2026-01-28
summary: "How to sync config between Mac, GitHub, and HA device. SSH/PAT auth, pull-before-edit workflow, conflict resolution."
---

# Git Sync Strategy: Mac ↔ GitHub ↔ Home Assistant

> **Purpose**: Document the workflow for keeping the local Mac workspace and Home Assistant config in sync using Git and GitHub as the central hub.

---

## Overview

This project uses a **Git-based sync strategy** where both the local Mac workspace and the Home Assistant instance are connected to the same GitHub repository. This allows:

- Offline editing on Mac with full Copilot support
- Remote editing on HA via VS Code Remote-SSH
- Version control and backup of all files
- Seamless sync between both environments

---

## Architecture

```
    ┌──────────────────────────┐
    │         GitHub           │
    │  pednor/HomeAssistant    │
    │      (central hub)       │
    └────────────┬─────────────┘
                 │
         ┌───────┴───────┐
         │               │
         ▼               ▼
   ┌───────────┐   ┌───────────┐
   │    Mac    │   │    HA     │
   │  (local)  │   │ (remote)  │
   │           │   │           │
   │ /Users/rp │   │ /home-    │
   │ /VSCode/  │   │ assistant │
   │ HomeAs... │   │           │
   └───────────┘   └───────────┘
```

---

## What Lives Where

| Location | Contents |
|----------|----------|
| **GitHub** | Central repository - source of truth |
| **Mac (local)** | Governance docs, references, offline editing workspace |
| **HA (remote)** | Live HA configs + governance docs (synced via Git) |

---

## Workflow

### Scenario 1: Editing on Mac (Offline)

1. Open `/Users/rp/VSCode/HomeAssistant` in VS Code
2. Edit governance docs, references, or prep config changes
3. Use Copilot with full local tooling
4. Commit changes:
   ```bash
   git add .
   git commit -m "Update governance docs"
   git push
   ```

### Scenario 2: Editing on HA (Remote-SSH)

1. Open VS Code → `Cmd+Shift+P` → "Remote-SSH: Connect to Host..."
2. Select `homeassistant.local`
3. Open folder `/homeassistant/`
4. **Pull latest changes first**:
   ```bash
   git pull
   ```
5. Edit HA configs with Copilot
6. Commit and push:
   ```bash
   git add .
   git commit -m "Update automations"
   git push
   ```

### Scenario 3: Syncing Between Locations

**On Mac after working on HA:**
```bash
git pull
```

**On HA after working on Mac:**
```bash
git pull
```

---

## Initial Setup Requirements

### On Mac ✅ Complete
- [x] Git initialized in `/Users/rp/VSCode/HomeAssistant`
- [x] Remote set to `github.com/pednor/HomeAssistant`
- [x] SSH key configured for GitHub

### On Home Assistant ✅ Complete
- [x] Git initialized in `/homeassistant/`
- [x] Remote set to `github.com/pednor/HomeAssistant`
- [x] GitHub Personal Access Token (PAT) configured for authentication
- [x] Initial pull to get governance docs from GitHub
- [x] HA config files added and committed
- [x] `safe.directory` configured for `/homeassistant/`

---

## GitHub Authentication on HA

HA uses a **Personal Access Token (PAT)** embedded in the remote URL for GitHub authentication.

### To Update the Token:
1. Generate a new token at: https://github.com/settings/tokens
2. In HA Web Terminal, run:
   ```bash
   git remote set-url origin https://pednor:YOUR_NEW_TOKEN@github.com/pednor/HomeAssistant.git
   ```
3. Verify with:
   ```bash
   git remote -v
   ```

### Token Requirements:
- **Fine-grained token** (recommended): Repository access to `pednor/HomeAssistant` with Contents read/write
- **Classic token**: `repo` scope

**Note:** Git commands that write (commit, push) must be run from the **HA Web Terminal** (as root) due to directory ownership.

---

## SSH Access

**From Mac to HA:**
```bash
ssh homeassistant.local
```

**SSH Config** (`~/.ssh/config` on Mac):
```
Host homeassistant.local
    HostName homeassistant.local
    User hassio
    Port 22
    IdentityFile ~/.ssh/ha_key
```

---

## Important Notes

1. **Always pull before editing** to avoid merge conflicts
2. **Never commit `secrets.yaml`** — it's in `.gitignore`
3. **Validate HA config** before committing major changes
4. **Commit frequently** with descriptive messages
5. **Push after each session** to keep GitHub up to date

---

## Files Tracked in Git

| File/Folder | Description | Synced |
|-------------|-------------|--------|
| `.vscode/` | Governance docs, settings, snippets | ✅ Yes |
| `reference/` | Reference documentation | ✅ Yes |
| `README.md` | Project documentation | ✅ Yes |
| `configuration.yaml` | Main HA config | ✅ Yes |
| `automations.yaml` | Automations | ✅ Yes |
| `scripts.yaml` | Scripts | ✅ Yes |
| `scenes.yaml` | Scenes | ✅ Yes |
| `blueprints/` | Automation/script blueprints | ✅ Yes |
| `secrets.yaml` | Secrets | ❌ No (gitignored) |
| `.storage/` | Internal HA storage (contains secrets) | ❌ No (gitignored) |
| `custom_components/` | HACS integrations | ❌ No (gitignored, HACS manages) |
| `*.db` | Databases | ❌ No (gitignored) |
| `www/` | Web assets | ❌ No (gitignored) |
| `deps/` | Python dependencies | ❌ No (gitignored) |

---

## Troubleshooting

### Merge Conflicts
If you edited the same file in both locations without pulling:
```bash
git pull
# Resolve conflicts in VS Code
git add .
git commit -m "Resolve merge conflict"
git push
```

### Authentication Issues on HA
If Git on HA can't push to GitHub:
- Use a GitHub Personal Access Token (PAT) instead of SSH
- Or set up SSH keys on HA for GitHub

---

*This document should be updated if the workflow changes.*
