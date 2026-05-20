---
title: "HA MCP Server Setup"
type: guide
status: active
tags: [mcp, setup, ha-mcp, config]
agent_use: [setup]
created: 2026-02-13
updated: 2026-02-13
summary: "How to configure and connect the HA MCP server to Claude Code. Setup steps, auth, troubleshooting."
---

# MCP Server Setup Reference

Two MCP servers connect Claude Code to Home Assistant. Each has different auth and connection requirements.

## ha-mcp (homeassistant-ai/ha-mcp)

**What it is:** HA add-on that exposes ~90 tools via HTTP.

**Connection config:**

```json
{
  "ha-mcp": {
    "url": "http://homeassistant.local:9583/<secret_path>",
    "type": "http"
  }
}
```

**Key details:**
- Auth is embedded in the URL path (128-bit secret) — no API key or token needed
- The `"type"` field **must** be `"http"` — not `"sse"` or `"streamable-http"`. Without it, Claude Code may auto-negotiate streamable-http which triggers unwanted OAuth browser auth
- Get the full URL (including secret path) from: **HA → Settings → Add-ons → Home Assistant MCP Server → Open Web UI**

**Install the add-on:**
1. HA → Settings → Add-ons → Add-on Store → Repositories
2. Add: `https://github.com/homeassistant-ai/ha-mcp`
3. Install "Home Assistant MCP Server", enable "Start on boot", start it

---

## home-assistant (@coolver/home-assistant-mcp)

**What it is:** NPX-based local MCP server that talks to the HA Vibecode Agent add-on (~77 tools).

**Connection config:**

```json
{
  "home-assistant": {
    "command": "npx",
    "args": ["-y", "@coolver/home-assistant-mcp@latest"],
    "env": {
      "HA_AGENT_URL": "http://homeassistant.local:8099",
      "HA_AGENT_KEY": "<agent_key>"
    }
  }
}
```

**Key details:**
- `HA_AGENT_KEY` is the add-on's **own API key** — it is NOT a Home Assistant long-lived access token. They look completely different:
  - Vibecode Agent key: `bsJYml7BJ5-c2-omjVD3JFJQj3rrByMpB0k_1qfgcrU` (short, base64-ish)
  - HA long-lived access token: `eyJhbGciOiJIUzI1NiIs...` (long JWT)
- Get the correct key from: **HA → Settings → Add-ons → HA Vibecode Agent → Open Web UI** (check the setup tab for your IDE)
- Use `homeassistant.local` for the URL, not a raw IP address
- Health check (no auth): `curl http://homeassistant.local:8099/api/health`
- API docs available at: `http://homeassistant.local:8099/docs`

**Install the add-on:**
1. HA → Settings → Add-ons → Add-on Store → Repositories
2. Add: `https://github.com/coolver/home-assistant-vibecode-agent`
3. Install "HA Vibecode Agent", enable "Start on boot", start it

---

## Putting it together

Full `.mcp.json` for Claude Code:

```json
{
  "mcpServers": {
    "ha-mcp": {
      "url": "http://homeassistant.local:9583/<secret_path>",
      "type": "http"
    },
    "home-assistant": {
      "command": "npx",
      "args": ["-y", "@coolver/home-assistant-mcp@latest"],
      "env": {
        "HA_AGENT_URL": "http://homeassistant.local:8099",
        "HA_AGENT_KEY": "<agent_key_from_addon_web_ui>"
      }
    }
  }
}
```

---

## Troubleshooting

| Symptom | Cause | Fix |
|---|---|---|
| ha-mcp triggers OAuth/browser auth | Missing or wrong `"type"` field | Set `"type": "http"` in config |
| home-assistant returns "Invalid API key" | Using HA long-lived access token instead of agent key | Get the correct key from the Vibecode Agent add-on Web UI |
| Changes to `.mcp.json` not taking effect | MCP server processes cached in memory | Restart Claude Code (`/exit` and relaunch) |
| Connection refused on port 8099/9583 | Add-on not running | Check HA → Settings → Add-ons, start the add-on |
| Host unreachable | Wrong hostname/IP | Use `homeassistant.local` or verify IP with `ping` |

## Verification

Test both servers after setup:

```bash
# Vibecode Agent health (no auth needed)
curl http://homeassistant.local:8099/api/health

# ha-mcp (secret path acts as auth)
curl http://homeassistant.local:9583/<secret_path>
```

In Claude Code, use any read-only tool (e.g., get `sun.sun` entity state) to confirm both servers respond.
