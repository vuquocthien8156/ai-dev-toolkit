# AI Dev Toolkit

Personal toolkit for AI-assisted development. Combines curated skills, workflows, and rules for **Antigravity**, **Cursor**, **Claude Code**, and **GitHub Copilot**.

---

## Table of Contents

- [First-Time Setup](#first-time-setup)
- [What's Automatic vs Manual](#whats-automatic-vs-manual)
- [Repository Structure](#repository-structure)
- [How the 3-Tier System Works](#how-the-3-tier-system-works)
- [Skills Reference](#skills-reference)
- [Workflows Reference](#workflows-reference)
- [Cross-IDE Support](#cross-ide-support)
- [Skill Discovery](#skill-discovery)
- [Updating](#updating)
- [Adding to a New Project](#adding-to-a-new-project)
- [Team Onboarding](#team-onboarding)

---

## First-Time Setup

### Prerequisites

- macOS with Zsh
- Antigravity IDE (primary)
- Git installed

### Step 1: Clone and prepare
```bash
cd ~/Documents
git clone <your-repo-url> ai-dev-toolkit
chmod +x ai-dev-toolkit/scripts/setup.sh
```

### Step 2: Run setup from inside your project
```bash
cd ~/your-project-folder
~/Documents/ai-dev-toolkit/scripts/setup.sh
```

This one command does:
1. Writes global rules to `~/.gemini/GEMINI.md` (Antigravity) and `~/.claude/CLAUDE.md` (Claude Code).
2. Installs community skills and symlinks them to all supported IDEs.
3. Copies workflows/commands to both global and project directories.

> **Selective execution**: Use `--rules`, `--skills`, or `--workflows` to run only specific steps.
> See [Updating](#updating) for details.

### Step 3: Verify in Antigravity

1. Open Antigravity → **Customizations** → **Rules** tab
   - You should see Sections I–XIV (55 rules including Global Skill Trigger Map)
2. Open Antigravity → **Customizations** → **Workflows** tab
   - You should see: plan, review, debug, verify, docs, test, refactor, spike, pr

### Step 4: (Optional) Targeting specific IDEs
By default, `setup.sh` configures both Antigravity and Claude Code. To target one:
```bash
setup.sh --ide antigravity
setup.sh --ide claude
```

---

## What's Automatic vs Manual

### ✅ Automatic (AI does this without prompting)

| What                        | How it works                                                        | Source               |
| --------------------------- | ------------------------------------------------------------------- | -------------------- |
| **Proposal-only mode**      | AI proposes first, asks before editing                              | Section I in rules   |
| **Verify before done**      | AI re-reads checklist, runs type check, reports status              | Section X in rules   |
| **English output**          | All code, comments, docs in English                                 | Section XI in rules  |
| **Lint changed files only** | AI only checks/fixes files it modified                              | Rule 39c in rules    |
| **Skill auto-loading**      | AI loads relevant skills based on Global Skill Trigger Map          | Rule 51 in rules     |
| **Token optimization**      | AI reads file outlines first, summarizes logs, detects context loss | Section XIV in rules |
| **Context loss detection**  | AI stops and asks when context feels stale or uncertain             | Rule 54 in rules     |

### 🔧 Manual (You trigger these)

| What                  | How to trigger                  | When to use                                        |
| --------------------- | ------------------------------- | -------------------------------------------------- |
| **Plan workflow**     | `/plan`            | Starting a new feature or complex task   |
| **Checkpoint**        | `/checkpoint`      | Save task state before session switch    |
| **Status**            | `/status`          | Report current progress vs plan          |
| **Resume**            | `/resume`          | Restore context from past sessions       |
| **Handoff**           | `/handoff`         | Prepare summary for next conversation    |
| **Debug workflow**    | `/debug`           | Stuck on a bug                           |
| **Verify workflow**   | `/verify`          | Before declaring task complete           |
| **Docs workflow**     | `/docs`            | Record business/logic decisions          |
| **Refresh workflow**  | `/refresh-context` | Auto-detect stack, architecture & skills |
| **Setup script**      | `setup.sh`         | New project or toolkit update            |

### 🧠 Semi-Automatic (AI decides based on Skill Trigger Map)

Rule 51 maps specific triggers to skills. The AI prints `📚 Loaded: <skill-name>` when loading:

| Trigger                           | Skill Loaded                              |
| --------------------------------- | ----------------------------------------- |
| Bug report, error trace           | `systematic-debugging`                    |
| Writing/reviewing TypeScript      | `typescript-mastery`                      |
| Code review, PR review, `/review` | `code-review` + `security-best-practices` |
| Git commit, branch, PR            | `git-workflow`                            |
| DDD module detected               | `ddd-core-rules`                          |
| Session > 15 messages             | `context-compression`                     |
| Context feels stale               | `context-optimization`                    |
| Writing tests, `/test`            | `backend-testing`                         |
| Context lost after truncation     | `handoff.md` / `checkpoint.md`            |

> **Tip**: If you don't see `📚 Loaded:` in chat, the AI may not be using skills. Ask: "bạn đã dùng skills nào?"

---

## Repository Structure

```
ai-dev-toolkit/
│
├├── skills/                            ← Self-written skills (→ ~/.agents/skills/)
│   ├── ddd-core-rules/SKILL.md        ← DDD best practices
│   └── ...                            ← TS mastery, code review, git, etc.
│
├── workflows/                         ← Project & Global commands (→ .agent/workflows/ or ~/.claude/commands/)
│   ├── plan.md, checkpoint.md, status.md, resume.md, handoff.md
│   └── debug.md, verify.md, docs.md, test.md, refactor.md, pr.md
│
├── user-rules/
│   └── memory-rules.md                ← Tier 1 rules (→ GEMINI.md / CLAUDE.md)
│
├── scripts/
│   ├── setup.sh                       ← The multi-IDE installer
│   └── skill-registry.json            ← Stack-to-skill mapping for /refresh-context
  └── setup-agent-template.sh        ← Template for per-project .agent/setup.sh
│
├── cross-ide/                         ← Templates for other AI IDEs
│   ├── CLAUDE.md
│   ├── AGENTS.md
│   └── .cursorrules
│
└── references/
    └── skill-discovery.md             ← How to find and install new skills
```

---

## How the 3-Tier System Works

```
┌─────────────────────────────────────────────────────────┐
│  Tier 1: RULES (Always Active)                          │
│  ~/.gemini/GEMINI.md                                     │
│  Applied to EVERY conversation, EVERY project           │
│  42 rules: strict mode, TS, workflow, verify, English   │
├─────────────────────────────────────────────────────────┤
│  Tier 2: SKILLS (Semi-Auto)                             │
│  ~/.agents/skills/*.SKILL.md                             │
│  AI reads when description matches current task         │
│  DDD rules, TS mastery, code review, git workflow       │
├─────────────────────────────────────────────────────────┤
│  Tier 3: WORKFLOWS (Manual)                             │
│  <project>/.agent/workflows/*.md                         │
│  Triggered by /command in chat                          │
│  /plan, /review, /debug, /verify                        │
└─────────────────────────────────────────────────────────┘
```

**Key insight**: Put rules you want **always enforced** in Tier 1. Put **detailed reference material** in Tier 2 (skills). Put **step-by-step processes** in Tier 3 (workflows).

---

## Skills Reference

### ddd-core-rules

- **When AI reads it**: Working on DDD-structured modules
- **Content**: Aggregate rules, layer dependencies, tactical patterns, anti-patterns
- **Sources**: Eric Evans, Martin Fowler, nestjslatam/ddd

### typescript-mastery

- **When AI reads it**: Writing or reviewing TypeScript code
- **Content**: Type design, discriminated unions, branded types, type guards, generics, RO-RO, pitfalls
- **Naming conventions table** included

### code-review

- **When AI reads it**: Reviewing code (own or others')
- **Content**: 8-section checklist (type safety, architecture, performance, error handling, security, testing, docs)
- **Severity levels**: 🔴 Critical, 🟡 Warning, 🟢 Suggestion

### git-workflow

- **When AI reads it**: Making commits, creating branches, preparing PRs
- **Content**: Conventional Commits format, branch naming, PR template, release flow diagram

---

## Workflows Reference

| Command | Purpose | When to use |
|---------|---------|-------------|
| `/plan` | Create plan + checklist | Starting a feature |
| `/checkpoint` | Save task state | Before session switch |
| `/status` | Report progress | Context feeling stale |
| `/resume` | Restore context | New conversation |
| `/handoff` | Session summary | Ending a session |
| `/debug` | Systematic debugging | Stuck on a bug |
| `/verify` | Evidence-based check | Before finishing |
| `/docs` | Capture logic | Smarter aggregation |

---

## Cross-IDE Support

| IDE                | Config file                    | How AI reads it                      | Template location         |
| ------------------ | ------------------------------ | ------------------------------------ | ------------------------- |
| **Antigravity**    | `GEMINI.md` + `.agent/skills/` | Auto (rules always, skills by match) | Setup script handles this |
| **Cursor**         | `.cursorrules` in project root | Auto reads on project open           | `cross-ide/.cursorrules`  |
| **Claude Code**    | `CLAUDE.md` in project root    | Auto reads on project open           | `cross-ide/CLAUDE.md`     |
| **GitHub Copilot** | `AGENTS.md` in project root    | Auto reads for agent mode            | `cross-ide/AGENTS.md`     |

> **Important**: After copying cross-IDE templates, edit them to add project-specific details (architecture, database, key patterns). The templates contain generic TypeScript rules only.

---

## Skill Discovery

### Finding Skills
```bash
npx skills find <query>       # Search by keyword
npx skills add <owner/repo>   # Install from GitHub
```

### Curated Catalogs
| Catalog | URL |
|---------|-----|
| **skills.sh** | [skills.sh](https://skills.sh) |
| **Antigravity Awesome** | [GitHub](https://github.com/sickn33/antigravity-awesome-skills) |
| **Awesome Agent Skills** | [GitHub](https://github.com/VoltAgent/awesome-agent-skills) |
| **Awesome Cursorrules** | [GitHub](https://github.com/PatrickJS/awesome-cursorrules/tree/main/rules) |

### Strategy: Keep Few, Keep Curated
> Installing 100+ generic skills dilutes AI attention. Better: 5–10 curated skills with project-specific context.

---

## Updating

When you update this toolkit repo:

```bash
# 1. Update the toolkit
cd ~/Documents/ai-dev-toolkit
git pull   # or edit files directly

# 2. Re-run setup in each project (runs all steps)
cd ~/Documents/Zigvy/hr-forte/hr-leave-module
~/Documents/ai-dev-toolkit/scripts/setup-antigravity.sh
```

### Selective Updates

Instead of running everything, use flags to run only what you need:

```bash
# Only update workflows (most common after editing .md files)
setup-antigravity.sh --workflows --force

# Only refresh global rules
setup-antigravity.sh --rules

# Only reinstall skills
setup-antigravity.sh --skills

# Combine flags
setup-antigravity.sh --rules --workflows --force
```

### Flag Reference

| Flag          | What it does                         |
| ------------- | ------------------------------------ |
| _(no flags)_  | Runs ALL steps (default)             |
| `--rules`     | Only Step 1: update global rules     |
| `--skills`    | Only Steps 2+2.5: install all skills |
| `--workflows` | Only Step 3: copy workflows          |
| `--force`     | Overwrite existing files (any step)  |

### Overwrite Behavior

| Component | Default behavior   | With `--force`     |
| --------- | ------------------ | ------------------ |
| Rules     | Always overwritten | Always overwritten |
| Skills    | Always updated     | Always updated     |
| Workflows | **Skip existing**  | **Overwrite all**  |

> Use `--force` when you want to reset project workflows to the latest toolkit versions.

---

## Adding to a New Project

```bash
cd <your-project>
~/Documents/ai-dev-toolkit/scripts/setup.sh
```

That's it. The script creates `.agent/workflows/` or `.claude/commands/` and installs global skills + rules.

---

## Team Onboarding

For a new team member:

1. **Clone the project** → workflows in `.agent/workflows/` are included
2. **Run setup script** → installs global rules + skills
3. **Verify** → open Antigravity → Customizations → check Rules + Workflows tabs
4. **Done** — AI now understands project context and follows all conventions

> **Note**: User rules in `GEMINI.md` are personal (not committed to git). Each team member runs the setup script once on their machine.
