#!/bin/bash
# setup-antigravity.sh — One command to set up everything
#
# Usage:
#   cd <your-project>
#   ~/Documents/ai-dev-toolkit/scripts/setup-antigravity.sh
#
# What it does:
#   1. Updates global rules → ~/.gemini/GEMINI.md
#   2. Installs global skills → ~/.agents/skills/ (+ symlink)
#   3. Installs workflows → <project>/.agent/workflows/
#   4. Cleans bloated skills + creates cross-IDE symlinks

set -e

# Resolve symlinks (needed when running via npx — npm creates symlinks in .bin/)
SOURCE="$0"
while [ -L "$SOURCE" ]; do
  DIR="$(cd "$(dirname "$SOURCE")" && pwd)"
  SOURCE="$(readlink "$SOURCE")"
  # If readlink returns relative path, make it absolute
  [[ "$SOURCE" != /* ]] && SOURCE="$DIR/$SOURCE"
done
SCRIPT_DIR="$(cd "$(dirname "$SOURCE")" && pwd)"
TOOLKIT_DIR="$(cd "$SCRIPT_DIR/.." && pwd)"
AGENTS_SKILLS_DIR="$HOME/.agents/skills"
ANTIGRAVITY_SKILLS_DIR="$HOME/.gemini/antigravity/skills"
GEMINI_RULES="$HOME/.gemini/GEMINI.md"
PROJECT_AGENT_DIR=".agent"

echo "🚀 AI Dev Toolkit — One Command Setup"
echo "   Toolkit: $TOOLKIT_DIR"
echo "   Project: $(pwd)"
echo ""

# ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
# Step 1: Manual Global Rules Note
# ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
echo "📝 Step 1: Global rules (GEMINI.md)"
echo "   ⚠️  Please manually copy the contents of user-rules/memory-rules.md"
echo "   to your IDE Settings -> User Rules."
echo ""


# ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
# Step 2: Install global skills
# ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
echo "📦 Step 2: Installing global skills"
mkdir -p "$AGENTS_SKILLS_DIR"
mkdir -p "$ANTIGRAVITY_SKILLS_DIR"

if [ -d "$TOOLKIT_DIR/skills" ]; then
  for skill_dir in "$TOOLKIT_DIR/skills"/*/; do
    skill_name=$(basename "$skill_dir")
    if [ -f "$skill_dir/SKILL.md" ]; then
      # Copy to ~/.agents/skills/ (actual location)
      cp -r "$skill_dir" "$AGENTS_SKILLS_DIR/"
      # Create symlink in ~/.gemini/antigravity/skills/ (Antigravity reads here)
      ln -sf "$AGENTS_SKILLS_DIR/$skill_name" "$ANTIGRAVITY_SKILLS_DIR/$skill_name" 2>/dev/null || true
      echo "   ✅ $skill_name"
    fi
  done
else
  echo "   ⚠️  No skills/ directory found"
fi

echo ""

# ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
# Step 3: Install workflows (Global & Project)
# ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
ANTIGRAVITY_WORKFLOWS_DIR="$HOME/.gemini/antigravity/workflows"
echo "📋 Step 3: Installing workflows"

# 1. Install Global Workflows
echo "   🌍 Global → $ANTIGRAVITY_WORKFLOWS_DIR/"
mkdir -p "$ANTIGRAVITY_WORKFLOWS_DIR"
if [ -d "$TOOLKIT_DIR/workflows" ]; then
  for wf in "$TOOLKIT_DIR/workflows"/*.md; do
    wf_name=$(basename "$wf")
    cp "$wf" "$ANTIGRAVITY_WORKFLOWS_DIR/"
    echo "      ✅ $wf_name"
  done
fi

# 2. Install Project Workflows
echo "   📁 Project → $PROJECT_AGENT_DIR/workflows/"
if [ -d ".git" ] || [ -d "$PROJECT_AGENT_DIR" ]; then
  mkdir -p "$PROJECT_AGENT_DIR/workflows"
  if [ -d "$TOOLKIT_DIR/workflows" ]; then
    for wf in "$TOOLKIT_DIR/workflows"/*.md; do
      wf_name=$(basename "$wf")
      cp "$wf" "$PROJECT_AGENT_DIR/workflows/"
      echo "      ✅ $wf_name"
    done
  fi
else
  echo "      ⚠️  Not in a project directory (no .git or .agent found)"
  echo "      Run this script from inside your project folder to install workspace workflows"
fi

echo ""

# ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
# Step 4: Health check
# ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
echo "🔍 Step 4: Health check"

# Check bloated skills
if [ -d "$PROJECT_AGENT_DIR/skills" ]; then
  SKILL_COUNT=$(find "$PROJECT_AGENT_DIR/skills" -type f | wc -l | tr -d ' ')
  if [ "$SKILL_COUNT" -gt 50 ]; then
    echo "   ⚠️  Project has $SKILL_COUNT skill files (too many, AI gets diluted)"
  else
    echo "   ✅ Project skills: $SKILL_COUNT files"
  fi
fi

# Cross-IDE symlinks
if [ -d "$PROJECT_AGENT_DIR/skills" ]; then
  mkdir -p .cursor .claude 2>/dev/null || true
  ln -sfn "../$PROJECT_AGENT_DIR/skills" .cursor/skills 2>/dev/null \
    && echo "   ✅ .cursor/skills → .agent/skills" || true
  ln -sfn "../$PROJECT_AGENT_DIR/skills" .claude/skills 2>/dev/null \
    && echo "   ✅ .claude/skills → .agent/skills" || true
fi

echo ""
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "✅ All done! Summary:"
echo "   📝 Rules   → ~/.gemini/GEMINI.md (backed up old version)"
echo "   📦 Skills  → ~/.agents/skills/ (symlinked to Antigravity)"
echo "   📋 Workflows → .agent/workflows/ (this project)"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo ""
