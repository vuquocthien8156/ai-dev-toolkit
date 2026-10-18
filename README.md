# ai-dev-toolkit

My personal layer for AI coding tools: **working style (rules) + machine setup**.
One set of rules is shared by Claude Code, Codex and Antigravity. Claude Code gets a few extra,
Claude-only settings on top.

Anything that can be installed from upstream (community skills, plugins) is **not** copied here.

> Status: branch `chore/slim-toolkit`. Old folders (`skills/`, `workflows/`, `templates/`,
> `scripts/`, `user-rules/`, ...) are still in the repo and will be removed in Phase 2.
> `install.sh` does not use them. Do **not** run the old `scripts/setup.sh` or `scripts/cleanup.sh`:
> they wipe `~/.agents/skills` and `~/.claude/skills`. Plan: `docs/plans/toolkit-install-plan-v1.md`.

## Contents

- [Quick start](#quick-start)
- [Prerequisites](#prerequisites)
- [Install on another machine](#install-on-another-machine)
- [Options](#options)
- [What install.sh does, step by step](#what-installsh-does-step-by-step)
- [Reading the output](#reading-the-output)
- [After install](#after-install)
- [Updating](#updating)
- [Backups and restore](#backups-and-restore)
- [Skills](#skills)
- [Optional: Jev](#optional-jev)
- [What is not installed](#what-is-not-installed)
- [Uninstall](#uninstall)
- [Security notes](#security-notes)
- [Troubleshooting](#troubleshooting)
- [Repo layout](#repo-layout)

## Quick start

```bash
cd ~/Documents/Coder/Personal/ai-dev-toolkit
./install.sh
```

With no options it installs the core rules, plus every tool whose config folder exists
(`~/.claude`, `~/.codex`, `~/.gemini`). It is safe to run again: a second run changes nothing.

## Prerequisites

Supported: macOS and Linux (bash and symlinks). Windows is not supported.

| Need | Why | Check | Install (macOS) |
|---|---|---|---|
| Homebrew | installs the tools below | `brew --version` | see below |
| git | clone this repo | `git --version` | `xcode-select --install` or `brew install git` |
| jq | Claude step edits `settings.json` | `jq --version` | `brew install jq` |
| Claude Code 2.1.284+ | the `sonnet` alias maps to Sonnet 5.5 from this version | `claude --version` | see below |
| ripgrep, fd, bat, ast-grep | used by the Haiku helper agents and the routing rules | `rg --version` | `brew install ripgrep fd bat ast-grep` |
| Node.js | only for `--with-skills` (any recent version) and `--with-jev` (22+) | `node --version` | `brew install node` |

Install Homebrew (if `brew` is not found):

```bash
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
```

Install Claude Code (pick one). It needs a Pro, Max, Team, Enterprise or Console account.

```bash
curl -fsSL https://claude.ai/install.sh | bash
```

```bash
brew install --cask claude-code
```

Then run `claude` once to log in. Check with `claude doctor`. Update with `claude update`
(Homebrew install: `brew upgrade claude-code`; it does not auto-update).

On Linux, use your package manager for git, jq, ripgrep, fd, bat and ast-grep
(for example `sudo apt install git jq ripgrep fd-find bat`; on Debian/Ubuntu the binaries may be
named `fdfind` and `batcat`).

Missing tools are not fatal, except `jq` for the Claude step:

- No `jq` + Claude step: the script stops **before** it changes anything.
- No `claude`, `rg`, `fd`, `bat` or `sg`: the script prints a `WARNING` with the install command
  and continues.

## Install on another machine

1. Install the [prerequisites](#prerequisites).
2. Install and open each AI tool once, so its config folder exists (`~/.claude`, `~/.codex`,
   `~/.gemini`). Or name the tools with flags (see [Options](#options)).
3. Clone and run:

   ```bash
   git clone https://github.com/vuquocthien8156/ai-dev-toolkit.git ~/Documents/Coder/Personal/ai-dev-toolkit
   ```

   (With an SSH key for this GitHub account you can use `git@github.com:vuquocthien8156/ai-dev-toolkit.git`.
   The branch must be pushed first, or `git switch` fails.)

   ```bash
   cd ~/Documents/Coder/Personal/ai-dev-toolkit && git switch chore/slim-toolkit
   ```

   ```bash
   ./install.sh
   ```

   Or, to also install the skills in `skills.txt` (needs Node.js and network):

   ```bash
   ./install.sh --with-skills
   ```

4. Do the [After install](#after-install) steps.

What a new machine does **not** get yet:

- Personal skills (`code-review`, `typescript-mastery`, `verify`, `debug`, ...). `core/AGENTS.md`
  names them, but they are not in `skills.txt` yet, so the agent cannot load them there.
- Other upstream skills, unless they are in `skills.txt`.
- Plugins, MCP servers, hooks. Install them by hand if you need them.

Important: keep the clone where it is. The core rules are **symlinks** into this folder.
If you move or delete the folder, the links break. If you move it, run `./install.sh` again.

## Options

```
./install.sh [--claude] [--codex] [--antigravity] [--with-skills] [--with-jev] [-h|--help]
```

| Option | Effect |
|---|---|
| (none) | core + every tool whose config folder exists |
| `--claude` | core + Claude Code only |
| `--codex` | core + Codex only |
| `--antigravity` | core + Antigravity only |
| `--with-skills` | also install the skills in `skills.txt` for the selected tools (see [Skills](#skills)) |
| `--with-jev` | with the Claude step: also install jev-router (see [Optional: Jev](#optional-jev)) |
| `-h`, `--help` | show help |

Flags can be combined, for example `./install.sh --claude --codex`.
Core is always installed.

## What install.sh does, step by step

You do not need to read the script. This is everything it does, in order.

**0. Checks (nothing is changed yet)**

- Reads the options and picks the tools to install.
- If the Claude step will run and `jq` is missing: stops with an error.
- If `--with-skills` is given but no tool is selected, or `npx` (Node.js) is missing: stops with an error.
- If `--with-jev` is given but the Claude step will not run, or Node.js 22+ is missing: stops with an error.

**1. Core (always)**

| Link | Points to |
|---|---|
| `~/.agents/AGENTS.md` | `<repo>/core/AGENTS.md` (general rules) |
| `~/.agents/rules` | `<repo>/core/rules` (backend, frontend, mobile, workflow-protocol, examples-violations) |

`~/.agents/AGENTS.md` is the hub. Every tool reads its rules through it.

**2. Claude Code** (`--claude`, or `~/.claude` exists)

1. Checks the `claude` version and the helper tools (`sg`, `fd`, `bat`, `rg`). Prints a warning
   with the install command for anything missing. Does not stop.
2. `~/.claude/settings.json`: sets 3 keys and keeps every other key as it is:
   - `"model": "sonnet"`: main model.
   - `"advisorModel": "opus"`: the advisor tool uses Opus.
   - `"env": {"CLAUDE_CODE_SUBAGENT_MODEL": "sonnet"}`: sub-agents use Sonnet by default.
3. `~/.claude/agents/`: copies 4 read-only helper agents that run on Haiku
   (`claude-haiku-5-5`): `Explore`, `search`, `grep`, `docs`. Other agent files are not touched.
   On macOS, `Explore.md` replaces an old `explore.md` (same name, different case).
4. `~/.claude/CLAUDE.md`: writes a **managed block** between
   `<!-- claude-setup:begin -->` and `<!-- claude-setup:end -->`
   (source: `adapters/claude/claude-block.md`). The block:
   - imports the core rules with `@~/.agents/AGENTS.md`;
   - adds the model routing rules (use Haiku helpers for read-only work, call the advisor
     before finalizing a plan and before reporting done, use `rg` not `grep -r`).

   Your own lines outside the block are kept. An old block is replaced, never duplicated.
   If `CLAUDE.md` still holds a full copy of the core rules, it prints a warning:
   delete that copy by hand, because the block already imports it.

   Why an import and not `AGENTS.md`: Claude Code (2.1.277+) reads `AGENTS.md` natively, but only
   inside a project (the working folder and its parents), and by default only when that project has
   no `CLAUDE.md`. It never reads files under `~/.agents/`. So the global rules need this import.
   A project repo can still ship just an `AGENTS.md`, and Claude, Codex and Antigravity all read it.
5. `~/.claude/skills`: if it does not exist and `~/.agents/skills` exists, links it there,
   so Claude Code sees the same skills as the other tools. An existing `~/.claude/skills` is not touched.
6. Only with `--with-jev`: runs the jev-router setup (see [Optional: Jev](#optional-jev)).

`settings.json`, `CLAUDE.md` and the agents are real files, not links, because other tools
and you also write to them.

**3. Codex** (`--codex`, or `~/.codex` exists)

- Link `~/.codex/AGENTS.md` -> `~/.agents/AGENTS.md`.

**4. Antigravity** (`--antigravity`, or `~/.gemini` exists)

- Link `~/.gemini/GEMINI.md` -> `~/.agents/AGENTS.md`.

**5. Skills** (only with `--with-skills`)

- For each line in `skills.txt`, runs the pinned `skills` CLI:
  `npx skills@1.5.18 add <owner>/<repo>#<tag> -g -s <name> -a <tools> -y`.
- The CLI keeps one copy in `~/.agents/skills/<name>`. It counts Codex and Antigravity as reading
  that folder directly (not yet checked in those tools). Claude Code sees it through the
  `~/.claude/skills` link from step 2.5 (the script creates `~/.agents/skills` first, so the link is
  made on a new machine too). Only if `~/.claude/skills` is already a real folder does the CLI add a
  per-skill link inside it.
- The script stops with an error if a skill is not in `~/.agents/skills/` after the CLI ran
  (wrong tag or name), or if a line in `skills.txt` has no skill name.
- A skill that is already in `~/.agents/skills/` is skipped (`ok:`), so a re-run needs no network.
- Telemetry of the `skills` CLI is turned off (`DO_NOT_TRACK=1`).

**6. Summary**

- Prints the backup folder (only if something was backed up) and the next steps.

**Safety rules the script follows**

- It never deletes anything. A file or folder in the way of a link is **moved** to the backup folder.
- A file is backed up and rewritten only when its content really changes.
- It never copies tool configs with secrets (`config.toml`, `auth.json`, `oauth_creds.json`) into
  the repo, and never links `settings.json`.

## Reading the output

| Prefix | Meaning |
|---|---|
| `== core` | a new section starts |
| `ok:` | already correct, nothing changed |
| `linked:` | a symlink was created |
| `updated:` | a file was written |
| `added:` | a skill from `skills.txt` was installed |
| `  backup:` | the old version was saved here first |
| `WARNING:` | something is missing; the install continues |

## After install

1. Restart your AI tools (quit and open again) so they load the new rules.
2. Claude Code CLI: run `/model` and check it shows Sonnet. Or set it once: `/model claude-sonnet-5-5`.
3. Claude desktop app: pick **Sonnet** in the model menu. The app's picker overrides `settings.json`.
4. In Claude Code, run `/agents` and check that `Explore`, `search`, `grep` and `docs` use Haiku.
5. In Claude Code, run `/memory` and check that `~/.agents/AGENTS.md` is loaded through the import.

## Updating

```bash
cd ~/Documents/Coder/Personal/ai-dev-toolkit && git pull
```

- Core rules (`core/`) are links: the change is live right away. Just restart the tools.
- Claude files (`adapters/claude/`) are copies: run `./install.sh` again after a pull.

To change a rule, edit `core/AGENTS.md` or `core/rules/*` in this repo and commit.
Do not edit `~/.agents/AGENTS.md` and expect it to stay private: it **is** the repo file.

## Backups and restore

Each run that changes something makes one folder: `~/.agents/backups/<date>-<time>-<pid>/`.
Inside, files keep their path under your home folder. Example:

```
~/.agents/backups/20261018-101500-1234/.claude/CLAUDE.md      # was ~/.claude/CLAUDE.md
~/.agents/backups/20261018-101500-1234/.codex/AGENTS.md       # was ~/.codex/AGENTS.md
```

Restore a real file (for example `CLAUDE.md`):

```bash
cp ~/.agents/backups/<stamp>/.claude/CLAUDE.md ~/.claude/CLAUDE.md
```

Restore something that the script replaced with a link (for example Codex):

```bash
rm ~/.codex/AGENTS.md && mv ~/.agents/backups/<stamp>/.codex/AGENTS.md ~/.codex/AGENTS.md
```

`rm` on a symlink removes only the link, not the file it points to.
Backups are never cleaned up automatically. Delete old ones by hand when you are sure.

## Skills

`skills.txt` lists upstream skills, pinned to a git tag so every machine gets the same version:

```
tt-a1i/archify#v3.1.0 archify
```

Install them (with the tools you use):

```bash
./install.sh --with-skills
```

Read this first:

- Skills are third-party code and run with full agent permissions. Read a skill before you add it.
- Some skills call the network themselves (for example archify checks for its own updates).

Add a skill: find its repo and latest tag, add one line `<owner>/<repo>#<tag> <skill-name>`,
then run `./install.sh --with-skills`. List the skills in a repo with:

```bash
npx skills add <owner>/<repo> --list
```

Upgrade a skill: change its tag in `skills.txt`, remove the old copy, then install again:

```bash
npx skills remove <skill-name> -g -y
```

```bash
./install.sh --with-skills
```

Skills you wrote yourself are not in `skills.txt` yet (planned, see `docs/plans/`).

## Optional: Jev

[jev-router](https://github.com/dirien/jev-router) is a third-party router: Claude Code sends
requests to a local proxy, and the proxy picks a model through Jev. It is **off by default**.

Read this first:

- **Privacy:** your prompts and code go to a third party (TypeSafe or OpenRouter), not only to Anthropic.
  Check your company rules before you use it at work.
- It runs as a background service (launchd on macOS, systemd on Linux).
  **If the service stops, Claude Code cannot connect.**
- Its setup changes `~/.claude/settings.json` `env`: `ANTHROPIC_BASE_URL=http://127.0.0.1:4000`,
  `CLAUDE_CODE_GATEWAY_HINT_HEADERS=1`, `CLAUDE_CODE_AUTO_COMPACT_WINDOW=160000`, `ENABLE_TOOL_SEARCH=true`.

Requirements:

- Node.js 22+ (`brew install node`).
- Claude Code 2.1.273+.
- A Jev key from [TypeSafe](https://console.typesafe.ai) or [OpenRouter](https://openrouter.ai).
  Create an account there and copy the key. The setup asks for it.
- No `sudo` needed.

Install through this toolkit (pinned version):

```bash
./install.sh --claude --with-jev
```

Or by hand (the package name is `@ediri/jev-router`; `npx jev-router` is a **different**, unrelated package):

```bash
npx @ediri/jev-router setup
```

Setup saves the key to `~/.config/jev-router/env` and starts the service.

Check it:

```bash
jev-router doctor
```

```bash
curl -s http://127.0.0.1:4000/healthz
```

`jev-router doctor --live` makes one real (paid) request. Live view: http://127.0.0.1:4100

Upgrade:

```bash
npx @ediri/jev-router@latest setup
```

Remove it:

```bash
jev-router uninstall
```

```bash
npm uninstall -g @ediri/jev-router
```

Config stays in `~/.config/jev-router` and `~/.local/state/jev-router`; delete them by hand if you want.
Then check that `ANTHROPIC_BASE_URL` is gone from `~/.claude/settings.json`.

## What is not installed

- The AI apps themselves (Claude Code, Codex, Antigravity). Install them first.
- Skills, unless you pass `--with-skills`, and then only the ones in `skills.txt`.
  Rule 12 in `core/AGENTS.md` names personal skills (`code-review`, `typescript-mastery`, ...)
  that are not in `skills.txt` yet; moving them into this repo is planned.
- Plugins, MCP servers, hooks, status line.
- Cursor and Windsurf. Old links from `~/.cursor/rules/*.mdc` and `~/.windsurfrules` into
  `~/.agents/rules/core/...` break once `~/.agents/rules` points to this repo (flat layout).

## Uninstall

1. Remove the links (only links, the repo files stay):

   ```bash
   rm ~/.agents/AGENTS.md ~/.agents/rules ~/.codex/AGENTS.md ~/.gemini/GEMINI.md
   ```

2. Claude: delete the lines from `<!-- claude-setup:begin -->` to `<!-- claude-setup:end -->` in
   `~/.claude/CLAUDE.md`, and delete `~/.claude/agents/{Explore,search,grep,docs}.md`.
3. Claude `settings.json`: remove the 3 keys by hand, or restore it from a backup.
4. Skills: `npx skills remove <skill-name> -g -y` for each line in `skills.txt`.
5. Put back old files from `~/.agents/backups/<stamp>/` if you want (see [Backups and restore](#backups-and-restore)).

## Security notes

- Never copy or link `~/.codex/config.toml`, `auth.json`, `oauth_creds.json` or
  `~/.claude/settings.json` into this repo. They can hold tokens or passwords.
- Because Codex and Antigravity files are links into the repo, any text a tool appends to
  `~/.codex/AGENTS.md` or `~/.gemini/GEMINI.md` lands in `core/AGENTS.md`.
  Check `git status` and `git diff` before every commit.

## Troubleshooting

| Problem | Fix |
|---|---|
| `jq is required for the Claude step` | `brew install jq`, or run `./install.sh --codex --antigravity` |
| `WARNING: claude CLI not found` | install Claude Code (see [Prerequisites](#prerequisites)) |
| `Claude Code X is older than 2.1.284` | `claude update` (Homebrew: `brew upgrade claude-code`) |
| `--with-skills needs Node.js (npx)` | `brew install node` |
| `--with-skills needs at least one tool` | add `--claude`, `--codex` or `--antigravity` |
| A skill did not update after you changed its tag | it is skipped while installed; see [Skills](#skills) |
| `--with-jev needs Node.js 22 or newer` | `brew install node` |
| `--with-jev needs the Claude step` | add `--claude`, or install Claude Code first |
| A tool was skipped | its config folder does not exist; open the tool once, or pass its flag |
| Rules not loaded | restart the tool; check the link: `ls -l ~/.agents/AGENTS.md` |
| Broken links after moving the repo | run `./install.sh` again from the new place |
| `git status` shows changes in `core/AGENTS.md` you did not make | a tool wrote into a linked file; review with `git diff`, then keep or `git restore` |
| Claude Code cannot connect after Jev | `jev-router doctor`; or `jev-router uninstall` |

## Repo layout

```
ai-dev-toolkit/
├── install.sh                 the installer
├── skills.txt                 pinned upstream skills (--with-skills)
├── core/
│   ├── AGENTS.md              general rules (all tools)
│   └── rules/                 backend, frontend, mobile, workflow-protocol, examples-violations
├── adapters/claude/
│   ├── agents/                Explore.md, search.md, grep.md, docs.md (Haiku)
│   └── claude-block.md        managed CLAUDE.md block (core import + model routing)
└── docs/plans/                plans and progress log
```
