---
title: HA System Reference — ChurchAssistant
status: active
agent_use: [system-context, diagnostics, automation, dashboard, setup, hardware]
last_verified: 2026-05-13
---

# Home Assistant System Reference — ChurchAssistant

Canonical ground-truth snapshot of the ChurchAssistant HA install. Source: `mcp__ha-mcp__ha_get_system_health` on 2026-05-13.

## System

| Component | Version |
|---|---|
| HA Core | 2026.5.1 |
| HAOS | 17.3 (channel: stable) |
| Supervisor | 2026.05.0 |
| OS Agent | 1.8.1 |
| Docker | 29.3.1 |
| Python | 3.14.2 |

## Hardware

- **Board**: `rpi5-64` (Raspberry Pi 5, aarch64)
- **Kernel**: `6.12.75-haos-raspi`
- **Disk**: 10.4 GB used / 116.8 GB total
- **Timezone**: America/Chicago
- **LAN**: `192.168.1.22` on `end0`
- **Hostname**: `churchassistant`
- **HA instance ID**: `a634822447204c32a242eabce90550f8`

## Recorder / Database

- Engine: SQLite 3.49.2
- DB size: 2.59 MiB
- Oldest run: 2026-05-03 (≈10 days history)

## Nabu Casa

- Subscription expires: 2026-06-09
- Region: `us-east-1` (remote_server `us-east-1-20.ui.nabu.casa`)
- Remote access: enabled + connected
- Alexa integration: enabled
- Google Assistant integration: enabled
- Cloud ICE servers: enabled
- Manage: `/config/cloud`

## HACS

- Version: 2.0.5
- Downloaded repositories: 2
- Stage: running

## Add-ons

| Slug / Name | Version |
|---|---|
| Matter Server | 8.4.0 |
| Advanced SSH & Web Terminal | 23.0.9 |
| Mosquitto broker | 7.1.0 |
| ESPHome Device Builder | 2026.4.5 |
| Home Assistant MCP Server (`homeassistant-ai/ha-mcp`) | 7.5.0 |

## Custom Components

- `hacs`
- `ha_mcp_tools` — optional supplement for the MCP Server add-on (filesystem / YAML editing tools, currently disabled by env flag)

## Integrations (config-entry domains)

`apple_tv`, `backup`, `bluetooth`, `cloud`, `dlna_dmr`, `ecobee`, `esphome`, `go2rtc`, `google_translate`, `hacs`, `hassio`, `homeassistant_connect_zbt2`, `hue`, `ipp`, `matter`, `met`, `mobile_app`, `mqtt`, `nest`, `radio_browser`, `raspberry_pi`, `rpi_power`, `samsungtv`, `shopping_list`, `sonos`, `sun`, `thread`, `unifi`, `unifi_access`, `unifiprotect`, `wemo`, `wiz`, `zha`

Total config entries: 55 (multiple per device for Sonos / UniFi / etc.).

## Lovelace / Dashboards

- Mode: `storage`
- Dashboards: 2
- Resources: 0
- Views: 0 (skeleton — UI not yet built out)

## MCP Server

- Add-on: HA MCP Server 7.5.0 (`homeassistant-ai/ha-mcp`)
- Endpoint: `http://churchassistant:9583/<secret-path>` (Streamable HTTP)
- Client config: workspace-local `.mcp.json` (gitignored)
- Beta tool flags: **off** (filesystem tools, YAML config editing, custom-component integration)

## Repo & Sync Bootstrap Status (2026-05-13)

- **Mac → GitHub**: working. Remote `origin = https://github.com/pednor/ChurchAssistant.git`, HTTPS + `osxkeychain` PAT.
- **HA → GitHub**: ❌ not yet bootstrapped. `/homeassistant` on the Pi is **not** a git checkout — `/ha-sync` and `/mac-sync` skills cannot operate until this is done.
- **MCP**: ✅ wired (`.mcp.json` → ha-mcp add-on).
