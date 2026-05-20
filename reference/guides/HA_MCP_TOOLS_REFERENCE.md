---
title: "HA MCP Tools Reference"
type: guide
status: active
tags: [mcp, ha-mcp, tools, api]
agent_use: [system-context, diagnostics, automation, dashboard]
created: 2026-02-13
updated: 2026-04-03
summary: "Complete reference for ha-mcp and home-assistant MCP server tools. Load when selecting or using MCP tools."
verified_against:
  ha-mcp: "7.1.0"
  home-assistant: "2.10.40"
---

# Home Assistant MCP Tools Reference

## Overview

The **HA Vibecode Agent** MCP server enables AI assistants (Copilot, Cursor, Claude) to interact with Home Assistant through a safe, well-defined API. This replaces ad-hoc terminal commands with structured tool calls.

**Source:** https://github.com/Coolver/home-assistant-vibecode-agent

---

## Tool Categories

### 🔍 Entity & State Management

| Tool | Purpose | Read/Write |
|------|---------|------------|
| `ha_list_entities` | List entities with optional filters, pagination | READ |
| `ha_get_entity_state` | Get entity state and attributes | READ |
| `ha_get_entity_registry` | Get all entities with metadata | READ |
| `ha_get_entity_registry_entry` | Get single entity metadata | READ |
| `ha_update_entity_registry` | Update entity (name, area, icon) | WRITE |
| `ha_rename_entity` | Rename entity_id | WRITE |
| `ha_remove_entity_registry_entry` | Remove entity from registry | WRITE |

### 🏠 Area & Device Management

| Tool | Purpose | Read/Write |
|------|---------|------------|
| `ha_get_area_registry` | Get all areas | READ |
| `ha_get_area_registry_entry` | Get single area | READ |
| `ha_create_area` | Create new area | WRITE |
| `ha_update_area` | Update area | WRITE |
| `ha_delete_area` | Delete area | WRITE |
| `ha_get_device_registry` | Get all devices | READ |
| `ha_get_device_registry_entry` | Get single device with entities | READ |
| `ha_update_device_registry` | Update device | WRITE |
| `ha_remove_device_registry_entry` | Remove device | WRITE |

### ⚡ Automations

| Tool | Purpose | Read/Write |
|------|---------|------------|
| `ha_list_automations` | List all automations | READ |
| `ha_get_automation` | Get single automation config | READ |
| `ha_create_automation` | Create new automation | WRITE |
| `ha_update_automation` | Update existing automation | WRITE |
| `ha_delete_automation` | Delete automation | WRITE |

### 📜 Scripts

| Tool | Purpose | Read/Write |
|------|---------|------------|
| `ha_list_scripts` | List all scripts | READ |
| `ha_get_script` | Get single script config | READ |
| `ha_create_script` | Create new script | WRITE |
| `ha_update_script` | Update existing script | WRITE |
| `ha_delete_script` | Delete script | WRITE |

### 🔧 Helpers

| Tool | Purpose | Read/Write |
|------|---------|------------|
| `ha_list_helpers` | List all helpers | READ |
| `ha_create_helper` | Create helper (input_boolean, input_number, etc.) | WRITE |
| `ha_delete_helper` | Delete helper | WRITE |

**Helper types:** `input_boolean`, `input_text`, `input_number`, `input_datetime`, `input_select`, `group`, `utility_meter`

### 🎨 Themes

| Tool | Purpose | Read/Write |
|------|---------|------------|
| `ha_list_themes` | List available themes | READ |
| `ha_get_theme` | Get theme config | READ |
| `ha_check_theme_config` | Check if themes configured | READ |
| `ha_create_theme` | Create new theme | WRITE |
| `ha_update_theme` | Update theme | WRITE |
| `ha_delete_theme` | Delete theme | WRITE |
| `ha_reload_themes` | Reload themes | WRITE |

### 📊 Dashboards

| Tool | Purpose | Read/Write |
|------|---------|------------|
| `ha_preview_dashboard` | View current dashboard config | READ |
| `ha_analyze_entities_for_dashboard` | Get entities grouped for dashboard generation | READ |
| `ha_apply_dashboard` | Apply generated dashboard | WRITE |
| `ha_delete_dashboard` | Delete dashboard | WRITE |

### 🔌 Services & Actions

| Tool | Purpose | Read/Write |
|------|---------|------------|
| `ha_call_service` | Call any HA service | WRITE |

**Examples:**
- `light.turn_on` with target `{"entity_id": "light.living_room"}`
- `climate.set_temperature` with service_data `{"temperature": 72}`
- `notify.mobile_app_xxx` with message data

### 📁 File Management

| Tool | Purpose | Read/Write |
|------|---------|------------|
| `ha_list_files` | List files in /config directory | READ |
| `ha_read_file` | Read file contents | READ |
| `ha_write_file` | Write file | WRITE |
| `ha_delete_file` | Delete file | WRITE |

### 💾 Git Versioning

| Tool | Purpose | Read/Write |
|------|---------|------------|
| `ha_git_history` | View commit history | READ |
| `ha_git_diff` | Show differences between commits | READ |
| `ha_git_pending` | Show uncommitted changes | READ |
| `ha_git_commit` | Commit current changes | WRITE |
| `ha_git_rollback` | Rollback to specific commit | WRITE |
| `ha_create_checkpoint` | Create checkpoint before changes | WRITE |
| `ha_end_checkpoint` | End checkpoint processing | WRITE |

### 🔌 Add-on Management

| Tool | Purpose | Read/Write |
|------|---------|------------|
| `ha_list_addons` | List available add-ons | READ |
| `ha_list_installed_addons` | List installed add-ons | READ |
| `ha_list_store_addons` | List all store add-ons | READ |
| `ha_addon_info` | Get add-on details | READ |
| `ha_addon_logs` | Get add-on logs | READ |
| `ha_get_addon_options` | Get add-on config | READ |
| `ha_install_addon` | Install add-on | WRITE |
| `ha_uninstall_addon` | Uninstall add-on | WRITE |
| `ha_start_addon` | Start add-on | WRITE |
| `ha_stop_addon` | Stop add-on | WRITE |
| `ha_restart_addon` | Restart add-on | WRITE |
| `ha_update_addon` | Update add-on | WRITE |
| `ha_set_addon_options` | Configure add-on | WRITE |
| `ha_list_repositories` | List add-on repositories | READ |
| `ha_add_repository` | Add repository | WRITE |

### 📦 HACS Management

| Tool | Purpose | Read/Write |
|------|---------|------------|
| `ha_hacs_status` | Check if HACS installed | READ |
| `ha_hacs_list_repositories` | List HACS repositories | READ |
| `ha_hacs_search` | Search HACS repositories | READ |
| `ha_hacs_repository_details` | Get repository details | READ |
| `ha_install_hacs` | Install HACS | WRITE |
| `ha_uninstall_hacs` | Uninstall HACS | WRITE |
| `ha_hacs_install_repository` | Install from HACS | WRITE |
| `ha_hacs_update_all` | Update all HACS repos | WRITE |

### 🔄 System Operations

| Tool | Purpose | Read/Write |
|------|---------|------------|
| `ha_check_config` | Validate HA configuration | READ |
| `ha_reload_config` | Reload configuration component | WRITE |
| `ha_restart` | Full HA restart | WRITE |
| `ha_get_logs` | Get agent logs | READ |
| `ha_logbook_entries` | Get logbook entries | READ |
| `ha_find_dead_entities` | Find orphaned entities | READ |

---

## Best Practices

### 1. Always Use Checkpoints for Major Changes
```
1. ha_create_checkpoint("Adding new climate automation")
2. Make changes...
3. ha_end_checkpoint()
```

### 2. Validate Before Applying
- Use `ha_check_config` before `ha_restart`
- Test automations with `ha_call_service` on `automation.trigger`

### 3. Provide Descriptions for Commits
All WRITE tools that modify config accept a `description` parameter for meaningful git commits.

### 4. Use READ Tools First
Before creating/updating, query existing state to understand the current setup.

### 5. Pagination for Large Queries
`ha_list_entities` supports:
- `page` / `page_size` for pagination
- `domain` filter
- `search` for substring matching
- `ids_only` or `summary_only` for lightweight queries

---

## Common Workflows

### Create an Automation
```python
ha_create_automation(
    config={
        "id": "my_automation_id",
        "alias": "My Automation",
        "description": "What it does",
        "triggers": [...],
        "conditions": [...],
        "actions": [...],
        "mode": "single"
    },
    description="Brief description for git commit"
)
```

### Create a Helper
```python
ha_create_helper(
    type="input_boolean",
    config={"name": "My Toggle"},
    description="Enable/disable feature X"
)
```

### Call a Service
```python
ha_call_service(
    domain="light",
    service="turn_on",
    target={"entity_id": "light.living_room"},
    service_data={"brightness": 255}
)
```

### Rollback Changes
```python
# View history
ha_git_history(limit=10)

# Rollback to specific commit
ha_git_rollback(commit_hash="abc123")
```

---

## Safety Notes

1. **All WRITE operations require approval** in the agent workflow
2. **Git versioning is automatic** — every change is committed
3. **Rollback is always available** via `ha_git_rollback`
4. **File operations restricted** to `/config` directory only
5. **Destructive operations marked** with ⚠️ in tool descriptions

---

## Comparison: MCP Tools vs Terminal/REST API

| Aspect | MCP Tools | Terminal + REST API |
|--------|-----------|---------------------|
| Safety | Built-in git versioning | Manual backup required |
| Rollback | One command | Manual git operations |
| Validation | Automatic before apply | Must call separately |
| Auth | Handled by MCP server | Manual token management |
| Commit messages | Auto-generated | None |
| Error handling | Structured responses | Parse stdout/stderr |

---

## References

- GitHub: https://github.com/Coolver/home-assistant-vibecode-agent
- NPM Package: https://www.npmjs.com/package/@coolver/home-assistant-mcp
- HA Integration Docs: https://www.home-assistant.io/integrations/
