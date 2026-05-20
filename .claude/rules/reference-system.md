# Reference Documentation System

All reference docs live in `reference/` organized by type:

```
reference/
├── INDEX.md           ← START HERE — manifest of all docs with agent_use tags
├── system/            ← Ground truth of the current HA setup
├── research/          ← Evaluated but not yet built
├── plans/             ← Decided direction, actionable specs
├── guides/            ← Operational how-to and setup docs
├── integrations/      ← Built and verified integrations
├── incidents/         ← Post-mortems and recovery records
└── assets/            ← Support files (YAML, diagrams, configs)
```

## Agent Document Loading Rules

1. **Always read `reference/INDEX.md` first** before loading any reference doc
2. **Filter by `agent_use`** — only load docs matching the current task context
3. **Load max 2–3 docs** per task — do not load the full reference directory
4. **Check `status` before acting** — skip `deprecated` docs, treat `draft` as unconfirmed
5. **If you can't find relevant data in 5 tool calls** — stop, summarize what was found, ask the user

## Agent Use Contexts

| Task | Load these contexts |
|------|-------------------|
| Building/editing automations | `automation` + `system-context` |
| Building/editing dashboards | `dashboard` + `system-context` |
| Diagnosing issues | `diagnostics` + `system-context` |
| Installing integrations | `setup` + matching integration tag |
| Hardware research | `hardware` |
| Git operations | `git-workflow` |
