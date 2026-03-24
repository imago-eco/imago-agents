#!/bin/bash
set -e

echo "================================================"
echo "  OpenClaw Agent Kit — 3-Agent Setup"
echo "  https://github.com/imago-eco/openclaw-agent-kit"
echo "================================================"
echo ""

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
KIT_DIR="$(dirname "$SCRIPT_DIR")"
OPENCLAW_DIR="${HOME}/.openclaw"

# --- Gather info ---

read -p "Your name: " USER_NAME
read -p "Your timezone (e.g., Europe/Stockholm): " TIMEZONE
read -p "Your Discord user ID: " USER_DISCORD_ID
read -p "Discord server (guild) ID: " GUILD_ID
echo ""

echo "Channel IDs (create these channels in your Discord server first):"
read -p "  #general channel ID: " GENERAL_CHANNEL_ID
read -p "  #system channel ID: " SYSTEM_CHANNEL_ID
read -p "  #builder channel ID: " BUILDER_CHANNEL_ID
read -p "  #researcher channel ID: " RESEARCHER_CHANNEL_ID
echo ""

echo "Bot tokens (from Discord Developer Portal):"
read -sp "  Orchestrator bot token: " ORCHESTRATOR_BOT_TOKEN
echo ""
read -sp "  Builder bot token: " BUILDER_BOT_TOKEN
echo ""
read -sp "  Researcher bot token: " RESEARCHER_BOT_TOKEN
echo ""
echo ""

echo "Bot application IDs (from Discord Developer Portal → General Information):"
read -p "  Orchestrator bot ID: " ORCHESTRATOR_BOT_ID
read -p "  Builder bot ID: " BUILDER_BOT_ID
read -p "  Researcher bot ID: " RESEARCHER_BOT_ID
echo ""

read -p "Orchestrator name (default: Atlas): " ORCHESTRATOR_NAME
ORCHESTRATOR_NAME=${ORCHESTRATOR_NAME:-Atlas}
read -p "Builder name (default: Forge): " BUILDER_NAME
BUILDER_NAME=${BUILDER_NAME:-Forge}
read -p "Researcher name (default: Scout): " RESEARCHER_NAME
RESEARCHER_NAME=${RESEARCHER_NAME:-Scout}
echo ""

read -sp "Anthropic API key: " ANTHROPIC_API_KEY
echo ""
read -p "Brave Search API key (optional, press Enter to skip): " BRAVE_API_KEY
echo ""

# --- Generate config and workspaces ---

echo "Generating configuration..."

# Create directories
mkdir -p "$OPENCLAW_DIR/workspace/shared/docs"
mkdir -p "$OPENCLAW_DIR/workspace/shared/memory"
mkdir -p "$OPENCLAW_DIR/workspace/memory"
mkdir -p "$OPENCLAW_DIR/workspace-builder/memory"
mkdir -p "$OPENCLAW_DIR/workspace-researcher/memory"
mkdir -p "$OPENCLAW_DIR/agents/builder/sessions"
mkdir -p "$OPENCLAW_DIR/agents/researcher/sessions"

# Function to replace placeholders
replace_placeholders() {
  sed \
    -e "s|{{USER_NAME}}|${USER_NAME}|g" \
    -e "s|{{TIMEZONE}}|${TIMEZONE}|g" \
    -e "s|{{USER_DISCORD_ID}}|${USER_DISCORD_ID}|g" \
    -e "s|{{GUILD_ID}}|${GUILD_ID}|g" \
    -e "s|{{GENERAL_CHANNEL_ID}}|${GENERAL_CHANNEL_ID}|g" \
    -e "s|{{SYSTEM_CHANNEL_ID}}|${SYSTEM_CHANNEL_ID}|g" \
    -e "s|{{BUILDER_CHANNEL_ID}}|${BUILDER_CHANNEL_ID}|g" \
    -e "s|{{RESEARCHER_CHANNEL_ID}}|${RESEARCHER_CHANNEL_ID}|g" \
    -e "s|{{ORCHESTRATOR_BOT_TOKEN}}|${ORCHESTRATOR_BOT_TOKEN}|g" \
    -e "s|{{BUILDER_BOT_TOKEN}}|${BUILDER_BOT_TOKEN}|g" \
    -e "s|{{RESEARCHER_BOT_TOKEN}}|${RESEARCHER_BOT_TOKEN}|g" \
    -e "s|{{ORCHESTRATOR_BOT_ID}}|${ORCHESTRATOR_BOT_ID}|g" \
    -e "s|{{BUILDER_BOT_ID}}|${BUILDER_BOT_ID}|g" \
    -e "s|{{RESEARCHER_BOT_ID}}|${RESEARCHER_BOT_ID}|g" \
    -e "s|{{ORCHESTRATOR_NAME}}|${ORCHESTRATOR_NAME}|g" \
    -e "s|{{BUILDER_NAME}}|${BUILDER_NAME}|g" \
    -e "s|{{RESEARCHER_NAME}}|${RESEARCHER_NAME}|g" \
    -e "s|{{OPENCLAW_DIR}}|${OPENCLAW_DIR}|g" \
    "$1"
}

# Generate config
replace_placeholders "$KIT_DIR/templates/openclaw.json.template" > "$OPENCLAW_DIR/openclaw.json"

# Add Anthropic API key to auth
# (OpenClaw reads this from its own key store, but we ensure it's configured)
if command -v openclaw &> /dev/null; then
  echo "Configuring Anthropic API key..."
  openclaw configure --set auth.profiles.anthropic:default.apiKey="$ANTHROPIC_API_KEY" 2>/dev/null || true
fi

# Copy and fill workspace templates
for dir in workspace-orchestrator workspace-builder workspace-researcher; do
  target_dir="$OPENCLAW_DIR/${dir/orchestrator/}" 
  # Map orchestrator → workspace (main agent)
  if [ "$dir" = "workspace-orchestrator" ]; then
    target_dir="$OPENCLAW_DIR/workspace"
  fi
  
  for f in "$KIT_DIR/templates/$dir"/*.md; do
    [ -f "$f" ] || continue
    filename=$(basename "$f")
    replace_placeholders "$f" > "$target_dir/$filename"
  done
done

# Copy shared docs
for f in "$KIT_DIR/templates/shared/docs"/*.md; do
  [ -f "$f" ] || continue
  filename=$(basename "$f")
  replace_placeholders "$f" > "$OPENCLAW_DIR/workspace/shared/docs/$filename"
done

for f in "$KIT_DIR/templates/shared"/*.md; do
  [ -f "$f" ] || continue
  filename=$(basename "$f")
  replace_placeholders "$f" > "$OPENCLAW_DIR/workspace/shared/$filename"
done

# Set permissions
chmod 600 "$OPENCLAW_DIR/openclaw.json"

echo ""
echo "================================================"
echo "  ✅ Setup complete!"
echo "================================================"
echo ""
echo "Config:     $OPENCLAW_DIR/openclaw.json"
echo "Workspace:  $OPENCLAW_DIR/workspace/"
echo "Builder:    $OPENCLAW_DIR/workspace-builder/"
echo "Researcher: $OPENCLAW_DIR/workspace-researcher/"
echo ""
echo "Next steps:"
echo "  1. Start OpenClaw:  openclaw gateway start"
echo "  2. Say hello in #general on your Discord server"
echo "  3. Your agents should respond!"
echo ""
echo "If anything goes wrong:"
echo "  - Check logs:    openclaw gateway logs"
echo "  - Check status:  openclaw status"
echo "  - Get help:      https://discord.com/invite/clawd"
echo ""
