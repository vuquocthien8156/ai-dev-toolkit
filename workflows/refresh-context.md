---
description: Comprehensive project context refresh. Scans project, detects architecture, generates SKILL.md. Also restructures oversized context files (formerly /refactor-context).
---

// turbo-all

## Core Principle: Never Override Knowledge

All existing knowledge has value. Scan results only SUPPLEMENT, never replace.
If scan finds a conflict (e.g. version mismatch), show BOTH values and ask user.

## Merge Rules

| Section Marker                     | Behavior                                                                                                       |
| ---------------------------------- | -------------------------------------------------------------------------------------------------------------- |
| `<!-- AUTO-GENERATED -->`          | Merge: add new items, update versions. NEVER delete existing items unless module is truly removed from project |
| `<!-- PRESERVED -->` / Human Notes | Never touch. Skip entirely                                                                                     |
| Sections without marker            | Show diff, ask user — could be human-added knowledge                                                           |
| New sections from scan             | Append at end of file, mark `<!-- AUTO-GENERATED -->`                                                          |
| `.agents/setup.sh`                  | **MERGE ONLY**: only add/remove entries in `REQUIRED_SKILLS=(...)` array. NEVER overwrite or regenerate file   |

## Steps

0. Read existing `project-context/SKILL.md` (if exists) into buffer to understand current state.

1. **Invoke the `project-scanner` skill**:
   - Read `.agents/skills/project-scanner/SKILL.md` to learn how to scan the project.
   - Scan the project root to detect the tech stack, build commands, and CI/CD.
   - Scan `src/modules/` to classify modules (DDD, MVC, etc.).
   - Perform a deep scan of shared utilities (`src/common/`, `utils/`, etc.).
   - Identify proactive quality check patterns.
   - Hold all extracted knowledge in a memory buffer.

2. **Detect Docs Path & Create Folders**:
   - Locate main documentation folder (usually `docs/`)
   - For every module detected, if no docs folder exists → create `docs/modules/<module-name>/`

3. Generate / Update `.agents/skills/project-context/SKILL.md` using buffer:
   - **Show DIFF to user before writing** (compare buffer vs existing)
   - Ask user: "Apply these changes? [Y / n / selective]"
   - Only write after explicit confirmation

   **SKILL.md Template Elements:**

   ```
   # Project Context
   ## Overview (Type, Framework, Language, Docs Path, Verification Command)
   ## Auto-Generated Documentation
   - Core Utilities Map: `docs/core-utils.md` -> ALWAYS review this before writing new utility functions or helpers to reuse existing logic.
   - Modules Index: `docs/INDEX.md` -> Check this for architecture of specific modules.
   - Module Context Router: If the user mentions a specific module (e.g., `payment`, `auth`), ALWAYS read `docs/modules/<module-name>/README.md` and check `docs/modules/<module-name>/domains/` before coding.
   ## Tech Stack
   ## Module Classification
   ## Shared/Common Code (Key utils/services)
   ## Architecture (Pattern, Layer order)
   ## Conventions (Naming, Testing, Git)
   ## Proactive Quality Checks
   ## Key Entry Points
   ## Team Rules & Bug Evolution <!-- PRESERVED -->
   - **Bug Evolution**: When fixing a global, critical, or repeatable project bug, DO NOT just fix the code. Ask the user if we should update this SKILL.md file or create a new skill to ensure other team members don't repeat the same mistake.
   - **Wiki Reminder**: After completing complex tasks or architectural decisions, remind the user to run `/docs` to update the LLM Wiki.
   ## Workflow Hints <!-- PRESERVED -->
   <!-- Project-specific guidance for global workflows. Agent reads these automatically. -->
   | Workflow | Hints |
   |----------|-------|
   | test     | |
   | verify   | |
   | review   | |
   | refactor | |
   ## Human Notes <!-- PRESERVED -->
   ```

   **Context Splitting Rules (MANDATORY):**

   - Project context hub SKILL.md MUST stay ≤150 lines (routing table + overview only)
   - When generated content exceeds 200 lines → split into `references/` partitions
   - Hub contains: Overview, Tech Stack, Module Classification, routing table to partitions
   - Each partition should be 50-150 lines, focused on one topic

   **Partition Template (for project SKILL.md):**

   ```
   project-context/
   ├── SKILL.md                    ← Hub: overview + routing (≤150 lines)
   └── references/
       ├── architecture.md         ← Module patterns (DDD/Legacy/Composite rules)
       ├── conventions.md          ← Naming, testing, git conventions
       ├── infrastructure.md       ← CI/CD, deployment, Docker config
       └── quality-checks.md       ← Proactive checks, verification commands
   ```

   Hub routing table example:
   ```markdown
   ## Context Partitions
   | Topic | File | When to Load |
   |-------|------|-------------|
   | Module patterns, DDD rules | `references/architecture.md` | Working on DDD/Composite modules |
   | Naming, testing conventions | `references/conventions.md` | Code review, new code |
   | CI/CD, Docker, deployment | `references/infrastructure.md` | Deploy, Docker changes |
   | Quality checks, verify cmds | `references/quality-checks.md` | Before declaring done |
   ```

   **Module CONTEXT.md Splitting (flexible, domain-specific):**

   - Same ≤200 line threshold applies per module CONTEXT.md
   - Partitions go into `docs/modules/<module>/context/` (not `references/`)
   - Categories are domain-driven (NOT a fixed template) — agent proposes, user decides
   - Hub keeps: Core concepts, ERD, key abstractions, routing table to partitions

4. **Create Cross-IDE Pointers:**
   To ensure all IDEs know to read `.agents/skills/project-context/SKILL.md`, automatically execute these terminal commands to create pointers:
   - **Cursor:** Create `.cursor/rules/00-project-context.mdc` (create `.cursor/rules` if needed) instructing Cursor to read `.agents/skills/project-context/SKILL.md` for architecture and conventions.
   - **Claude Code:** Ensure `CLAUDE.md` exists at project root and append a line instructing it to read `.agents/skills/project-context/SKILL.md` (only if the instruction isn't already there).
   - **Windsurf:** Ensure `.windsurfrules` exists at project root and append a line instructing it to read `.agents/skills/project-context/SKILL.md` (only if the instruction isn't already there).

5. **Delegate to `/setup-skills` Workflow**:
   - Propose to the user to run the `/setup-skills` workflow to interactively detect and install community skills for their specific tech stack.

6. Generate Topic-Skill Mapping table:
    - Scan `.agents/skills/` directory
    - Extract `name` and `description` from all `SKILL.md` files
    - Guess module association based on skill name (e.g. `stripe` → `payment` module)
    - Ask user to review/adjust the auto-generated mapping table before saving to `project-context/SKILL.md`

7. Generate Architect & Utilities Documentation (`/scan-modules` logic):
    - **7a. Core Utilities Map**: Use the deep scan buffer to generate `docs/core-utils.md`. Record all available utility functions, helpers, decorators, and constants.
      - **⚠️ ANTI-BLOAT RULE**: Keep this file EXTREMELY COMPACT. List only the filename, function signature, and a 3-word purpose.
    - **7b. Business Modules**: For each module detected, if no docs folder exists → create `docs/modules/<module-name>/` and generate `docs/modules/<module-name>/README.md`:
      - List pattern, structure, key files, and dependencies
    - **7c. Main Index**: Generate `docs/INDEX.md` listing all modules and linking to their auto-generated READMEs and the compact `docs/core-utils.md` map.

8. IMPORTANT: Self-Contained Architecture.
    Domain and project-specific skills MUST be physically stored inside `.agents/skills/` — self-contained and committed to Git.
    Universal skills installed via `--machine` (e.g., `systematic-debugging`, `clean-code`) live in `~/.agents/skills/` and are accessed via IDE symlinks — this is by design and does NOT violate self-containment.
    Rule: if a skill is domain-specific (NestJS, React, Expo) or project-specific (project-context, custom skills), it MUST be in `.agents/skills/`. If it is a universal debugging/meta skill, `~/.agents/skills/` is acceptable.

9. Report summary to user:
    - Project type & Build command detected
    - Module classification table
    - Shared code found
    - New docs folders created
    - Topic-Skill mapping generated
    - Remind user they can run `/refactor-context` if `SKILL.md` is too large.



## Staleness Check (for other workflows)

Other workflows (`/plan`, `/debug`, `/review`) should add this as Step 0:

```
0. Check project-context SKILL.md staleness:
   - Missing? → Suggest: "Run /refresh-context first"
   - Older than 30 days? → Suggest: "Run /refresh-context to refresh"
   - >50 commits since last update? → Suggest: "Run /refresh-context --update"
```
