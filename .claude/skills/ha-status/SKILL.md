---
skill: ha-status
command: /ha-status
description: "Quick current state snapshot — presence, doors, any open alerts (churchassistant)"
agent_use: [diagnostics, system-context]
reference_docs:
  - reference/INDEX.md
  - reference/system/HA_SYSTEM_REFERENCE.md
max_tool_calls: 5
---

# Skill: HA Status (ChurchAssistant)

## Goal

Fast current-state snapshot. Bounded to 5 tool calls.

> **Setup needed:** the entity list below is empty until ChurchAssistant has people, doors, or alert entities configured. Update `## Entities` once the system is set up, mirroring the structure used by the home repo's `ha-status` skill.

## Steps

1. **Presence** — get state of person entities (none yet).
2. **Doors / openings** — get state of relevant cover/contact entities (none yet).
3. **Alerts** — check persistent notifications via `ha_get_overview(include_notifications: true)`.
4. **Compile report** — format as output template below.

## Entities

_To be filled in after initial setup. Format mirrors home repo:_

```
Presence: person.<name>, ...
Doors:    cover.<name>, ...
Alerts:   counter.<name>, sensor.<name>, ...
```

## Output Format

```
## ChurchAssistant Status — [time]

### Who's Here
- (no person entities configured)

### Doors / Openings
- (none configured)

### Alerts
- Persistent notifications: [list or none]
```

## Stop Conditions

- Hard stop at 5 tool calls — this skill is intentionally minimal
- If an entity is unavailable, note it and move on — do not investigate
