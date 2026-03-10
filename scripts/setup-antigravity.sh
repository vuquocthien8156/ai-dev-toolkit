#!/bin/bash
# setup-antigravity.sh — One command to set up everything
#
# Usage:
#   cd <your-project>
#   ~/Documents/ai-dev-toolkit/scripts/setup-antigravity.sh
#
# What it does (by default, runs ALL steps):
#   1. Updates global rules → ~/.gemini/GEMINI.md
#   2. Installs global skills → ~/.agents/skills/ (+ symlink)
#   2.5 Installs community skills globally
#   3. Copies workflows → project .agent/workflows/ + global
#   4. Health check: bloated skills warning + cross-IDE symlinks
#
# Flags:
#   --force       Overwrite existing files
#   --rules       Only update global rules (Step 1)
#   --skills      Only install skills (Steps 2 + 2.5)
#   --workflows   Only copy workflows (Step 3)
#
# Examples:
#   setup-antigravity.sh                     # Run everything
#   setup-antigravity.sh --workflows --force # Only update workflows, overwrite
#   setup-antigravity.sh --rules             # Only refresh global rules

set -e

# Parse flags
FORCE=false
ONLY_RULES=false
ONLY_SKILLS=false
ONLY_WORKFLOWS=false
HAS_STEP_FLAG=false

for arg in "$@"; do
  case "$arg" in
    --force)      FORCE=true ;;
    --rules)      ONLY_RULES=true; HAS_STEP_FLAG=true ;;
    --skills)     ONLY_SKILLS=true; HAS_STEP_FLAG=true ;;
    --workflows)  ONLY_WORKFLOWS=true; HAS_STEP_FLAG=true ;;
  esac
done

# If no step flag → run ALL steps
if [ "$HAS_STEP_FLAG" = false ]; then
  ONLY_RULES=true
  ONLY_SKILLS=true
  ONLY_WORKFLOWS=true
fi

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
if [ "$HAS_STEP_FLAG" = true ]; then
  STEPS=""
  [ "$ONLY_RULES" = true ] && STEPS="${STEPS}rules "
  [ "$ONLY_SKILLS" = true ] && STEPS="${STEPS}skills "
  [ "$ONLY_WORKFLOWS" = true ] && STEPS="${STEPS}workflows "
  echo "   Mode:    selective (${STEPS})"
fi
echo ""

# ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
# Step 1: Update Global Rules → ~/.gemini/GEMINI.md
# ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
if [ "$ONLY_RULES" = true ]; then
  echo "📝 Step 1: Global rules"
  mkdir -p "$HOME/.gemini"

  if [ -f "$TOOLKIT_DIR/user-rules/memory-rules.md" ]; then
    if cmp -s "$TOOLKIT_DIR/user-rules/memory-rules.md" "$GEMINI_RULES"; then
      echo "   ✅ $GEMINI_RULES is up-to-date"
    else
      # Try to copy, but don't fail the whole script if macOS blocks it
      cp "$TOOLKIT_DIR/user-rules/memory-rules.md" "$GEMINI_RULES" 2>/dev/null || \
      cat "$TOOLKIT_DIR/user-rules/memory-rules.md" > "$GEMINI_RULES" 2>/dev/null || \
      echo "   ⚠️  Could not update $GEMINI_RULES (macOS operation not permitted). Please copy manually."
    fi
  else
    echo "   ⚠️  memory-rules.md not found in toolkit."
  fi
  echo ""
else
  echo "⏭️  Step 1: Rules (skipped)"
fi


# ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
# Step 2: Install global skills
# ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
if [ "$ONLY_SKILLS" = true ]; then
  echo "📦 Step 2: Installing global skills"
  mkdir -p "$AGENTS_SKILLS_DIR"
  mkdir -p "$ANTIGRAVITY_SKILLS_DIR"

  if [ -d "$TOOLKIT_DIR/skills" ]; then
    for skill_dir in "$TOOLKIT_DIR/skills"/*/; do
      skill_name=$(basename "$skill_dir")
      if [ -f "$skill_dir/SKILL.md" ]; then
        # Copy to ~/.agents/skills/ (actual location) and suppress xattr/permission errors
        cp -r "$skill_dir" "$AGENTS_SKILLS_DIR/" 2>/dev/null || true
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
  # Step 2.5: Install community skills (global)
  # ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
  echo "🌐 Step 2.5: Community skills (global)"
  COMMUNITY_SKILLS=(
    "obra/superpowers --skill systematic-debugging"
    "supercent-io/skills-template --skill backend-testing"
    "supercent-io/skills-template --skill security-best-practices"
    "sickn33/antigravity-awesome-skills --skill context-management-context-restore"
  )
  for skill_spec in "${COMMUNITY_SKILLS[@]}"; do
    echo "   Installing: $skill_spec"
    npx -y skills add $skill_spec -g -y 2>/dev/null \
      && echo "   ✅ Done" \
      || echo "   ⚠️  Failed (network issue or already installed)"
  done
  echo ""
else
  echo "⏭️  Step 2: Skills (skipped)"
fi

# ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
# Step 3: Install workflows (Global & Project)
# ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
if [ "$ONLY_WORKFLOWS" = true ]; then
  ANTIGRAVITY_WORKFLOWS_DIR="$HOME/.gemini/antigravity/workflows"
  echo "📋 Step 3: Installing workflows"

  # Helper: copy workflows with no-overwrite (unless --force)
  copy_workflows() {
    local dest="$1"
    mkdir -p "$dest"
    for wf in "$TOOLKIT_DIR/workflows"/*.md; do
      local wf_name=$(basename "$wf")
      local target="$dest/$wf_name"
      if [ ! -f "$target" ] || [ "$FORCE" = true ]; then
        cp "$wf" "$target" 2>/dev/null || true
        echo "      ✅ $([ "$FORCE" = true ] && echo 'Updated' || echo 'Added'): $wf_name"
      else
        echo "      ⏭️  Skipped (exists): $wf_name"
      fi
    done
  }

  # 1. Install Global Workflows
  echo "   🌍 Global → $ANTIGRAVITY_WORKFLOWS_DIR/"
  copy_workflows "$ANTIGRAVITY_WORKFLOWS_DIR"

  # 2. Install Project Workflows
  echo "   📁 Project → $PROJECT_AGENT_DIR/workflows/"
  if [ -d ".git" ] || [ -d "$PROJECT_AGENT_DIR" ]; then
    copy_workflows "$PROJECT_AGENT_DIR/workflows"
  else
    echo "      ⚠️  Not in a project directory (no .git or .agent found)"
    echo "      Run this script from inside your project folder to install workspace workflows"
  fi

  echo ""
else
  echo "⏭️  Step 3: Workflows (skipped)"
fi

# ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
# Step 4: Health check (always runs)
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
echo "   📝 Rules     → $([ "$ONLY_RULES" = true ] && echo '~/.gemini/GEMINI.md' || echo 'skipped')"
echo "   📦 Skills    → $([ "$ONLY_SKILLS" = true ] && echo '~/.agents/skills/' || echo 'skipped')"
echo "   📋 Workflows → $([ "$ONLY_WORKFLOWS" = true ] && echo 'global + project' || echo 'skipped') $([ "$FORCE" = true ] && echo '(force-updated)' || echo '')"
echo ""
echo "   💡 Flags:"
echo "      --force       Overwrite existing files"
echo "      --rules       Only update global rules"
echo "      --skills      Only install skills"
echo "      --workflows   Only copy workflows"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo ""
