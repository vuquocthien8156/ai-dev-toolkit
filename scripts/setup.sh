#!/bin/bash
# setup.sh — Multi-IDE AI Dev Toolkit Setup (Antigravity, Claude Code, Cursor & Windsurf)
#
# Usage:
#   cd <your-project>
#   npx github:vuquocthien8156/ai-dev-toolkit [flags]
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
#   -m, --machine     Setup global environment ($HOME/.agents, IDE configs)
#   -p, --project     Setup local project environment (.agents folder, IDE symlinks)
#   -f, --force       Overwrite existing files
#   -r, --rules       Only update global rules (Step 1 + 1b)
#   -s, --skills      Only install skills (Steps 2 + 2.5)
#   -w, --workflows   Only copy workflows (Step 3)
#   -i, --ide <name>  Target IDE: antigravity, claude, cursor, windsurf, or all (default: all)
#   -c, --clean       Clean global skills and IDE symlinks (Safe Reset)
#
# Examples:
#   npx github:vuquocthien8156/ai-dev-toolkit --machine           # Setup your PC (run once)
#   npx github:vuquocthien8156/ai-dev-toolkit --project           # Setup current project
#   npx github:vuquocthien8156/ai-dev-toolkit                     # Default is --machine

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
SCOPE_MACHINE=false
SCOPE_PROJECT=false

while [[ $# -gt 0 ]]; do
  case "$1" in
    -m|--machine)    SCOPE_MACHINE=true; shift ;;
    -p|--project)    SCOPE_PROJECT=true; shift ;;
    -f|--force)      FORCE=true; shift ;;
    -r|--rules)      ONLY_RULES=true; HAS_STEP_FLAG=true; shift ;;
    -s|--skills)     ONLY_SKILLS=true; HAS_STEP_FLAG=true; shift ;;
    -w|--workflows)  ONLY_WORKFLOWS=true; HAS_STEP_FLAG=true; shift ;;
    -i|--ide)        TARGET_IDE="$2"; shift 2 ;;
    -c|--clean)      "$SCRIPT_DIR/cleanup.sh"; exit 0 ;;
    *)               shift ;;
  esac
done

if [ "$SCOPE_MACHINE" = false ] && [ "$SCOPE_PROJECT" = false ]; then
  # If no scope specified, default to machine
  SCOPE_MACHINE=true
fi

# If no step flag → run ALL steps
if [ "$HAS_STEP_FLAG" = false ]; then
  ONLY_RULES=true
  ONLY_SKILLS=true
  ONLY_WORKFLOWS=true
fi

# Source of truth directories (Global)
AGENTS_RULES_DIR="$HOME/.agents/rules"
AGENTS_SKILLS_DIR="$HOME/.agents/skills"
AGENTS_TEMPLATES_DIR="$HOME/.agents/templates"
AGENTS_WORKFLOWS_DIR="$HOME/.agents/workflows"

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

PROJECT_AGENT_DIR=".agents"
PROJECT_CLAUDE_DIR=".claude"
PROJECT_WINDSURF_DIR=".windsurf"

echo "🚀 AI Dev Toolkit — Multi-IDE Setup"
echo "   Toolkit: $TOOLKIT_DIR"
echo "   Project: $(pwd)"
echo "   IDE:     $TARGET_IDE"
echo "   Scopes:  Machine=$SCOPE_MACHINE, Project=$SCOPE_PROJECT"
echo ""

# ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
# Helpers
# ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

# Safely create a symlink: remove existing regular files/folders if they are not symlinks
safe_link() {
  local src="$1"
  local dest="$2"
  local name="$3"

  if [ -e "$dest" ] && [ ! -L "$dest" ]; then
    rm -rf "$dest" 2>/dev/null || true
  fi
  mkdir -p "$(dirname "$dest")"
  ln -sfn "$src" "$dest"
  echo "   🔗 $name → $src"
}

# Sync from Repo to ~/.agents (The Source of Truth)
sync_to_agents() {
  echo "📦 Step 0: Syncing Toolkit to ~/.agents"
  mkdir -p "$AGENTS_RULES_DIR" "$AGENTS_SKILLS_DIR" "$AGENTS_TEMPLATES_DIR" "$AGENTS_WORKFLOWS_DIR"

  # Rules & Cursor .mdc generation
  mkdir -p "$AGENTS_RULES_DIR"
  cp -r "$TOOLKIT_DIR/user-rules"/* "$AGENTS_RULES_DIR/" 2>/dev/null || true
  
  # Recursively find all .md files in the rules source
  find "$AGENTS_RULES_DIR" -name "*.md" | while read rule_file; do
    local filename=$(basename "$rule_file")
    local base="${filename%.*}"
    local dir=$(dirname "$rule_file")
    local mdc_dest="$dir/$base.mdc"
    
    # Skip if it's already a backup or reference
    [[ "$filename" == *.bak ]] && continue
    [[ "$filename" == "workflow-protocol.md" ]] && continue
    [[ "$filename" == "examples-violations.md" ]] && continue

    echo "---" > "$mdc_dest"
    if [ "$filename" == "memory-rules.md" ]; then
      echo "description: Core behavioral guidelines for AI coding assistant" >> "$mdc_dest"
      echo "alwaysApply: true" >> "$mdc_dest"
    elif [ "$filename" == "backend-rules.md" ]; then
      echo "description: Backend specific rules (NestJS/Node.js)" >> "$mdc_dest"
      echo "globs: [\"src/backend/**/*\", \"apps/backend/**/*\", \"**/service.ts\", \"**/controller.ts\", \"**/repository.ts\"]" >> "$mdc_dest"
    elif [ "$filename" == "frontend-rules.md" ]; then
      echo "description: Frontend specific rules (Next.js/React)" >> "$mdc_dest"
      echo "globs: [\"src/frontend/**/*\", \"apps/frontend/**/*\", \"**/components/**/*\", \"**/pages/**/*\"]" >> "$mdc_dest"
    elif [ "$filename" == "mobile-rules.md" ]; then
      echo "description: Mobile specific rules (Expo/React Native)" >> "$mdc_dest"
      echo "globs: [\"src/mobile/**/*\", \"apps/mobile/**/*\", \"**/screens/**/*\"]" >> "$mdc_dest"
    else
      echo "description: Technical rules for $base" >> "$mdc_dest"
      echo "globs: []" >> "$mdc_dest"
    fi
    echo "---" >> "$mdc_dest"
    cat "$rule_file" >> "$mdc_dest"
  done

  # Skills
  if [ -d "$TOOLKIT_DIR/skills" ]; then
    cp -r "$TOOLKIT_DIR/skills"/* "$AGENTS_SKILLS_DIR/" 2>/dev/null || true
  fi

  # Workflows
  if [ -d "$TOOLKIT_DIR/workflows" ]; then
    cp -r "$TOOLKIT_DIR/workflows"/* "$AGENTS_WORKFLOWS_DIR/" 2>/dev/null || true
  fi

  # Templates
  if [ -d "$TOOLKIT_DIR/templates" ]; then
    cp -r "$TOOLKIT_DIR/templates"/* "$AGENTS_TEMPLATES_DIR/" 2>/dev/null || true
  fi
  
  echo "   ✅ Global source of truth updated."
  echo ""
}

# ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
# Step 1: Update Global Rules (Symlink Edition)
# ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
  if [ "$ONLY_RULES" = true ] && [ "$SCOPE_MACHINE" = true ]; then
  sync_to_agents
  echo "📝 Step 1: Global core rules (Symlinks)"
  
  rule_src=$(find "$AGENTS_RULES_DIR" -name "memory-rules.md" | head -n 1)
  
  [[ "$TARGET_IDE" == "all" || "$TARGET_IDE" == "antigravity" ]] && safe_link "$rule_src" "$ANTIGRAVITY_RULES" "Antigravity rules"
  [[ "$TARGET_IDE" == "all" || "$TARGET_IDE" == "claude" ]] && safe_link "$rule_src" "$CLAUDE_RULES" "Claude Code rules"
  [[ "$TARGET_IDE" == "all" || "$TARGET_IDE" == "windsurf" ]] && safe_link "$rule_src" "$WINDSURF_RULES_GLOBAL" "Windsurf rules"

  # Link all .mdc files to Cursor (flattened)
  if [[ "$TARGET_IDE" == "all" || "$TARGET_IDE" == "cursor" ]]; then
    echo "📝 Step 1a: Cursor specialized rules (.mdc)"
    mkdir -p "$CURSOR_RULES"
    find "$AGENTS_RULES_DIR" -name "*.mdc" | while read mdc_file; do
      mdc_name=$(basename "$mdc_file")
      safe_link "$mdc_file" "$CURSOR_RULES/$mdc_name" "Cursor rule: $mdc_name"
    done
  fi
  echo ""
fi

# ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
# Step 2: Install and Symlink Skills
# ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
if [ "$ONLY_SKILLS" = true ]; then
  if [ "$SCOPE_MACHINE" = true ]; then
    echo "📦 Step 2a: Linking global skills"
    # Community skills (only install if missing or force)
    echo "🌐 Step 2a.1: Community skills"
    COMMUNITY_SKILLS=(
      "obra/superpowers --skill systematic-debugging"
      "akillness/oh-my-skills --skill backend-testing"
      "sickn33/antigravity-awesome-skills --skill api-security-best-practices"
      "kadajett/agent-nestjs-skills --skill nestjs-best-practices"
      "vercel-labs/agent-skills --skill vercel-react-best-practices"
      "vercel-labs/agent-skills --skill vercel-react-native-skills"
      "expo/skills --skill upgrading-expo"
      "expo/skills --skill expo-deployment"
      "sickn33/antigravity-awesome-skills --skill clean-code"
      "supercent-io/skills-template --skill performance-optimization"
    )
    for skill_spec in "${COMMUNITY_SKILLS[@]}"; do
      skill_name=$(echo $skill_spec | awk '{print $NF}')
      if [ ! -d "$AGENTS_SKILLS_DIR/$skill_name" ] || [ "$FORCE" = true ]; then
        echo "   Installing: $skill_spec"
        npx -y skills add $skill_spec -g -y 2>/dev/null && echo "   ✅ Done" || echo "   ⚠️  Failed"
      else
        echo "   ✅ $skill_name already installed"
      fi
    done

    [[ "$TARGET_IDE" == "all" || "$TARGET_IDE" == "antigravity" ]] && safe_link "$AGENTS_SKILLS_DIR" "$ANTIGRAVITY_SKILLS" "Antigravity skills"
    [[ "$TARGET_IDE" == "all" || "$TARGET_IDE" == "claude" ]] && safe_link "$AGENTS_SKILLS_DIR" "$CLAUDE_SKILLS" "Claude Code skills"
    [[ "$TARGET_IDE" == "all" || "$TARGET_IDE" == "windsurf" ]] && safe_link "$AGENTS_SKILLS_DIR" "$WINDSURF_SKILLS" "Windsurf skills"
    echo ""
  fi

  if [ "$SCOPE_PROJECT" = true ]; then
    echo "📦 Step 2b: Installing project skills"
    if [ -d "$TOOLKIT_DIR/skills" ]; then
      if [ -d ".git" ] || [ -d "$PROJECT_AGENT_DIR" ]; then
        mkdir -p "$PROJECT_AGENT_DIR/skills"
        CORE_PROJECT_SKILLS=("skill-creator" "llm-wiki-schema" "llm-wiki-router" "project-scanner")
        for target_skill in "${CORE_PROJECT_SKILLS[@]}"; do
          if [ -d "$TOOLKIT_DIR/skills/$target_skill" ]; then
            cp -r "${TOOLKIT_DIR}/skills/${target_skill%/}" "$PROJECT_AGENT_DIR/skills/" 2>/dev/null || true
            echo "   ✅ $target_skill (project)"
          fi
        done
      fi
    fi
    echo ""
  fi
fi

# ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
# Step 3: Workflows & Commands (Symlink Edition)
# ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
if [ "$ONLY_WORKFLOWS" = true ]; then
  echo "📋 Step 3: Global workflows (Symlinks)"

  # Antigravity
  if [[ "$TARGET_IDE" == "all" || "$TARGET_IDE" == "antigravity" ]] && [ "$SCOPE_MACHINE" = true ]; then
    safe_link "$AGENTS_WORKFLOWS_DIR" "$ANTIGRAVITY_WORKFLOWS" "Antigravity workflows"
  fi

  # Claude Code
  if [[ "$TARGET_IDE" == "all" || "$TARGET_IDE" == "claude" ]] && [ "$SCOPE_MACHINE" = true ]; then
    safe_link "$AGENTS_WORKFLOWS_DIR" "$CLAUDE_COMMANDS" "Claude Code commands"
  fi

  # Windsurf
  if [[ "$TARGET_IDE" == "all" || "$TARGET_IDE" == "windsurf" ]] && [ "$SCOPE_MACHINE" = true ]; then
    safe_link "$AGENTS_WORKFLOWS_DIR" "$WINDSURF_WORKFLOWS" "Windsurf workflows"
  fi

  if [ "$SCOPE_PROJECT" = true ]; then
    echo "📋 Step 3b: Project workflows"
    if [ -d ".git" ] || [ -d "$PROJECT_AGENT_DIR" ]; then
      mkdir -p "$PROJECT_AGENT_DIR/workflows"
      cp -r "$TOOLKIT_DIR/workflows"/* "$PROJECT_AGENT_DIR/workflows/" 2>/dev/null || true
      
      # Project IDE symlinks to .agents/workflows
      [[ "$TARGET_IDE" == "all" || "$TARGET_IDE" == "claude" ]] && safe_link "../$PROJECT_AGENT_DIR/workflows" "$PROJECT_CLAUDE_DIR/commands" "Claude project commands"
      [[ "$TARGET_IDE" == "all" || "$TARGET_IDE" == "windsurf" ]] && safe_link "../$PROJECT_AGENT_DIR/workflows" "$PROJECT_WINDSURF_DIR/workflows" "Windsurf project workflows"
    fi
  fi
  
  # Gitignore check
  if [ "$SCOPE_PROJECT" = true ] && [ -d ".git" ] && [ -f ".gitignore" ]; then
    if ! grep -q "settings.local.json" .gitignore; then
      echo -e "\n# AI Agent Local Settings\n.claude/settings.local.json\n.claude/mcp.json\n.cursor/workspace.json\n.windsurf/workspace.json" >> .gitignore
    fi
  fi
  echo ""
fi

# ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
# Step 4: Health Check
# ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
echo "🔍 Step 4: Health check"
for path in "$ANTIGRAVITY_RULES" "$CLAUDE_RULES" "$WINDSURF_RULES_GLOBAL" "$CURSOR_RULES/memory-rules.mdc"; do
  [ -L "$path" ] && echo "   ✅ Rule link: $(basename $path)" || echo "   ⚠️  Missing/Invalid rule link: $(basename $path)"
done
for path in "$ANTIGRAVITY_WORKFLOWS" "$CLAUDE_COMMANDS" "$WINDSURF_WORKFLOWS"; do
  [ -L "$path" ] && echo "   ✅ Workflow link: $(basename $path)" || echo "   ⚠️  Missing/Invalid workflow link: $(basename $path)"
done

echo ""
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "✅ All done! (~/.agents is now your source of truth)"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
