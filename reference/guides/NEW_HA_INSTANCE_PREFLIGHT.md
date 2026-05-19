---
title: "New HA Instance Pre-Flight Checklist"
type: guide
status: active
tags: [setup, hostname, deployment, secondary-instance, churchassistant]
agent_use: [setup]
created: 2026-05-02
updated: 2026-05-02
summary: "Step-by-step config for a fresh HA instance before deploying it to its permanent location. Covers hostname rename to avoid mDNS conflict with primary `homeassistant.local`, baseline onboarding, app preload, remote access setup, and avoiding device bleed-over while on the prep network. Originally written for the church-location instance ('churchassistant')."
---

# New HA Instance Pre-Flight Checklist

Use this when you have a freshly-imaged HA instance on the same LAN as your primary (`homeassistant.local`) and need to fully prepare it before physical deployment elsewhere.

**Critical reminder:** **Do NOT "Restore from backup" during onboarding.** Cloning the prod instance inherits its hostname, secrets, and integration mess.

**Terminology note (HA 2026.x):** the UI calls them **"Apps"** instead of "Add-ons" now. The CLI (`ha addons ...`), Docker container names (`addon_core_*`), and integration slugs all still say `addon`. Only the user-facing label changed. This guide uses "Apps" for UI references and "addon" for technical/CLI references.

**Console-first preference:** if you have HDMI+keyboard or pre-configured SSH on the box, use the console for hostname rename **before** doing onboarding. Cleaner — avoids the mDNS conflict window entirely. See Phase 2 for both variants.

---

## Phase 1: Onboarding (first boot wizard)

Open `http://homeassistant.local:8123` (or the new instance's IP from your DHCP/UniFi clients list — gives you 30s before mDNS confusion).

1. **Create owner user** — unique credentials, do not reuse prod
2. **Home location** — lat/long of the **target site**, not your house
3. **Time zone** — match the target site's TZ
4. **Currency / unit system** — match prod for consistency
5. **Click "Finish"**

---

## Phase 2: Rename hostname (kill the .local conflict)

**Preferred — console-first (do BEFORE Phase 1 if console available):**

If you have HDMI+keyboard plugged into the new box, log into the HAOS console and run:
```bash
ha host options --hostname <new-hostname>
ha host reboot
```
After reboot, onboard at `http://<new-hostname>.local:8123` directly. No mDNS conflict, no rename-in-the-middle dance.

**Fallback — UI rename after onboarding:**

The HA 2026.x UI does NOT expose hostname change reliably (paths differ across versions and may be hidden). The CLI is the canonical method either way. After Phase 5 (SSH app installed), use:
```bash
ha host options --hostname <new-hostname>
ha host reboot
```
Either via the SSH app, the Web Terminal, or the local console.

After reboot, verify: reachable at `http://<new-hostname>.local:8123`. If mDNS doesn't pick it up, fall back to IP.

---

## Phase 3: Set instance name + URL

```
Settings → System → Home
```
(Older HA versions called this "General" — same page, just relabeled in 2026.x.)

- **Name** — display label (e.g. "Church Assistant")
- Confirm Country / Language / Time Zone / Elevation

```
Settings → System → Network
```
- **Internal URL** — leave blank for now; set at deployment site once LAN IP is known
- **External URL** — leave blank unless using Nabu Casa or your own domain

---

## Phase 4: System updates

```
Settings → System → Updates
```
Update HAOS, Core, Supervisor, all apps. Do this on fast wifi. Reboot if prompted.

---

## Phase 5: Preload essential apps

```
Settings → Apps → Apps Store
```

Typical preload:
- **Advanced SSH & Web Terminal** (Protection Mode off if Docker access desired; on if security-first) — pick the community one by `hassio-addons`, not the official "Terminal & SSH"
- **File Editor** (in-browser quick edits; skip if you'll always edit from a Mac with VSCode Remote-SSH)
- **Studio Code Server** (heavier, full VS Code in browser; skip if your dev workflow is Mac-side)
- **Mosquitto broker** if MQTT-bound devices will live there
- **ESPHome Device Builder** if you'll manage ESP devices on-site
- **HA MCP Server** if you want AI-agent / Claude integration via MCP (needs a long-lived access token)
- **Tailscale** *only if* you don't already have remote-access infrastructure (UniFi site-to-site VPN, Nabu Casa, etc.). Don't default-install — pick whatever fits the user's network stack
- Site-specific apps

For each: enable **Start on boot** + **Watchdog** in the app's Info tab.

---

## Phase 6: SSH access for remote support

If you'll manage remotely from elsewhere:
1. SSH app → Configuration → paste public SSH key into `authorized_keys` (key strongly preferred over password)
2. Save → Restart the app (Info tab → Restart) — keys aren't loaded until SSH daemon restarts
3. On your Mac: add a `~/.ssh/config` entry for shorthand:
   ```
   Host <hostname>
       HostName <hostname>.local
       User hassio
       Port 22
       IdentityFile ~/.ssh/<your-ha-key>
   ```
4. Verify with `ssh <hostname>` from the Mac

**Gotchas observed:**
- Default user for the hassio-addons SSH app is `hassio`, NOT `root` — root login fails with "permission denied (publickey)" even with key auth working for hassio
- The `ha` CLI throws "missing or invalid API token" when invoked over SSH (not via HA Web Terminal). For supervisor commands, use the Web Terminal in the HA sidebar instead
- App must be explicitly **Started** after install — doesn't auto-start

---

## Phase 7: Remote access strategy

Pick one or layer multiple before deployment so you have a working remote-access path day one. Use whatever the user's existing network infrastructure supports.

| Tier | Tool | When |
|---|---|---|
| Primary (UI) | **Nabu Casa Cloud Remote** (per-instance ~$6.50/mo) | Daily UI access from anywhere, also unlocks Cloud STT/TTS |
| Network-level | **UniFi site-to-site VPN** (UDM ↔ UDM), or other VPN at the router layer | Full LAN reachability — SSH, MCP, anything |
| Mesh VPN | **Tailscale** (free for personal) | If no router-level VPN; per-device install |
| Backup / on-site | **Travel router** | Local-only manual sessions |

Don't default to a single recommendation — match what the user's stack already supports.

```
Settings → Home Assistant Cloud  ← only if going Nabu Casa
```

---

## Phase 8: Disable auto-discovery bleed-over (CRITICAL on prep network)

While on the home LAN, this instance will auto-discover **everything** on your network via HomeKit / mDNS / DHCP. **Ignore all of it.**

```
Settings → Devices & Services → Discovered (top of list) → Ignore each
```

You do **not** want this instance entangled with the home gear. The point is a clean slate.

---

## Phase 9: Add only generic / portable integrations now

Safe to add on prep network (location-portable):
- **Weather** — Met.no or NWS, configured for the **target site's** lat/long
- **Sun** — uses target lat/long
- **Calendar** integrations not tied to local hardware

Skip anything device-specific until at the deployment site.

---

## Phase 10: Baseline backup BEFORE moving

```
Settings → System → Backups → Create backup
```
- Name: `Pre-install fresh <hostname>`
- **Download to Mac** as a safety net. If something corrupts at deploy site, restore here.

---

## Phase 11: Document before disconnecting

Write down (or save in a password manager):

- [ ] Hostname: `<new-hostname>`
- [ ] Owner username + password
- [ ] Location lat/long set: yes/no
- [ ] Time zone confirmed
- [ ] Updates current
- [ ] Apps preloaded (list)
- [ ] SSH key/password set
- [ ] Cloud: subscribed / skipped / Tailscale
- [ ] Backup downloaded (filename)

---

## At deployment site (post-install)

1. **Confirm DHCP** — verify stable IP. **Set a DHCP reservation** for it on the site's router.
2. **Test `<hostname>.local`** — works if site's LAN doesn't block mDNS. If it does, use IP.
3. **Update Internal URL** in Settings → System → Network with the stable LAN IP/hostname for that site.
4. **Add device-specific integrations** — Zigbee/Thread dongle pair, ESPHome devices on that LAN, cameras, etc.
5. **Test remote access** — SSH/Tailscale/Cloud from a phone to confirm reachable from outside the site.

---

## Gotchas & lessons

- **mDNS conflict** is the #1 reason to do this prep. Two `homeassistant.local` instances on the same LAN race for the name and break each other.
- **DO NOT restore from your prod backup** — explained above. Always start fresh on a new instance.
- **Don't add device-specific integrations on the prep network.** The integrations remember device IDs / IPs / unique_ids; once at the target site, those references won't match local hardware. Restart fresh at deployment.
- **Nabu Casa is per-instance.** Plan licensing before deployment; remote access is much harder to retrofit later if you skip it.
- **HACS** can be installed on prep network safely — it talks only to GitHub + the local HA API, doesn't entangle with discovery.
- **Apps** (formerly "Add-ons") preloaded on prep network work fine post-move; their config is local to the instance and doesn't depend on hostname.
- **Hostname rename** is reliable only via CLI in 2026.x (`ha host options --hostname X && ha host reboot`). UI paths shift between versions.

---

## Current Build Status — Churchassistant (2026-05-02)

Live status of the church-location instance. Update as work progresses.

### Phase 1 — Onboarding ✅
- Owner user created (unique credentials, not reused from prod)
- Location: Calvary Church, Bentonville (lat 36.37324, lng -94.17872, elev 395m)
- Time zone, currency, units set

### Phase 2 — Hostname rename ✅
- Renamed via `ha host options --hostname churchassistant` + reboot
- Reachable at `churchassistant.local` (and `192.168.0.246` on home prep LAN)

### Phase 3 — Display name ✅
- Set to "Church Assistant" via `Settings → System → Home`

### Phase 4 — Updates ✅
- All current as of 2026-05-02; no pending updates at first check

### Phase 5 — Apps installed ✅ (some configuration pending)
- ✅ **Advanced SSH & Web Terminal** — installed, configured with Mac SSH key (`ha_key`), connection verified as `hassio@churchassistant.local`
- ✅ **File Editor** — installed
- ✅ **Mosquitto broker** — installed; **mqtt user/password not yet configured**
- ✅ **ESPHome Device Builder** — installed; not configured
- ✅ **HA MCP Server** — installed; **long-lived access token not yet generated/configured**
- ✅ **HACS** — installed via shell (`wget -O - https://get.hacs.xyz | sudo bash -`), integration added, GitHub OAuth completed
- ❌ **Tailscale** — skipped (using Nabu Casa + UniFi instead)
- ❌ **Studio Code Server** — skipped (Mac VSCode workflow)

### Phase 6 — SSH access ✅
- Mac `~/.ssh/config` entry added for `churchassistant` shorthand alias
- Verified `ssh churchassistant` works key-based

### Phase 7 — Remote access (PENDING decision/setup)
- **Plan**: Nabu Casa Cloud Remote (primary) + UniFi site-to-site VPN (secondary) + travel router (backup)
- **Status**: not yet set up — Nabu Casa sub not started, UniFi VPN not configured

### Phase 8 — Auto-discovery ignored ✅
- All home-LAN auto-discovered devices dismissed/ignored

### Phase 9 — Generic integrations ⚠️ (partial)
- Defaults present: Sun, Met.no weather, Backup, Bluetooth, Matter, Thread, Pi Power Supply Checker, Radio Browser, Shopping List, Google Translate TTS
- No additional manual integrations added yet

### Phase 10 — Baseline backup ❌ PENDING
- Not yet taken. Do before disconnecting from home LAN.

### Phase 11 — Documentation ❌ PENDING
- Owner credentials, hostname, IP, etc. not yet captured in password manager

### At-deployment Tier 2 (post-move) — DEFERRED
- Static IP / DHCP reservation on church router
- Update Internal URL to church LAN address
- Zigbee dongle pair (ZBT-2 ordered, awaiting arrival; will run **Zigbee2MQTT** rather than ZHA per architecture decision)
- Smart plug / light brand selection still TBD
- Long-term: Google Nest thermostats, Bitfocus Companion integration, AI agent in middle
