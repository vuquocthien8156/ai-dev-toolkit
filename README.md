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

### Step 1: Clone and make executable

```bash
cd ~/Documents
git clone <your-repo-url> ai-dev-toolkit
chmod +x ai-dev-toolkit/scripts/setup-antigravity.sh
```

### Step 2: Run setup from inside your project

```bash
cd ~/Documents/Zigvy/hr-forte/hr-leave-module
~/Documents/ai-dev-toolkit/scripts/setup-antigravity.sh
```

This one command does:

| Step | What happens                                                                | Auto?        |
| ---- | --------------------------------------------------------------------------- | ------------ |
| 1    | Writes all rules (Sections I–XIV) to `~/.gemini/GEMINI.md`                  | ✅ Automatic |
| 2    | Copies self-written skills to `~/.agents/skills/` + symlinks to Antigravity | ✅ Automatic |
| 2.5  | Installs community skills globally (debugging, testing, security, context)  | ✅ Automatic |
| 3    | Copies workflows to global + project (**skips existing** unless `--force`)  | ✅ Automatic |
| 4    | Health check: bloated skills warning + cross-IDE symlinks                   | ✅ Automatic |

### Step 3: Verify in Antigravity

1. Open Antigravity → **Customizations** → **Rules** tab
   - You should see Sections I–XIV (55 rules including Global Skill Trigger Map)
2. Open Antigravity → **Customizations** → **Workflows** tab
   - You should see: plan, review, debug, verify, docs, test, refactor, spike, pr

### Step 4: (Optional) Cross-IDE config

If you also use Cursor, Claude Code, or Copilot:

```bash
# For Cursor — copy .cursorrules to project root
cp ~/Documents/ai-dev-toolkit/cross-ide/.cursorrules ~/Documents/Zigvy/hr-forte/hr-leave-module/.cursorrules

# For Claude Code — copy CLAUDE.md to project root
cp ~/Documents/ai-dev-toolkit/cross-ide/CLAUDE.md ~/Documents/Zigvy/hr-forte/hr-leave-module/CLAUDE.md

# For GitHub Copilot / Codex — copy AGENTS.md to project root
cp ~/Documents/ai-dev-toolkit/cross-ide/AGENTS.md ~/Documents/Zigvy/hr-forte/hr-leave-module/AGENTS.md
```

> **Note**: Edit these files after copying to add project-specific context (architecture, DB, key patterns).

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
| **Plan workflow**     | Type `/plan` in chat            | Starting a new feature or complex task             |
| **Review workflow**   | Type `/review` in chat          | Before creating a PR                               |
| **Debug workflow**    | Type `/debug` in chat           | Stuck on a bug                                     |
| **Verify workflow**   | Type `/verify` in chat          | Before declaring task complete                     |
| **Test workflow**     | Type `/test` in chat            | Generate or improve tests for modified code        |
| **Refactor workflow** | Type `/refactor` in chat        | Actionable code quality / architecture improvement |
| **Spike workflow**    | Type `/spike` in chat           | Technical investigation before committing          |
| **PR workflow**       | Type `/pr` in chat              | Auto-generate PR description from git changes      |
| **Docs workflow**     | Type `/docs` in chat            | Auto-document business decisions                   |
| **Refresh workflow**  | Type `/refresh-context` in chat | Setup AI context, detect tech stack, generate docs |
| **Setup script**      | Run `setup-antigravity.sh`      | New machine, new project, or after toolkit update  |

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
| Context lost after truncation     | `context-management-context-restore`      |

> **Tip**: If you don't see `📚 Loaded:` in chat, the AI may not be using skills. Ask: "bạn đã dùng skills nào?"

---

## Repository Structure

```
ai-dev-toolkit/
│
├── README.md                          ← This file
│
├── skills/                            ← Self-written global skills (→ ~/.agents/skills/)
│   ├── ddd-core-rules/SKILL.md        ← DDD best practices
│   ├── typescript-mastery/SKILL.md    ← TS patterns, type guards, generics
│   ├── code-review/SKILL.md           ← 8-section review checklist
│   ├── git-workflow/SKILL.md          ← Conventional Commits, PR workflow
│   ├── context-compression/SKILL.md   ← Context window compression strategies
│   └── context-optimization/SKILL.md  ← Token efficiency patterns
│
├── workflows/                         ← Global workflows (→ project + ~/.gemini/antigravity/)
│   ├── plan.md                        ← /plan — structured planning
│   ├── review.md                      ← /review — code review + security
│   ├── debug.md                       ← /debug — systematic debugging
│   ├── verify.md                      ← /verify — verification before done
│   ├── test.md                        ← /test — generate/improve tests
│   ├── refactor.md                    ← /refactor — code quality actions
│   ├── spike.md                       ← /spike — technical investigation
│   ├── pr.md                          ← /pr — auto PR description
│   ├── refresh-context.md             ← /refresh-context — context setup
│   └── docs.md                        ← /docs — auto-documentation
│
├── user-rules/
│   └── memory-rules.md                ← All rules (→ ~/.gemini/GEMINI.md)
│
├── scripts/
│   ├── setup-antigravity.sh           ← One-command setup (rules + skills + workflows)
│   └── setup-agent-template.sh        ← Template for per-project .agent/setup.sh
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

| Command            | Purpose                                   | When to use                         |
| ------------------ | ----------------------------------------- | ----------------------------------- |
| `/plan`            | Create structured plan with checklist     | Starting new feature, 3+ step task  |
| `/review`          | Systematic code review + security checks  | Before PR, after implementation     |
| `/debug`           | Step-by-step debugging                    | Stuck on a bug, unexpected behavior |
| `/verify`          | Evidence-based completion check           | Before declaring task done          |
| `/test`            | Generate/improve tests for modified code  | After implementation, before PR     |
| `/refactor`        | Actionable code quality improvements      | Tech debt, architecture cleanup     |
| `/spike`           | Technical investigation (no prod changes) | Before committing to an approach    |
| `/pr`              | Auto-generate PR description              | Before creating a PR                |
| `/docs`            | Auto-document business decisions          | After feature or complex bug fix    |
| `/refresh-context` | Refresh AI context for the project        | First-time setup, after big changes |

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

### Find and install new skills

```bash
npx skills find <query>       # Search by keyword
npx skills add <owner/repo>   # Install from GitHub
```

### Curated catalogs

| Catalog              | URL                                                                        |
| -------------------- | -------------------------------------------------------------------------- |
| skills.sh            | [skills.sh](https://skills.sh)                                             |
| Antigravity Awesome  | [GitHub](https://github.com/sickn33/antigravity-awesome-skills)            |
| Awesome Agent Skills | [GitHub](https://github.com/VoltAgent/awesome-agent-skills)                |
| Awesome Cursorrules  | [GitHub](https://github.com/PatrickJS/awesome-cursorrules/tree/main/rules) |

See [references/skill-discovery.md](references/skill-discovery.md) for detailed guide with evaluation criteria.

---

## Updating

When you update this toolkit repo:

```bash
# 1. Update the toolkit
cd ~/Documents/ai-dev-toolkit
git pull   # or edit files directly

# 2. Re-run setup in each project
cd ~/Documents/Zigvy/hr-forte/hr-leave-module
~/Documents/ai-dev-toolkit/scripts/setup-antigravity.sh
```

The script behavior:

| Component | Default behavior   | With `--force`     |
| --------- | ------------------ | ------------------ |
| Rules     | Always overwritten | Always overwritten |
| Skills    | Always updated     | Always updated     |
| Workflows | **Skip existing**  | **Overwrite all**  |

> Use `--force` when you want to reset project workflows to the latest toolkit versions.

---

## Adding to a New Project

```bash
# Usage:
#   cd <your-project>
#   ~/Documents/ai-dev-toolkit/scripts/setup-antigravity.sh
#   ~/Documents/ai-dev-toolkit/scripts/setup-antigravity.sh --force  # Reset existing workflows
```

That's it. The script creates `.agent/workflows/` in the project and installs global skills + rules.

For cross-IDE support, also copy the config templates:

```bash
cp ~/Documents/ai-dev-toolkit/cross-ide/.cursorrules .
cp ~/Documents/ai-dev-toolkit/cross-ide/CLAUDE.md .
cp ~/Documents/ai-dev-toolkit/cross-ide/AGENTS.md .
```

---

## Team Onboarding

For a new team member:

1. **Clone the project** → workflows in `.agent/workflows/` are included
2. **Run setup script** → installs global rules + skills
3. **Verify** → open Antigravity → Customizations → check Rules + Workflows tabs
4. **Done** — AI now understands project context and follows all conventions

> **Note**: User rules in `GEMINI.md` are personal (not committed to git). Each team member runs the setup script once on their machine.
