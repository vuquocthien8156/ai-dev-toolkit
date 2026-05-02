# AI Dev Toolkit

Personal toolkit for AI-assisted development. Combines curated skills, workflows, and rules for **Antigravity**, **Cursor**, **Claude Code**, **Windsurf**, and **GitHub Copilot**.

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
npx github:vuquocthien8156/ai-dev-toolkit
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

By default, `setup.sh` configures all supported IDEs. To target one:

```bash
setup.sh --ide antigravity
setup.sh --ide claude
setup.sh --ide cursor
setup.sh --ide windsurf
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

| What                 | How to trigger     | When to use                              |
| -------------------- | ------------------ | ---------------------------------------- |
| **Plan workflow**    | `/plan`            | Starting a new feature or complex task   |
| **Checkpoint**       | `/checkpoint`      | Save task state before session switch    |
| **Status**           | `/status`          | Report current progress vs plan          |
| **Resume**           | `/resume`          | Restore context from past sessions       |
| **Handoff**          | `/handoff`         | Prepare summary for next conversation    |
| **Debug workflow**   | `/debug`           | Stuck on a bug                           |
| **Verify workflow**  | `/verify`          | Before declaring task complete           |
| **Docs workflow**    | `/docs`            | Record business/logic decisions          |
| **Refresh workflow** | `/refresh-context` | Auto-detect stack, architecture & skills |
| **Setup script**     | `setup.sh`         | New project or toolkit update            |

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

# Run to update/reinstall:

npx github:vuquocthien8156/ai-dev-toolkit --force

# OR for a clean system reset (if skills feel broken/bloated):

npx github:vuquocthien8156/ai-dev-toolkit --clean

```
ai-dev-toolkit/
│
├├── skills/                            ← Self-written skills (→ ~/.agents/skills/)
│   ├── ddd-core-rules/SKILL.md        ← DDD best practices
│   └── ...                            ← TS mastery, code review, git, etc.
│
├── workflows/                         ← Project & Global commands (→ .agents/workflows/ or ~/.claude/commands/)
│   ├── plan.md, checkpoint.md, status.md, resume.md, handoff.md
│   └── debug.md, verify.md, docs.md, test.md, refactor.md, pr.md
│
├── user-rules/
│   └── memory-rules.md                ← Tier 1 rules (→ GEMINI.md / CLAUDE.md)
│
├── scripts/
│   ├── setup.sh                       ← Multi-IDE installer
│   ├── cleanup.sh                     ← Safe system reset (Global skills/symlinks)
│   └── skill-registry.json            ← Stack-to-skill mapping for /refresh-context
│
└── .gitignore                         ← Configured for clean repo
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
│  <project>/.agents/workflows/*.md                         │
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

| Command       | Purpose                 | When to use           |
| ------------- | ----------------------- | --------------------- |
| `/plan`       | Create plan + checklist | Starting a feature    |
| `/checkpoint` | Save task state         | Before session switch |
| `/status`     | Report progress         | Context feeling stale |
| `/resume`     | Restore context         | New conversation      |
| `/handoff`    | Session summary         | Ending a session      |
| `/debug`      | Systematic debugging    | Stuck on a bug        |
| `/verify`     | Evidence-based check    | Before finishing      |
| `/docs`       | Maintain LLM Wiki       | Update entities, synthesize knowledge, or lint docs |

---

## Cross-IDE Support

| IDE                | Config file                               | How AI reads it                      | Template location         |
| ------------------ | ----------------------------------------- | ------------------------------------ | ------------------------- |
| **Antigravity**    | `GEMINI.md` + `.agents/skills/`           | Auto (rules always, skills by match) | Setup script handles this |
| **Cursor**         | `.cursorrules` in project root            | Auto reads on project open           | `cross-ide/.cursorrules`  |
| **Claude Code**    | `CLAUDE.md` in project root               | Auto reads on project open           | `cross-ide/CLAUDE.md`     |
| **Windsurf**       | `.windsurfrules` + `.windsurf/workflows/` | Auto reads on project open           | Setup script handles this |
| **GitHub Copilot** | `AGENTS.md` in project root               | Auto reads for agent mode            | `cross-ide/AGENTS.md`     |

> **Important**: After copying cross-IDE templates, edit them to add project-specific details (architecture, database, key patterns). The templates contain generic TypeScript rules only.

---

## Skill Discovery

### Finding Skills

```bash
npx skills find <query>       # Search by keyword
npx skills add <owner/repo>   # Install from GitHub
```

### Curated Catalogs

| Catalog                  | URL                                                                        |
| ------------------------ | -------------------------------------------------------------------------- |
| **skills.sh**            | [skills.sh](https://skills.sh)                                             |
| **Antigravity Awesome**  | [GitHub](https://github.com/sickn33/antigravity-awesome-skills)            |
| **Awesome Agent Skills** | [GitHub](https://github.com/VoltAgent/awesome-agent-skills)                |
| **Awesome Cursorrules**  | [GitHub](https://github.com/PatrickJS/awesome-cursorrules/tree/main/rules) |

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
npx github:vuquocthien8156/ai-dev-toolkit
```

### Selective Updates

Instead of running everything, use flags to run only what you need:

```bash
# Only update workflows (most common after editing .md files)
setup.sh --workflows --force

# Only refresh global rules
setup.sh --rules

# Only reinstall skills
setup.sh --skills

# Combine flags
setup.sh --rules --workflows --force
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

1. Run the toolkit setup script:

```bash
cd <your-project>
npx github:vuquocthien8156/ai-dev-toolkit
```

2. Open your IDE and ask your AI to run the `/refresh-context` workflow.
3. The AI will scan your project, propose community skills, download them physically into `.agents/skills/`, and create relative symlinks for all your IDEs (`.claude`, `.cursor`, `.windsurf`, etc.).

That's it. The repository is now **100% Self-Contained**. All workflows, skills, and Pointers are tracked in Git.

---

## Team Onboarding

Because this toolkit uses a **Zero-Config Self-Contained Architecture**, onboarding a new team member to a project is incredibly simple:

1. **Clone the project**
2. **Done!**
   - The AI IDE will automatically follow the relative symlinks (e.g., `.claude/skills -> ../.agents/skills`) and load the project-specific skills and workflows instantly without requiring the developer to run any installation scripts.

_(Optional)_ If the team member wants to install the **Global Tier 1 Rules** (like strict English output, no-assumption behavior) across their entire machine, they can clone this toolkit and run `setup.sh --rules` on their machine once.
