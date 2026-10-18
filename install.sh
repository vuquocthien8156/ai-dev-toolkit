#!/usr/bin/env bash
# ai-dev-toolkit installer. Safe to re-run.
#   core         ~/.agents/AGENTS.md and ~/.agents/rules -> this repo (symlinks, always installed)
#   claude       ~/.claude/CLAUDE.md managed block, settings.json model keys, Haiku helper agents
#   codex        ~/.codex/AGENTS.md -> ~/.agents/AGENTS.md (symlink)
#   antigravity  ~/.gemini/GEMINI.md -> ~/.agents/AGENTS.md (symlink)
# Usage: ./install.sh [--claude] [--codex] [--antigravity] [--with-jev]
#   No target flag: install every tool whose config dir exists (~/.claude, ~/.codex, ~/.gemini).
#   --with-jev  Claude step only: also install jev-router (third-party proxy; needs TYPESAFE_API_KEY).
# Files that change are backed up to ~/.agents/backups/<stamp>/ first.
set -euo pipefail

DO_CLAUDE=0; DO_CODEX=0; DO_ANTIGRAVITY=0; WITH_JEV=0; PICKED=0
for arg in "$@"; do
  case "$arg" in
    --claude) DO_CLAUDE=1; PICKED=1 ;;
    --codex) DO_CODEX=1; PICKED=1 ;;
    --antigravity) DO_ANTIGRAVITY=1; PICKED=1 ;;
    --with-jev) WITH_JEV=1 ;;
    -h|--help) sed -n '2,10p' "$0"; exit 0 ;;
    *) echo "Unknown option: $arg" >&2; exit 1 ;;
  esac
done
if [ "$PICKED" = 0 ]; then
  if [ -d "$HOME/.claude" ]; then DO_CLAUDE=1; fi
  if [ -d "$HOME/.codex" ]; then DO_CODEX=1; fi
  if [ -d "$HOME/.gemini" ]; then DO_ANTIGRAVITY=1; fi
fi

SRC="$(cd "$(dirname "$0")" && pwd)"
CORE="$HOME/.agents/AGENTS.md"
BACKUP_DIR="$HOME/.agents/backups/$(date +%Y%m%d-%H%M%S)-$$"
JEV_ROUTER_VERSION="1.6.0"
# The sonnet alias resolves to Sonnet 5.5 only from this CLI version (agents pin the Haiku ID).
MIN_CLI="2.1.284"
TMP="$(mktemp)"
trap 'rm -f "$TMP"' EXIT

# Fail before touching anything when the Claude step cannot run.
if [ "$DO_CLAUDE" = 1 ] && ! command -v jq >/dev/null; then
  echo "jq is required for the Claude step (brew install jq), or run without --claude." >&2
  exit 1
fi

# backup cp|mv <path>: copy the path, or move it away, into $BACKUP_DIR (keeps its path under $HOME).
backup() {
  local dest="$BACKUP_DIR/${2#"$HOME"/}"
  mkdir -p "$(dirname "$dest")"
  if [ "$1" = mv ]; then mv "$2" "$dest"; else cp -RP "$2" "$dest"; fi
  echo "  backup: $dest"
}

# link <target> <dest>: make dest a symlink to target. An existing file, dir or other link is moved
# to the backup, never deleted.
link() {
  if [ -L "$2" ] && [ "$(readlink "$2")" = "$1" ]; then echo "ok:      $2"; return 0; fi
  if [ -e "$2" ] || [ -L "$2" ]; then backup mv "$2"; fi
  mkdir -p "$(dirname "$2")"
  ln -s "$1" "$2"
  echo "linked:  $2 -> $1"
}

# put <new> <dest>: copy new over dest only when the content differs (backup first).
put() {
  if [ -f "$2" ] && cmp -s "$1" "$2"; then echo "ok:      $2"; return 0; fi
  if [ -e "$2" ]; then backup cp "$2"; fi
  cp "$1" "$2"
  echo "updated: $2"
}

install_core() {
  echo "== core"
  link "$SRC/core/AGENTS.md" "$CORE"
  link "$SRC/core/rules" "$HOME/.agents/rules"
}

install_claude() {
  echo "== claude"
  local dir="$HOME/.claude" cli body=""
  mkdir -p "$dir/agents"

  cli="$(claude --version 2>/dev/null | awk '{print $1}' || true)"
  if [ -z "$cli" ]; then
    echo "WARNING: claude CLI not found; install Claude Code $MIN_CLI or newer." >&2
  elif [ "$(printf '%s\n%s\n' "$MIN_CLI" "$cli" | sort -V | head -1)" != "$MIN_CLI" ]; then
    echo "WARNING: Claude Code $cli is older than $MIN_CLI; run 'claude update'." >&2
  fi
  # The Explore agent's shell commands rely on these tools; the routing rules prefer rg.
  for tool in sg fd bat rg; do
    command -v "$tool" >/dev/null || echo "WARNING: '$tool' not found (brew install ast-grep fd bat ripgrep)." >&2
  done

  # 1. Model keys in settings.json (all other keys are kept).
  if [ -f "$dir/settings.json" ]; then cat "$dir/settings.json"; else echo '{}'; fi |
    jq '.model = "sonnet"
        | .advisorModel = "opus"
        | .env = ((.env // {}) + {"CLAUDE_CODE_SUBAGENT_MODEL": "sonnet"})' > "$TMP"
  put "$TMP" "$dir/settings.json"

  # 2. Haiku read-only agents. On case-insensitive filesystems Explore.md replaces explore.md.
  for f in "$SRC"/adapters/claude/agents/*.md; do
    put "$f" "$dir/agents/$(basename "$f")"
  done

  # 3. Managed block in CLAUDE.md; lines outside the block are kept.
  #    $(...) strips trailing newlines, so exactly one blank line precedes the block on every run.
  if [ -f "$dir/CLAUDE.md" ]; then
    body="$(awk '/<!-- claude-setup:begin -->/{skip=1} !skip{print} /<!-- claude-setup:end -->/{skip=0}' "$dir/CLAUDE.md")"
  fi
  { if [ -n "$body" ]; then printf '%s\n\n' "$body"; fi; cat "$SRC/adapters/claude/claude-block.md"; } > "$TMP"
  put "$TMP" "$dir/CLAUDE.md"
  if printf '%s\n' "$body" | grep -qxF "$(head -1 "$SRC/core/AGENTS.md")"; then
    echo "WARNING: CLAUDE.md still holds a copy of the core rules; delete it (the block imports them)." >&2
  fi

  # 4. Shared skills dir, only when Claude has none yet.
  if [ ! -e "$dir/skills" ] && [ ! -L "$dir/skills" ] && [ -d "$HOME/.agents/skills" ]; then
    link "$HOME/.agents/skills" "$dir/skills"
  fi

  # 5. Optional: Jev router (sends all Claude Code traffic through a local proxy).
  if [ "$WITH_JEV" = 1 ]; then
    command -v npx >/dev/null || { echo "Node.js 22+ is required for --with-jev" >&2; exit 1; }
    echo "Installing jev-router@$JEV_ROUTER_VERSION (interactive; asks for your Jev key)..."
    npx --yes "@ediri/jev-router@$JEV_ROUTER_VERSION" setup
    jev-router doctor || true
  fi
}

install_codex() {
  echo "== codex"
  link "$CORE" "$HOME/.codex/AGENTS.md"
}

install_antigravity() {
  echo "== antigravity"
  link "$CORE" "$HOME/.gemini/GEMINI.md"
}

install_core
if [ "$DO_CLAUDE" = 1 ]; then install_claude; fi
if [ "$DO_CODEX" = 1 ]; then install_codex; fi
if [ "$DO_ANTIGRAVITY" = 1 ]; then install_antigravity; fi

echo
if [ -d "$BACKUP_DIR" ]; then echo "Backups: $BACKUP_DIR"; fi
echo "Done. Restart your AI tools to load the new rules."
if [ "$DO_CLAUDE" = 1 ]; then
  echo "Claude desktop app: pick Sonnet in the model menu; the app's picker overrides settings.json."
fi
