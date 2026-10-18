# Toolkit install plan v1

Written 2026-10-18. Replaces the earlier `HANDOFF.md` notes (local only, not in the repo).
A new session can resume from this file alone.

## Goal

The toolkit is the owner's **personal layer**: working style (rules) plus machine setup.
Anything the owner could install from upstream (community skills) is not copied here.

Test for every file: is it personal, or not available upstream? If neither, it does not belong.

## Decisions (approved by the owner)

1. Scope: a general `core/` used by Claude Code, Codex and Antigravity, plus a Claude-only adapter.
2. `user-rules/` is kept and moves to `core/rules/` (flat).
3. Codex and Antigravity global files are **symlinks** to `core/AGENTS.md`.
   Trade-off: if a tool appends text to its global file, it lands in the repo and shows in `git status`.
4. Claude `CLAUDE.md` stays a real file with a managed block that imports `@~/.agents/AGENTS.md`.
   Lines outside the block (for example `@RTK.md`) are left alone.
5. Jev stays opt-in (`--with-jev`).
6. Never copy or link tool configs with secrets into the repo:
   `config.toml`, `auth.json`, `oauth_creds.json`, `settings.json`.

## Layout

```
ai-dev-toolkit/
├── install.sh
├── core/
│   ├── AGENTS.md          general rules (tool-neutral target)
│   └── rules/             backend/frontend/mobile, workflow-protocol, examples-violations
├── adapters/claude/
│   ├── agents/            Explore.md, search.md, grep.md, docs.md (Haiku 5.5)
│   └── claude-block.md    managed CLAUDE.md block (core import + model routing)
└── README.md
```

## What install.sh does

| Target | Action | Kind |
|---|---|---|
| core (always) | `~/.agents/AGENTS.md` -> `core/AGENTS.md`, `~/.agents/rules` -> `core/rules` | symlink |
| claude | managed block in `~/.claude/CLAUDE.md`; merge model keys into `settings.json` (jq); copy agents; link `~/.claude/skills` -> `~/.agents/skills` only if missing; optional jev | real files |
| codex | `~/.codex/AGENTS.md` -> `core/AGENTS.md` | symlink |
| antigravity | `~/.gemini/GEMINI.md` -> `core/AGENTS.md` | symlink |

- No target flag: install every tool whose config dir exists.
- Backups go to `~/.agents/backups/<stamp>/` and only when a file changes.
- The link helper moves an existing file or dir to the backup. It never runs `rm -rf`.
- Keep marker names `claude-setup:begin/end` so old blocks are replaced, not duplicated.
- `jq` is required only by the Claude step.

## Phases

- **Phase 0**: branch `chore/slim-toolkit`, tag `pre-cleanup`.
- **Phase 1 (add only, delete nothing)**: add `core/`, `adapters/claude/`, `install.sh`.
  Test in a fake HOME (empty, and a copy of the real config), run twice, checksums stable.
  One-time manual migration on the owner's Mac: remove the copied rules body from
  `~/.claude/CLAUDE.md` (the block now imports it). Show the diff before writing.
  Commit. Use at work for 1-2 weeks.
- **Phase 2 (repo cleanup)**: delete `skills/`, `workflows/`, `templates/`, `archive/`, `# LLM Wiki`,
  `scripts/`, `package.json`, `.npmignore`, `user-rules/`. Rewrite `README.md` (~30 lines).
  Clean machine leftovers (`~/.agents/workflows`, `~/.agents/templates`, `~/.agents/user-rules`,
  old `.bak` files, `~/dotfiles/claude-setup`, broken `~/.cursor/rules/*.mdc` links). Ask before each delete.
- **Phase 3 (content)**: make `core/AGENTS.md` tool-neutral and shorter (it mentions plan mode, `/docs`,
  Claude-only habits). Review technical rules. Add `SOURCES.md` (borrowed ideas with links).
  `skills.txt` was done early (2026-10-18, archify only); filling it is in Next steps.

## Learning from other repos

1. **Consume** (default): `npx skills add owner/repo --skill x`, pinned in `skills.txt`.
2. **Extract**: one idea rewritten as 1-3 lines in `core/AGENTS.md`, source in `SOURCES.md`.
   Only when the pain was felt in the last 2 weeks.
3. **Fork**: almost never; only if you will maintain it and upstream will not take it.

Trial rule: new skills go project-local first, then global or removed after 1-2 weeks.
Project-specific skills live in that project's repo, not here.

## Open items to verify

- `@~/` imports in `CLAUDE.md` load in practice (check with `/memory` after restart).
- Codex reads `~/.agents/skills` natively.
- Whether Antigravity reads `~/.agents/skills`. On the owner's Mac, `~/.gemini/antigravity/skills` links to
  `~/.gemini/config/skills`, which holds its own copy of archify (not managed by `install.sh`).
- Whether Antigravity supports imports in `GEMINI.md`.
- Old `~/.cursor/rules/*.mdc` symlinks point into `~/.agents/rules/{core,technical}` and break
  once `~/.agents/rules` becomes a symlink (Cursor is out of scope).

## Next steps (in order)

1. Push `chore/slim-toolkit` (owner approves each push).
2. Second device: clone, `./install.sh --with-skills`, restart, check `/memory` (core import loads)
   and `/agents` (Haiku agents). Note what is missing.
3. Personal skills: design where they live in the repo (for example `skills/<name>/SKILL.md`, kept
   flat) and how `install.sh` links them into `~/.agents/skills`. Owner approves the design first.
   Move the 27 skills (see Progress log), drop the ones not used. Must finish before Phase 2.
4. Trim the ~35 upstream skills installed on the owner's Mac (`~/.agents/.skill-lock.json`, 11 entries
   stale): keep only what is used, pin each in `skills.txt`.
5. Phase 2 (repo and machine cleanup, see Phases).
6. Phase 3 (content, see Phases).

## Open decisions (owner)

- Jev: keep `--with-jev` or drop it (recommendation: drop).
- Where `biner`, `notion-format` and `markdown-document-structurer` came from (upstream or own).

## Progress log

- 2026-10-18: plan approved; Phase 0 and Phase 1 started.
- 2026-10-18: Phase 1 committed (`1b01c27` on `chore/slim-toolkit`, tag `pre-cleanup`). Tests passed:
  empty fake HOME, fake HOME with a copy of the real config (run twice, no changes on run 2),
  missing jq, and a fresh `git clone` + install in a clean Alpine container.
- Pending owner approval: real-Mac run + one-time CLAUDE.md migration; remove rtk from the machine
  (owner is not sure it helps); push the branch so a second machine can clone it.
- Owner direction: be critical; keep only what is proven useful. Jev: recommend dropping the flag.
- Real-Mac links that break when `~/.agents/rules` becomes a symlink: `~/.cursor/rules/*.mdc` (5)
  and `~/.windsurfrules`.
- 2026-10-18: full guide. `README.md` rewritten for the new installer (prerequisites with commands,
  step-by-step walkthrough, backups/restore, Jev guide, uninstall, troubleshooting). `install.sh`
  messages now print exact install commands; `--with-jev` checks Node 22+ and the Claude step up front.
  Re-tested: fake HOME (empty, all tools, run twice), jev guards, Alpine container (no jq, run twice).
- 2026-10-18: real-Mac run done (backup `~/.agents/backups/20261018-202727-17257`). `CLAUDE.md` is now the
  managed block only; rtk removed (hook in `~/.claude/settings.json`, `~/.codex/hooks.json`, `~/.claude/RTK.md`
  moved to backup; rtk binary still installed). Re-run: all `ok:`. Cursor/Windsurf dropped by the owner
  (their links are now broken; clean up in Phase 2). Branch pushed. Import not yet confirmed with `/memory`.
- 2026-10-18: `skills.txt` + `install.sh --with-skills` (archify only, pinned `tt-a1i/archify#v3.1.0`,
  `skills` CLI pinned to 1.5.18, telemetry off). Tested in fake HOME: empty (run twice, second run all `ok:`),
  Mac-like with `~/.claude/skills -> ~/.agents/skills` (no self-loop, other skills untouched), no tool and
  no npx guards (stop before any change), remove + reinstall, no-flag run unchanged. Not run on the real Mac.
- Claude Code facts (docs, 2026-10-18): native `AGENTS.md` is project-scoped only (v2.1.277+), loads only
  when the project has no `CLAUDE.md` (default), never reads `~/.agents/`. Claude skills dirs do not include
  `~/.agents/skills`, so the `~/.claude/skills` link stays. Keep the global `@~/.agents/AGENTS.md` import.
- Blocker for Phase 2: 27 personal skills on disk are not in the skills lock (from repo `skills/`,
  `workflows/`, and unknown: `biner`, `notion-format`, `markdown-document-structurer`). Move them into the
  repo before deleting `skills/` or `workflows/`.
