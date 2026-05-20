---
title: HA System Reference — ChurchAssistant
status: active
agent_use: [system-context, diagnostics, automation, dashboard, setup, hardware]
last_verified: 2026-05-19
---

# Home Assistant System Reference — ChurchAssistant

Canonical ground-truth snapshot of the ChurchAssistant HA install. Source: `mcp__ha-mcp__ha_get_system_health` on 2026-05-19.

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
- **Disk**: 10.8 GB used / 116.8 GB total
- **Timezone**: America/Chicago
- **LAN**: `192.168.1.22` on `end0`
- **Hostname**: `churchassistant`
- **HA instance ID**: `a634822447204c32a242eabce90550f8`

## Recorder / Database

- Engine: SQLite 3.49.2
- DB size: 51.4 MiB
- Oldest run: 2026-05-08 (≈11 days history)

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
| Tailscale | 0.28.1 |

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

## Zigbee

- **Stack**: ZHA (architectural intent is Z2M migration later — no date set)
- **Coordinator**: Home Assistant Connect ZBT-2 (Nabu Casa), IEEE `60:b7:63:ff:fe:5a:c7:8d`
- **End devices** (2):
  - **Sound Room Dual Outlet** (Third Reality 3RDP01072Z, IEEE `4c:e1:75:52:2e:4f:00:00`) — 2 sockets, both available, LQI 224
    - Left socket → `switch.sound_room_micwho_displays` ("MicWho Displays")
    - Right socket → `switch.sound_room_cabinet_lighting` ("Cabinet Lighting")
  - **MicWho Outlet** (Third Reality 3RSP02064Z, IEEE `4c:e1:75:52:e9:03:00:00`) — `unavailable` (intentionally unplugged, will be re-provisioned)

## Automations

| Entity | Alias | Trigger | Target |
|---|---|---|---|
| `automation.micwho_displays_on` | MicWho Displays On | Sun 07:00 | `switch.sound_room_micwho_displays` (turn_on) |
| `automation.micwho_displays_off` | MicWho Displays Off | Sun 13:30 | `switch.sound_room_micwho_displays` (turn_off) |

## MCP Server

- Add-on: HA MCP Server 7.5.0 (`homeassistant-ai/ha-mcp`)
- Endpoint: `http://churchassistant:9583/<secret-path>` (Streamable HTTP, Tailscale-routed)
- Client config: workspace-local `.mcp.json` (gitignored, per-Mac)
- Beta tool flags: **off** (filesystem tools, YAML config editing, custom-component integration)
- **HA Vibecode Agent add-on**: ❌ not yet installed — placeholder in `.mcp.json`

## Repo & Sync Bootstrap Status (2026-05-19)

- **Mac → GitHub**: ✅ working. Remote `origin = https://github.com/pednor/ChurchAssistant.git`, HTTPS + `osxkeychain` PAT.
- **HA → GitHub**: ✅ bootstrapped 2026-05-19. `/homeassistant` on church HA is a git checkout tracking `origin/main` via PAT-embedded HTTPS URL. `/ha-sync` and `/mac-sync` are now operable.
- **MCP**: ✅ ha-mcp wired (`.mcp.json` → add-on); Vibecode Agent pending.
