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

1. Scan ENTIRE project root (not just src/):
   - `package.json` / `pyproject.toml` / `go.mod` → tech stack + versions
   - `tsconfig.json` / `.eslintrc` / `.prettierrc` → code conventions
   - `docker-compose.yml` / `Dockerfile` / `k8s/` → infrastructure
   - `.github/workflows/` / `.gitlab-ci.yml` → CI/CD pipeline
   - `docs/` → existing documentation path

2. Detect project type:
   - `*.module.ts` in src/ → NestJS
   - `app/` or `pages/` → Next.js
   - `src/features/` or `src/screens/` → React Native / Feature-based
   - `packages/` or `apps/` → Monorepo
   - `manage.py` → Django
   - `go.mod` → Go
   - None of above → Generic

3. Scan modules and classify each:
   - Has `domain/` + `application/` → **DDD**
   - Has nested `modules/` inside → **Composite**
   - Has `model/` + `view/` + `controller/` → **MVC**
   - Everything else → **Legacy/Flat**
     Build a Module Classification table with: name, pattern, file count, key entry point, **context file** (check if `docs/modules/<module>/CONTEXT.md` exists).

4. **[NEW]** Deep Scan Shared/Common Code:
   - Detect directories like `src/common/`, `src/shared/`, `src/core/`, `libs/`, `utils/`, `helpers/`, `constants/`.
   - **CRITICAL**: Do NOT just list filenames. You MUST use tools like `grep_search` with regex (e.g., `export (const|function|class|interface)`) to extract the actual names, signatures, and purposes of exported items.
   - Go deep into the files to understand what utils are actually available (e.g. `formatDate(date: string)`, `RolesGuard`).
   - Add this deep index of common utilities to the context buffer so the AI knows exactly which utils to reuse before writing duplicate code.

5. **[NEW]** Detect Docs Path & Create Folders:
   - Locate main documentation folder (usually `docs/`)
   - For every module detected in Step 3, if no docs folder exists → create `docs/<module>/`
   - Add Docs Path field to buffer

6. **[NEW]** Detect Build/Lint Command:
   - Read `package.json` scripts → find `lint` or `build` or `typecheck`
   - Read `tsconfig.json` → if present, `npx tsc --noEmit` is standard
   - Add "Verification Command" to buffer

7. Detect proactive quality check patterns specific to this project:
   - ORM usage → flag N+1 query risks
   - Entity naming vs DB table naming → flag potential mismatches
   - Circular dependency risks between modules

8. Generate / Update `.agents/skills/project-context/SKILL.md` using buffer:
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

9. **Create Cross-IDE Pointers:**
   To ensure all IDEs know to read `.agents/skills/project-context/SKILL.md`, automatically execute these terminal commands to create pointers:
   - **Cursor:** Create `.cursor/rules/00-project-context.mdc` (create `.cursor/rules` if needed) instructing Cursor to read `.agents/skills/project-context/SKILL.md` for architecture and conventions.
   - **Claude Code:** Ensure `CLAUDE.md` exists at project root and append a line instructing it to read `.agents/skills/project-context/SKILL.md` (only if the instruction isn't already there).
   - **Windsurf:** Ensure `.windsurfrules` exists at project root and append a line instructing it to read `.agents/skills/project-context/SKILL.md` (only if the instruction isn't already there).

10. Generate `.agents/skills/llm-wiki-router/SKILL.md` using this template:

   ```markdown
   ---
   name: llm-wiki-router
   description: Rules for maintaining the project's LLM Wiki. Use this to route knowledge properly.
   ---

   # LLM Wiki Router

   ## Core Principle

   Do not lose valuable context. Extract architectural decisions, bug fix patterns, and domain knowledge into the project's LLM Wiki using the `/docs` workflow.

   ## Quality Rules (Essence Distillation)

   - DISTILL, never summarize. Remove noise; keep decision-grade core.
   - Format: [Context] → [Decision/Rule] → [Condition/Scope] in 1-2 sentences.
   - Each entry must be SELF-CONTAINED (readable without conversation history).
   - Preserve critical: numbers, thresholds, file paths, environment scope.

   ## Where to Save What (Wiki Pattern)

   | Type                                    | Location                                 | Format                         |
   | --------------------------------------- | ---------------------------------------- | ------------------------------ |
   | Business rules & domain logic           | `docs/modules/<module>/domains/`         | Entity Pages (`subscription.md`) |
   | Cross-cutting use cases                 | `docs/modules/<module>/use-cases/`       | Concept Pages (`tenant.md`)      |
   | Coding patterns & conventions           | `.agents/skills/project-context/SKILL.md` | Append to relevant section     |
   | Repeatable agent workflows              | `.agents/workflows/`                      | `command-name.md`              |
   | Wiki Index                              | `docs/index.md`                          | Markdown list of links         |
   | Change Log                              | `docs/log.md`                            | Append-only timestamped list   |

   ## Entity Merge Rule

   Before creating a new file, ALWAYS read `docs/index.md`. 
   If an Entity Page exists for the topic (e.g., `invoice.md`), APPEND the new knowledge as a section. Only create new files for entirely new concepts. Do NOT create monolithic files.

   ## Trigger

   At the end of a successful task, before declaring "DONE", evaluate:
   "Did we establish a new pattern or figure out something complex?"
   If Yes → Propose running the `/docs` workflow to update the LLM Wiki.
   ```

10. **[NEW]** Generate Topic-Skill Mapping table:
    - Scan `.agents/skills/` directory
    - Extract `name` and `description` from all `SKILL.md` files
    - Guess module association based on skill name (e.g. `stripe` → `payment` module)
    - Ask user to review/adjust the auto-generated mapping table before saving to `project-context/SKILL.md`

11. **[NEW]** Interactive Skill Setup (Directly in Workflow):

    > **🚨 ABSOLUTE RULE: DO NOT GENERATE a setup.sh script for the project.**
    > Since all skills are meant to be committed to Git to provide a zero-config experience for the team, this workflow handles skill installation and isolation directly.

    **Sub-steps:**

    a. Parse the detected core tech stack AND major dependencies from `package.json` (e.g. `@sentry/react-native` → sentry, `firebase`, `stripe`, `@reduxjs/toolkit` → redux).
    b. Look up `ai-dev-toolkit/scripts/skill-registry.json` → match `tech_stack_mapping` entries.
    c. Run `npx skills find <keyword>` for BOTH the core tech stack AND each major dependency discovered. If this command fails, report the error and continue with registry-only results.
    d. **PROPOSAL ONLY (STOP & ASK)**: Present the combined list of recommended skills. Ask: "I recommend these skills for your project. Which ones should I install locally?"
    e. **WAIT FOR EXPLICIT CONFIRMATION** (Rule 2).
    f. For each confirmed skill, execute `npx -y skills add <skill>` via tool call in the project root. (Skills are downloaded cleanly to `.agents/skills/`).
    g. Create Relative IDE Symlinks: Run `ln -sfn ../.agents/skills .cursor/skills`, `ln -sfn ../.agents/skills .claude/skills`, `ln -sfn ../.agents/skills .windsurf/skills`, and `ln -sfn ../.agents/skills .continue/skills` so all IDEs automatically detect the local skills.
    h. Ensure `.agents`, `.claude`, `.cursor`, `.windsurf`, and `.continue` are REMOVED from `.gitignore` so they are fully committed to Git.

12. Generate Architect & Utilities Documentation (`/scan-modules` logic):
    - **12a. Core Utilities Map**: Use the deep scan buffer from Step 4 to generate `docs/core-utils.md`. Record all available utility functions, helpers, decorators, and constants.
      - **⚠️ ANTI-BLOAT RULE**: Keep this file EXTREMELY COMPACT. List only the filename, function signature (name + primary args), and a 3-word purpose. Do NOT include raw code bodies or excessive markdown formatting. This file serves as a rapid-lookup dictionary for the AI.
    - **12b. Business Modules**: For each module detected in Step 3, if no docs folder exists → create `docs/modules/<module-name>/` and generate `docs/modules/<module-name>/README.md`:
      - List pattern, structure, key files, and dependencies
    - **12c. Main Index**: Generate `docs/INDEX.md` listing all modules and linking to their auto-generated READMEs and the compact `docs/core-utils.md` map.

13. (Removed — tasks/ scaffolding no longer used)

14. IMPORTANT: Self-Contained Architecture.
    The project is designed to be 100% self-contained. ALL skills (including community skills) MUST be physically stored inside `.agents/skills/`. No external symlinks to `~/.agents/` are allowed. The entire `.agents/`, `.claude/`, and `.cursor/` folders must be committed to Git to ensure zero-config sharing.

15. Report summary to user:
    - Project type & Build command detected
    - Module classification table
    - Shared code found
    - New docs folders created
    - Topic-Skill mapping generated
    - Interactive Skill Setup completed
    - Files created/updated

## Context Restructuring (formerly /refactor-context)

Use when SKILL.md or CONTEXT.md exceeds 200 lines after generation.

1. **Measure**: Count total lines. If ≤200 → no action needed.
2. **Analyze sections**: List all `##` sections with line counts in a table.
3. **Propose partition plan**: Group sections by topic, show which sections go to which partition file with estimated line counts. Ask user to approve.
4. **Execute split** (after confirmation):
   - Create partition files with extracted content
   - Rewrite hub to ≤150 lines (overview + routing table pointing to partitions)
5. **Verify no knowledge lost**: Compare total content — hub + partitions ≥ original. Report: "All N sections preserved across M files."
6. **Update references**: Fix any cross-references to the original file.

## Staleness Check (for other workflows)

Other workflows (`/plan`, `/debug`, `/review`) should add this as Step 0:

```
0. Check project-context SKILL.md staleness:
   - Missing? → Suggest: "Run /refresh-context first"
   - Older than 30 days? → Suggest: "Run /refresh-context to refresh"
   - >50 commits since last update? → Suggest: "Run /refresh-context --update"
```
