#!/bin/bash
# setup.sh — Multi-IDE AI Dev Toolkit Setup (Antigravity, Claude Code, Cursor & Windsurf)
#
# Usage:
#   cd <your-project>
#   npx github:vuquocthien8156/ai-dev-toolkit
#
# What it does:
#   1. Updates global rules → ~/.gemini/GEMINI.md, ~/.claude/CLAUDE.md, ~/.cursor/rules/, ~/.windsurfrules
#   1b. Copies reference rules (workflow-protocol, examples) → ~/.agents/rules/
#   2. Installs global skills → ~/.agents/skills/
#   2.5 Symlinks skills to target IDEs (Antigravity & Claude Code)
#   3. Copies workflows/commands → project & global IDE dirs
#   4. Health check
#
# Flags:
#   --force       Overwrite existing files
#   --rules       Only update global rules (Step 1 + 1b)
#   --skills      Only install skills (Steps 2 + 2.5)
#   --workflows   Only copy workflows (Step 3)
#   --ide <name>  Target IDE: antigravity, claude, cursor, windsurf, or all (default: all)
#   --clean       Clean global skills and IDE symlinks (Safe Reset)
#
# Examples:
#   npx github:vuquocthien8156/ai-dev-toolkit                     # Run everything for all IDEs
#   npx github:vuquocthien8156/ai-dev-toolkit --ide claude        # Only setup Claude Code
#   npx github:vuquocthien8156/ai-dev-toolkit --ide cursor        # Only setup Cursor
#   npx github:vuquocthien8156/ai-dev-toolkit --ide windsurf      # Only setup Windsurf
#   npx github:vuquocthien8156/ai-dev-toolkit --workflows --force # Only update workflows, overwrite
#   npx github:vuquocthien8156/ai-dev-toolkit --clean             # Reset global skills

set -e

# Resolve symlinks (needed when running via npx)
SOURCE="$0"
while [ -L "$SOURCE" ]; do
  DIR="$(cd "$(dirname "$SOURCE")" && pwd)"
  SOURCE="$(readlink "$SOURCE")"
  [[ "$SOURCE" != /* ]] && SOURCE="$DIR/$SOURCE"
done
SCRIPT_DIR="$(cd "$(dirname "$SOURCE")" && pwd)"
TOOLKIT_DIR="$(cd "$SCRIPT_DIR/.." && pwd)"

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

CURSOR_BASE="$HOME/.cursor"
CURSOR_RULES="$CURSOR_BASE/rules"

WINDSURF_RULES_GLOBAL="$HOME/.windsurfrules"
WINDSURF_WORKFLOWS="$HOME/.windsurf/workflows"
WINDSURF_SKILLS="$HOME/.windsurf/skills"
PROJECT_WINDSURF_DIR=".windsurf"

AGENTS_RULES_DIR="$HOME/.agents/rules"

PROJECT_AGENT_DIR=".agents"
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
  local src="$1"
  local dest="$2"
  local name="$3"

  if [ -f "$src" ]; then
    mkdir -p "$(dirname "$dest")"
    if cmp -s "$src" "$dest"; then
      echo "   ✅ $name is up-to-date"
    else
      cp "$src" "$dest" 2>/dev/null || cat "$src" > "$dest" 2>/dev/null || \
      echo "   ⚠️  Could not update $name (macOS permission). Copy manually."
    fi
  else
    echo "   ⚠️  Source not found: $src"
  fi
}

# Cursor rules need .mdc frontmatter wrapper
update_rules_cursor() {
  local src="$1"
  local dest="$2"
  local name="$3"

  if [ -f "$src" ]; then
    mkdir -p "$(dirname "$dest")"
    local tmp=$(mktemp)
    cat > "$tmp" <<'FRONTMATTER'
---
description: Core behavioral guidelines for AI coding assistant
alwaysApply: true
---
FRONTMATTER
    cat "$src" >> "$tmp"
    if cmp -s "$tmp" "$dest"; then
      echo "   ✅ $name is up-to-date"
    else
      cp "$tmp" "$dest" 2>/dev/null || cat "$tmp" > "$dest" 2>/dev/null || \
      echo "   ⚠️  Could not update $name (macOS permission). Copy manually."
    fi
    rm -f "$tmp"
  else
    echo "   ⚠️  Source not found: $src"
  fi
}

# Copy reference rules (workflow-protocol, examples) to shared location
copy_reference_rules() {
  local src_dir="$1"
  mkdir -p "$AGENTS_RULES_DIR"
  for ref_file in "workflow-protocol.md" "examples-violations.md"; do
    if [ -f "$src_dir/$ref_file" ]; then
      if cmp -s "$src_dir/$ref_file" "$AGENTS_RULES_DIR/$ref_file"; then
        echo "   ✅ $ref_file is up-to-date"
      else
        cp "$src_dir/$ref_file" "$AGENTS_RULES_DIR/$ref_file" 2>/dev/null || true
        echo "   ✅ $ref_file → $AGENTS_RULES_DIR/"
      fi
    fi
  done
}

RULES_SRC="$TOOLKIT_DIR/user-rules/memory-rules.md"

if [ "$ONLY_RULES" = true ]; then
  echo "📝 Step 1: Global core rules"
  [[ "$TARGET_IDE" == "all" || "$TARGET_IDE" == "antigravity" ]] && update_rules "$RULES_SRC" "$ANTIGRAVITY_RULES" "Antigravity rules"
  [[ "$TARGET_IDE" == "all" || "$TARGET_IDE" == "claude" ]] && update_rules "$RULES_SRC" "$CLAUDE_RULES" "Claude Code rules"
  [[ "$TARGET_IDE" == "all" || "$TARGET_IDE" == "cursor" ]] && update_rules_cursor "$RULES_SRC" "$CURSOR_RULES/user-rules.mdc" "Cursor rules"
  [[ "$TARGET_IDE" == "all" || "$TARGET_IDE" == "windsurf" ]] && update_rules "$RULES_SRC" "$WINDSURF_RULES_GLOBAL" "Windsurf rules"

  echo ""
  echo "📝 Step 1b: Reference rules (shared)"
  copy_reference_rules "$TOOLKIT_DIR/user-rules"
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
    
    # 2.1.b Copy explicitly requested global skills to Project for Team Sharing
    if [ -d ".git" ] || [ -d "$PROJECT_AGENT_DIR" ]; then
      mkdir -p "$PROJECT_AGENT_DIR/skills"
      for target_skill in "skill-creator" "llm-wiki-schema"; do
        if [ -d "$TOOLKIT_DIR/skills/$target_skill" ]; then
          # Use trailing slash on dest but not source to copy the folder itself
          cp -r "$TOOLKIT_DIR/skills/$target_skill" "$PROJECT_AGENT_DIR/skills/" 2>/dev/null || true
          echo "   ✅ $target_skill (project)"
        fi
      done
    fi
  fi

  # 2.2 Community skills
  echo "🌐 Step 2.1: Community skills"
  COMMUNITY_SKILLS=(
    "obra/superpowers --skill systematic-debugging"
    "akillness/oh-my-skills --skill backend-testing"
    "sickn33/antigravity-awesome-skills --skill api-security-best-practices"
  )
  for skill_spec in "${COMMUNITY_SKILLS[@]}"; do
    echo "   Installing: $skill_spec"
    npx -y skills add $skill_spec -g -y 2>/dev/null && echo "   ✅ Done" || echo "   ⚠️  Failed"
  done

  # 2.3 Symlink to IDEs
  link_skills() {
    local dest_dir="$1"
    local ide_name="$2"
    echo "   🔗 Linking to $ide_name..."
    # Ensure the parent directory exists
    mkdir -p "$(dirname "$dest_dir")"
    # Remove existing dest_dir to cleanly link the whole folder
    rm -rf "$dest_dir" 2>/dev/null || true
    # Symlink the entire skills folder globally
    ln -sfn "$AGENTS_SKILLS_DIR" "$dest_dir"
  }

  [[ "$TARGET_IDE" == "all" || "$TARGET_IDE" == "antigravity" ]] && link_skills "$ANTIGRAVITY_SKILLS" "Antigravity"
  [[ "$TARGET_IDE" == "all" || "$TARGET_IDE" == "claude" ]] && link_skills "$CLAUDE_SKILLS" "Claude Code"
  [[ "$TARGET_IDE" == "all" || "$TARGET_IDE" == "windsurf" ]] && link_skills "$WINDSURF_SKILLS" "Windsurf"
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
      echo "   📁 Claude Project → $PROJECT_CLAUDE_DIR/commands (symlink to .agents/workflows)"
      mkdir -p "$PROJECT_CLAUDE_DIR"
      # Remove old directory if it's not a symlink to prevent conflicts
      [ ! -L "$PROJECT_CLAUDE_DIR/commands" ] && rm -rf "$PROJECT_CLAUDE_DIR/commands" 2>/dev/null || true
      ln -sfn ../.agents/workflows "$PROJECT_CLAUDE_DIR/commands"
    fi
  fi

  # Windsurf (workflows)
  if [[ "$TARGET_IDE" == "all" || "$TARGET_IDE" == "windsurf" ]]; then
    echo "   🌍 Windsurf Global → $WINDSURF_WORKFLOWS"
    copy_wf "$WINDSURF_WORKFLOWS"
    if [ -d ".git" ] || [ -d "$PROJECT_WINDSURF_DIR" ]; then
      echo "   📁 Windsurf Project → $PROJECT_WINDSURF_DIR/workflows (symlink to .agents/workflows)"
      mkdir -p "$PROJECT_WINDSURF_DIR"
      [ ! -L "$PROJECT_WINDSURF_DIR/workflows" ] && rm -rf "$PROJECT_WINDSURF_DIR/workflows" 2>/dev/null || true
      ln -sfn ../.agents/workflows "$PROJECT_WINDSURF_DIR/workflows"
    fi
  fi
  
  # 3b. Gitignore Injection for Multi-IDE cleanliness
  if [ -d ".git" ] && [ -f ".gitignore" ]; then
    echo "   🛡️  Ensuring clean .gitignore for multi-IDE..."
    # Add explicit ignores for local settings if not present
    if ! grep -q "settings.local.json" .gitignore; then
      echo -e "\n# AI Agent Local Settings\n.claude/settings.local.json\n.claude/mcp.json\n.cursor/workspace.json\n.windsurf/workspace.json" >> .gitignore
    fi
    # Remove blanket ignores for IDE folders so symlinks can be tracked
    if grep -q -E "^\.(claude|windsurf|cursor|gemini)/?$" .gitignore; then
      sed -i.bak -E '/^\.(claude|windsurf|cursor|gemini)\/?$/d' .gitignore && rm -f .gitignore.bak
      echo "      ✅ Removed blanket IDE folder ignores"
    fi
  fi
  
  echo ""
fi

# ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
# Step 4: Health Check
# ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
echo "🔍 Step 4: Health check"

# Rules check
[[ -f "$ANTIGRAVITY_RULES" ]] && echo "   ✅ Antigravity rules exist" || echo "   ⚠️  Missing Antigravity rules"
[[ -f "$CLAUDE_RULES" ]] && echo "   ✅ Claude Code rules exist" || echo "   ⚠️  Missing Claude Code rules"
[[ -f "$CURSOR_RULES/user-rules.mdc" ]] && echo "   ✅ Cursor rules exist" || echo "   ⚠️  Missing Cursor rules"
[[ -f "$WINDSURF_RULES_GLOBAL" ]] && echo "   ✅ Windsurf rules exist" || echo "   ⚠️  Missing Windsurf rules"

# Reference rules check
[[ -f "$AGENTS_RULES_DIR/workflow-protocol.md" ]] && echo "   ✅ Workflow protocol reference exists" || echo "   ⚠️  Missing workflow-protocol.md"
[[ -f "$AGENTS_RULES_DIR/examples-violations.md" ]] && echo "   ✅ Examples reference exists" || echo "   ⚠️  Missing examples-violations.md"

# Skills check
if [ -d "$PROJECT_AGENT_DIR/skills" ]; then
  count=$(find "$PROJECT_AGENT_DIR/skills" -type f | wc -l | tr -d ' ')
  [[ $count -gt 50 ]] && echo "   ⚠️  Too many skill files ($count)" || echo "   ✅ Skills: $count"
fi

echo ""
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "✅ All done!"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
