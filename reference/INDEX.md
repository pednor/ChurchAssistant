# Reference Index — ChurchAssistant

This is the manifest for all reference docs in this repo. Load only what matches the current task's `agent_use` tag (max 2–3 docs per task).

## How to use this index

1. Identify the task type (automation work, dashboard work, diagnostics, etc.)
2. Filter rows where `agent_use` matches
3. Open at most 2–3 docs — never load the full reference directory

## Manifest

| Doc | Type | Status | agent_use |
|---|---|---|---|
| [system/HA_SYSTEM_REFERENCE.md](system/HA_SYSTEM_REFERENCE.md) | system | active | system-context, diagnostics, automation, dashboard, setup, hardware |

## Conventions

- **system/**: Ground truth of the current HA setup (e.g., `HA_SYSTEM_REFERENCE.md`)
- **research/**: Evaluated but not yet built
- **plans/**: Decided direction, actionable specs
- **guides/**: Operational how-to and setup docs
- **integrations/**: Built and verified integrations
- **incidents/**: Post-mortems and recovery records
- **assets/**: Support files (YAML, diagrams, configs)

Tag every new doc with `status:` (draft / active / completed / deprecated) and `agent_use:` (one or more of: automation, dashboard, diagnostics, setup, hardware, system-context, git-workflow).
