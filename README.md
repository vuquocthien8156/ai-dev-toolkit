# AI Dev Toolkit

Personal collection of curated AI agent skills, workflows, user rules, and development guides. Designed for **Antigravity**, **Cursor**, and **Claude Code** with cross-IDE support.

## Quick Start

```bash
# Clone this repo
git clone <your-repo-url> ~/Documents/ai-dev-toolkit

# Run bootstrap on any project
cd ~/Documents/Zigvy/hr-leave-module
~/Documents/ai-dev-toolkit/scripts/setup-antigravity.sh
```

## Structure

```
ai-dev-toolkit/
├── README.md                       ← This file
├── skills/                         ← Global skills (all projects)
│   ├── ddd-core-rules/SKILL.md     ← DDD best practices
│   ├── typescript-mastery/SKILL.md  ← TS patterns & type safety
│   ├── code-review/SKILL.md        ← Systematic review checklist
│   └── git-workflow/SKILL.md       ← Git conventions
├── workflows/                      ← Global workflows (/command)
│   ├── plan.md                     ← /plan — structured planning
│   ├── review.md                   ← /review — code review
│   ├── debug.md                    ← /debug — systematic debugging
│   ├── docs.md                     ← /docs — knowledge routing
│   ├── verify.md                   ← /verify — verification before done
│   └── scan-modules.md             ← /scan-modules — auto-generate READMEs
├── user-rules/
│   └── memory-rules.md             ← Copy into IDE global settings
├── references/
│   └── skill-discovery.md          ← How to find & install skills
├── plans/                          ← Implementation plans archive
│   ├── plan-core.md
│   ├── plan-hr-leave-module.md
│   └── plan-hr-forte-mobile.md
└── scripts/
    └── setup-antigravity.sh        ← Bootstrap script
```

## 3-Tier Automation System

| Tier                       | Mechanism                         | When Active                      | Location              |
| -------------------------- | --------------------------------- | -------------------------------- | --------------------- |
| **1. MEMORY (User Rules)** | Always active, every conversation | Automatically                    | IDE Settings → Global |
| **2. Skills (SKILL.md)**   | AI reads when relevant to task    | Semi-auto (description matching) | `.agent/skills/`      |
| **3. Workflows (.md)**     | Triggered by `/command`           | Manual                           | `.agent/workflows/`   |

### Tier 1: User Rules (Always Active)

Rules pasted into IDE → Settings → User Rules. Applied to **every** conversation regardless of project.

See [user-rules/memory-rules.md](user-rules/memory-rules.md) for full rules.

Key sections:

- **I–IV**: Proposal-only mode, Vietnamese reports, coding standards, project awareness
- **V**: Workflow Orchestration (plan mode, self-improvement, elegance, autonomous bug fixing)
- **VI**: Task Management (plan first, verify, track, capture lessons)
- **VII**: Core Principles (simplicity, no laziness, minimal impact)
- **VIII**: Context-Aware Coding (auto-detect DDD/Legacy, proactive flags)
- **IX**: Knowledge Routing (auto-classify knowledge → docs/skills/workflows)
- **X**: Verification Before Done (re-read plan, compile check, explicit status)
- **XI**: Language Rule (Vietnamese prompt OK, English output only)

### Tier 2: Skills (Semi-Auto)

AI reads `SKILL.md` when its `description` field matches the current task context.

**Global skills** (this repo → `~/.gemini/antigravity/skills/`):

- `ddd-core-rules` — DDD patterns applicable to any project
- `typescript-mastery` — TypeScript patterns & type safety
- `code-review` — Systematic review checklist
- `git-workflow` — Git conventions & commit standards

**Project skills** (per-project `.agent/skills/`):

- `project-context` — How this specific project works (architecture, DB, patterns)
- `knowledge-router` — Auto-classify knowledge from conversations

### Tier 3: Workflows (Manual Trigger)

Type `/plan`, `/review`, `/debug`, etc. in chat to trigger structured processes.

## Skill Discovery

### Find skills

```bash
# Search for skills by keyword
npx skills find <query>

# Examples
npx skills find "react native"
npx skills find "nestjs"
npx skills find "typescript"
```

### Install skills

```bash
# Install from GitHub repo
npx skills add <owner/repo>

# Install specific skill from a repo
npx skills add <owner/repo> --skill <skill-name>
```

### Browse curated catalogs

| Catalog                  | URL                                                                                                                     | Best for                       |
| ------------------------ | ----------------------------------------------------------------------------------------------------------------------- | ------------------------------ |
| **skills.sh**            | [skills.sh](https://skills.sh)                                                                                          | Browse by category, popularity |
| **Antigravity Awesome**  | [sickn33/antigravity-awesome-skills](https://github.com/sickn33/antigravity-awesome-skills)                             | Antigravity-specific           |
| **Awesome Agent Skills** | [VoltAgent/awesome-agent-skills](https://github.com/VoltAgent/awesome-agent-skills)                                     | Cross-platform                 |
| **Awesome Cursorrules**  | [PatrickJS/awesome-cursorrules](https://github.com/PatrickJS/awesome-cursorrules/tree/main/rules)                       | 100+ stack-specific rules      |
| **Antigravity Prompts**  | [x1xhlol/system-prompts](https://github.com/x1xhlol/system-prompts-and-models-of-ai-tools/tree/main/Google/Antigravity) | Reference prompts              |

> **Note**: Cursor `.cursorrules` files need adaptation to `SKILL.md` format (add YAML frontmatter with `name` + `description`).

## Cross-IDE Support

This toolkit supports multiple AI coding assistants:

| AI Tool         | Skills path       | Setup                  |
| --------------- | ----------------- | ---------------------- |
| **Antigravity** | `.agent/skills/`  | Direct (native)        |
| **Cursor**      | `.cursor/skills/` | Symlink from `.agent/` |
| **Claude Code** | `.claude/skills/` | Symlink from `.agent/` |

The bootstrap script creates symlinks automatically.

## Vietnamese Prompting

You can prompt in Vietnamese. MEMORY rules are language-agnostic — AI understands regardless of input language. However, **all output** (code, comments, docs, skills, commits) MUST be in English per Rule XI.

## Setup for New Team Members

1. **Clone project** → `.agent/`, `docs/`, workflows are included
2. **Run** `./scripts/setup-antigravity.sh` → installs global skills
3. **Copy User Rules** from `user-rules/memory-rules.md` → paste into IDE global settings
4. **Done** — pre-commit hooks work, AI understands project context
# ai-dev-toolkit
