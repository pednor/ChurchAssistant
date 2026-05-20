# Documentation Maintenance (Proactive)

Keep docs current without being asked. After completing any task that changes the system:

| If you... | Then update... |
|-----------|---------------|
| Add/remove/rename an automation | `system/HA_SYSTEM_REFERENCE.md` automation table |
| Add/remove a device or integration | `system/HA_SYSTEM_REFERENCE.md` integrations + device sections |
| Add/remove an area | `system/HA_SYSTEM_REFERENCE.md` areas table |
| Install/update an add-on or HACS repo | `system/HA_SYSTEM_REFERENCE.md` add-ons/HACS tables |
| Complete a plan or research item | Set `status: completed` in that doc's frontmatter |
| Add a new integration | Create doc in `integrations/` + add to `INDEX.md` |
| Add any new reference doc | Add to `reference/INDEX.md` with correct `agent_use` tags |
| Change HA version / HAOS / hardware | Update `HA_SYSTEM_REFERENCE.md` system overview |

**After any doc update: commit and push.** Keep `INDEX.md` accurate — it's the agent entry point.
