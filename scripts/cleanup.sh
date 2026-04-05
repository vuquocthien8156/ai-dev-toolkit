#!/bin/bash
# cleanup.sh — AI Dev Toolkit System Cleanup
#
# Use this script if your context/skills feel bloated or broken.
# It safely wipes global skill directories and IDE symlinks.
#
# Usage:
#   ~/Documents/ai-dev-toolkit/scripts/cleanup.sh

set -e

echo "🧹 AI Dev Toolkit — System Cleanup"
echo "   This will clear global skills and IDE symlinks."
echo ""

# Targeted directories
GLOBAL_SKILLS="$HOME/.agents/skills"
ANTIGRAVITY_SKILLS="$HOME/.gemini/antigravity/skills"
CLAUDE_SKILLS="$HOME/.claude/skills"

# Function to clear a directory safely
clear_dir() {
  local dir="$1"
  local name="$2"
  
  if [ -d "$dir" ]; then
    echo "   Removing $name contents: $dir"
    # Use \rm -rf to avoid interactive prompts from aliases
    \rm -rf "$dir"/* 2>/dev/null || true
    # Ensure dir exists but is empty
    mkdir -p "$dir"
    echo "      ✅ Cleaned"
  else
    echo "   ℹ️  $name directory not found, skipping."
  fi
}

# Clear global skills
clear_dir "$GLOBAL_SKILLS" "Global Skills"
clear_dir "$ANTIGRAVITY_SKILLS" "Antigravity Symlinks"
clear_dir "$CLAUDE_SKILLS" "Claude Code Symlinks"

echo ""
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "✅ System is clean!"
echo "👉 Now run the setup script to rebuild:"
echo "   ~/Documents/ai-dev-toolkit/scripts/setup.sh --force"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
