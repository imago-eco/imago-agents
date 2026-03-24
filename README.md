# OpenClaw Agent Kit

A ready-to-deploy 3-agent AI team for [OpenClaw](https://github.com/openclaw/openclaw). Battle-tested protocols for an orchestrator, builder, and researcher working together in Discord.

## What you get

- **Orchestrator** (Claude Opus) — coordinates tasks, manages the team, talks to you
- **Builder** (Claude Sonnet) — writes code, deploys, fixes bugs, works GitHub issues
- **Researcher** (Claude Sonnet) — investigates, analyzes, documents, literature review
- **Board of Truth** — GitHub issues → Discord status board, auto-updated 4x daily
- **Autonomous claiming** — agents pick up tasks from the GitHub board without you asking
- **Memory harvest pipeline** — agents remember across sessions, context never lost
- **Security scan** — daily automated security checks
- **Git backup** — nightly automated commits

## Quick start

### Prerequisites

- [OpenClaw](https://github.com/openclaw/openclaw) installed (`npm i -g openclaw`)
- [Anthropic API key](https://console.anthropic.com)
- A Discord server with 3 bot applications created ([guide](#creating-discord-bots))
- A GitHub account/org for issue tracking

### Setup

```bash
# Clone this repo
git clone https://github.com/imago-eco/openclaw-agent-kit.git
cd openclaw-agent-kit

# Run the setup script
./scripts/setup.sh
```

The setup script will ask for:
- Your name and timezone
- Discord server ID and user ID
- 3 Discord bot tokens
- Anthropic API key
- GitHub org/user (optional)
- Agent names (or accept defaults)

It generates a complete `openclaw.json` config and workspace directories ready to copy into `~/.openclaw/`.

### Manual setup

If you prefer to set things up yourself:

1. Copy `templates/openclaw.json.template` to `~/.openclaw/openclaw.json`
2. Replace all `{{PLACEHOLDER}}` values with your actual credentials
3. Copy `templates/workspace-*` directories to `~/.openclaw/`
4. Copy `templates/shared/` to `~/.openclaw/workspace/shared/`
5. Start OpenClaw: `openclaw gateway start`

## Creating Discord bots

You need 3 separate bot applications — one per agent.

1. Go to [Discord Developer Portal](https://discord.com/developers/applications)
2. Click **New Application** → name it (e.g., "Atlas", "Forge", "Scout")
3. Go to **Bot** tab → click **Reset Token** → copy the token
4. Enable these **Privileged Gateway Intents:**
   - Message Content Intent ✅
   - Server Members Intent ✅
5. Go to **OAuth2** → **URL Generator**:
   - Scopes: `bot`
   - Bot Permissions: `Send Messages`, `Read Message History`, `Add Reactions`, `Manage Messages`, `Use Slash Commands`
6. Copy the generated URL → open it → invite the bot to your server
7. Repeat for all 3 bots

## Project structure

```
├── README.md
├── scripts/
│   └── setup.sh                    # Interactive setup script
├── crons/
│   └── cron-templates.json         # Pre-built cron job definitions
├── templates/
│   ├── openclaw.json.template      # Config template with placeholders
│   ├── workspace-orchestrator/     # Orchestrator agent workspace
│   │   ├── AGENTS.md
│   │   ├── SOUL.md
│   │   ├── IDENTITY.md
│   │   ├── USER.md
│   │   ├── TOOLS.md
│   │   ├── HEARTBEAT.md
│   │   └── MEMORY.md
│   ├── workspace-builder/          # Builder agent workspace
│   │   └── (same structure)
│   ├── workspace-researcher/       # Researcher agent workspace
│   │   └── (same structure)
│   └── shared/                     # Shared docs (all agents read)
│       ├── docs/
│       │   ├── TEAM-PROTOCOL.md
│       │   ├── DISCORD_MENTION_IDS.md
│       │   ├── autonomous-claiming-protocol.md
│       │   └── agent-memory-protocol.md
│       ├── agent-index.md
│       └── knowledge-base.md
```

## Customization

### Adding more agents

Edit `openclaw.json` to add more agent entries. Each agent needs:
- An entry in `agents.list`
- A Discord bot token in `channels.discord.accounts`
- A binding in `bindings`
- A workspace directory

### Changing models

By default: Opus for orchestrator, Sonnet for workers. Change the `model` field in each agent's config. You can use any model OpenClaw supports.

### Different chat platform

This kit is configured for Discord. OpenClaw also supports Telegram, Slack, Signal, and others. Adapt the channel config accordingly.

## Origin

Built by [Imago](https://imago.eco) — extracted from our production multi-agent setup running since February 2026. These protocols have been refined through hundreds of real tasks across 9 repos.

## License

MIT
