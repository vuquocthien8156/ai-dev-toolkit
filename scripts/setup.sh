#!/bin/bash
# setup.sh — Multi-IDE AI Dev Toolkit Setup (Antigravity & Claude Code)
#
# Usage:
#   cd <your-project>
#   ~/Documents/ai-dev-toolkit/scripts/setup.sh
#
# What it does:
#   1. Updates global rules → ~/.gemini/GEMINI.md & ~/.claude/CLAUDE.md
#   2. Installs global skills → ~/.agents/skills/
#   2.5 Symlinks skills to target IDEs (Antigravity & Claude Code)
#   3. Copies workflows/commands → project & global IDE dirs
#   4. Health check
#
# Flags:
#   --force       Overwrite existing files
#   --rules       Only update global rules (Step 1)
#   --skills      Only install skills (Steps 2 + 2.5)
#   --workflows   Only copy workflows (Step 3)
#   --ide <name>  Target IDE: antigravity, claude, or all (default: all)
#   --clean       Clean global skills and IDE symlinks (Safe Reset)
#
# Examples:
#   setup.sh                     # Run everything for all IDEs
#   setup.sh --ide claude        # Only setup Claude Code
#   setup.sh --workflows --force # Only update workflows, overwrite
#   setup.sh --clean             # Reset global skills

set -e

# Parse flags
FORCE=false
ONLY_RULES=false
ONLY_SKILLS=false
ONLY_WORKFLOWS=false
HAS_STEP_FLAG=false
TARGET_IDE="all"

while [[ $# -gt 0 ]]; do
  case "$1" in
    --force)      FORCE=true; shift ;;
    --rules)      ONLY_RULES=true; HAS_STEP_FLAG=true; shift ;;
    --skills)     ONLY_SKILLS=true; HAS_STEP_FLAG=true; shift ;;
    --workflows)  ONLY_WORKFLOWS=true; HAS_STEP_FLAG=true; shift ;;
    --ide)        TARGET_IDE="$2"; shift 2 ;;
    --clean)      "$SCRIPT_DIR/cleanup.sh"; exit 0 ;;
    *)            shift ;;
  esac
done

# If no step flag → run ALL steps
if [ "$HAS_STEP_FLAG" = false ]; then
  ONLY_RULES=true
  ONLY_SKILLS=true
  ONLY_WORKFLOWS=true
fi

# Resolve symlinks (needed when running via npx)
SOURCE="$0"
while [ -L "$SOURCE" ]; do
  DIR="$(cd "$(dirname "$SOURCE")" && pwd)"
  SOURCE="$(readlink "$SOURCE")"
  [[ "$SOURCE" != /* ]] && SOURCE="$DIR/$SOURCE"
done
SCRIPT_DIR="$(cd "$(dirname "$SOURCE")" && pwd)"
TOOLKIT_DIR="$(cd "$SCRIPT_DIR/.." && pwd)"

# Source of truth for skills
AGENTS_SKILLS_DIR="$HOME/.agents/skills"

# IDE Paths
ANTIGRAVITY_BASE="$HOME/.gemini"
ANTIGRAVITY_SKILLS="$ANTIGRAVITY_BASE/antigravity/skills"
ANTIGRAVITY_WORKFLOWS="$ANTIGRAVITY_BASE/antigravity/workflows"
ANTIGRAVITY_RULES="$ANTIGRAVITY_BASE/GEMINI.md"

CLAUDE_BASE="$HOME/.claude"
CLAUDE_SKILLS="$CLAUDE_BASE/skills"
CLAUDE_COMMANDS="$CLAUDE_BASE/commands"
CLAUDE_RULES="$CLAUDE_BASE/CLAUDE.md"

PROJECT_AGENT_DIR=".agent"
PROJECT_CLAUDE_DIR=".claude"

echo "🚀 AI Dev Toolkit — Multi-IDE Setup"
echo "   Toolkit: $TOOLKIT_DIR"
echo "   Project: $(pwd)"
echo "   IDE:     $TARGET_IDE"
echo ""

# ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
# Step 1: Update Global Rules
# ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
update_rules() {
  local src="$TOOLKIT_DIR/user-rules/memory-rules.md"
  local dest="$1"
  local name="$2"
  
  if [ -f "$src" ]; then
    mkdir -p "$(dirname "$dest")"
    if cmp -s "$src" "$dest"; then
      echo "   ✅ $name is up-to-date"
    else
      cp "$src" "$dest" 2>/dev/null || cat "$src" > "$dest" 2>/dev/null || \
      echo "   ⚠️  Could not update $name (macOS permission). Copy manually."
    fi
  fi
}

if [ "$ONLY_RULES" = true ]; then
  echo "📝 Step 1: Global rules"
  [[ "$TARGET_IDE" == "all" || "$TARGET_IDE" == "antigravity" ]] && update_rules "$ANTIGRAVITY_RULES" "Antigravity rules"
  [[ "$TARGET_IDE" == "all" || "$TARGET_IDE" == "claude" ]] && update_rules "$CLAUDE_RULES" "Claude Code rules"
  echo ""
fi

# ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
# Step 2: Install and Symlink Skills
# ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
if [ "$ONLY_SKILLS" = true ]; then
  echo "📦 Step 2: Installing global skills"
  mkdir -p "$AGENTS_SKILLS_DIR"

  # 2.1 Copy self-written skills to source of truth
  if [ -d "$TOOLKIT_DIR/skills" ]; then
    for skill_dir in "$TOOLKIT_DIR/skills"/*/; do
      skill_name=$(basename "$skill_dir")
      if [ -f "$skill_dir/SKILL.md" ]; then
        cp -r "$skill_dir" "$AGENTS_SKILLS_DIR/" 2>/dev/null || true
        echo "   ✅ $skill_name (source)"
      fi
    done
  fi

  # 2.2 Community skills
  echo "🌐 Step 2.1: Community skills"
  COMMUNITY_SKILLS=(
    "obra/superpowers --skill systematic-debugging"
    "supercent-io/skills-template --skill backend-testing"
    "supercent-io/skills-template --skill security-best-practices"
  )
  for skill_spec in "${COMMUNITY_SKILLS[@]}"; do
    echo "   Installing: $skill_spec"
    npx -y skills add $skill_spec -g -y 2>/dev/null && echo "   ✅ Done" || echo "   ⚠️  Failed"
  done

  # 2.3 Symlink to IDEs
  link_skills() {
    local dest_dir="$1"
    local ide_name="$2"
    mkdir -p "$dest_dir"
    echo "   🔗 Linking to $ide_name..."
    for skill_path in "$AGENTS_SKILLS_DIR"/*/; do
      skill_name=$(basename "$skill_path")
      if [ -f "$skill_path/SKILL.md" ]; then
        ln -sf "$skill_path" "$dest_dir/$skill_name" 2>/dev/null || true
      fi
    done
  }

  [[ "$TARGET_IDE" == "all" || "$TARGET_IDE" == "antigravity" ]] && link_skills "$ANTIGRAVITY_SKILLS" "Antigravity"
  [[ "$TARGET_IDE" == "all" || "$TARGET_IDE" == "claude" ]] && link_skills "$CLAUDE_SKILLS" "Claude Code"
  echo ""
fi

# ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
# Step 3: Workflows & Commands
# ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
if [ "$ONLY_WORKFLOWS" = true ]; then
  echo "📋 Step 3: Installing workflows/commands"

  copy_wf() {
    local dest="$1"
    local type="$2"
    mkdir -p "$dest"
    for wf in "$TOOLKIT_DIR/workflows"/*.md; do
      local wf_name=$(basename "$wf")
      local target="$dest/$wf_name"
      if [ ! -f "$target" ] || [ "$FORCE" = true ]; then
        cp "$wf" "$target" 2>/dev/null || true
        echo "      ✅ $wf_name"
      fi
    done
  }

  # Antigravity (workflows)
  if [[ "$TARGET_IDE" == "all" || "$TARGET_IDE" == "antigravity" ]]; then
    echo "   🌍 Antigravity Global → $ANTIGRAVITY_WORKFLOWS"
    copy_wf "$ANTIGRAVITY_WORKFLOWS"
    if [ -d ".git" ] || [ -d "$PROJECT_AGENT_DIR" ]; then
      echo "   📁 Antigravity Project → $PROJECT_AGENT_DIR/workflows"
      copy_wf "$PROJECT_AGENT_DIR/workflows"
    fi
  fi

  # Claude Code (commands)
  if [[ "$TARGET_IDE" == "all" || "$TARGET_IDE" == "claude" ]]; then
    echo "   🌍 Claude Global → $CLAUDE_COMMANDS"
    copy_wf "$CLAUDE_COMMANDS"
    if [ -d ".git" ] || [ -d "$PROJECT_CLAUDE_DIR" ]; then
      echo "   📁 Claude Project → $PROJECT_CLAUDE_DIR/commands"
      copy_wf "$PROJECT_CLAUDE_DIR/commands"
    fi
  fi
  echo ""
fi

# ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
# Step 4: Health Check
# ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
echo "🔍 Step 4: Health check"
# Common checks...
if [ -d "$PROJECT_AGENT_DIR/skills" ]; then
  count=$(find "$PROJECT_AGENT_DIR/skills" -type f | wc -l | tr -d ' ')
  [[ $count -gt 50 ]] && echo "   ⚠️  Too many skill files ($count)" || echo "   ✅ Skills: $count"
fi

echo ""
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "✅ All done!"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
