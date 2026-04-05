---
description: Comprehensive project context refresh. Scans project, detects architecture, common code, generates SKILL.md and module docs.
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
| `.agent/setup.sh`                  | **MERGE ONLY**: only add/remove entries in `REQUIRED_SKILLS=(...)` array. NEVER overwrite or regenerate file   |

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

8. Generate / Update `.agent/skills/project-context/SKILL.md` using buffer:
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
   ## Tech Stack
   ## Module Classification
   ## Shared/Common Code (Key utils/services)
   ## Architecture (Pattern, Layer order)
   ## Conventions (Naming, Testing, Git)
   ## Proactive Quality Checks
   ## Key Entry Points
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

9. Generate `.agent/skills/knowledge-router/SKILL.md` using this template:

   ```markdown
   ---
   name: knowledge-router
   description: Rules for classifying and saving knowledge into project docs.
   ---

   # Knowledge Router

   ## Core Principle

   Do not lose valuable context. If we discover a complex bug, architecture decision,
   or project-specific pattern, it MUST be extracted and saved.

   ## Quality Rules (Essence Distillation)

   - DISTILL, never summarize. Remove noise; keep decision-grade core.
   - Format: [Context] → [Decision/Rule] → [Condition/Scope] in 1-2 sentences.
   - Each entry must be SELF-CONTAINED (readable without conversation history).
   - Preserve critical: numbers, thresholds, file paths, environment scope.
   - If content is mostly noise, save nothing rather than weak knowledge.

   ## Invalidation Rules

   Before writing NEW knowledge, ALWAYS check existing docs for contradictions:

   - Completed phases still marked "in progress" → UPDATE or REMOVE
   - Decisions reversed in later conversations → REMOVE stale entry
   - Rules that conflict with current codebase → UPDATE
     Priority: Remove stale → Update changed → Add new.

   ## Where to Save What

   | Type                                    | Location                                 | Format                         |
   | --------------------------------------- | ---------------------------------------- | ------------------------------ |
   | Business rules & architecture decisions | `docs/<module>/decisions/`               | `NNN-short-name.md`            |
   | Module living knowledge & architecture  | `docs/modules/<module>/CONTEXT.md`       | Single file per module         |
   | Coding patterns & conventions           | `.agent/skills/project-context/SKILL.md` | Append to relevant section     |
   | Repeatable agent workflows              | `.agent/workflows/`                      | `command-name.md`              |
   | Lessons learned from corrections        | `docs/<module>/decisions/`               | Append to existing or new file |

   ## Decision Merge Rule

   Before creating a new decision file, search existing `decisions/` for the SAME TOPIC.
   If found → APPEND a dated section (`## Update YYYY-MM-DD`). Only create new files for unrelated topics.

   ## Trigger

   At the end of a successful task, before declaring "DONE", evaluate:
   "Did we establish a new pattern or figure out something complex?"
   If Yes → Draft knowledge to the appropriate location. Ask for confirmation.
   ```

10. **[NEW]** Generate Topic-Skill Mapping table:
    - Scan `.agent/skills/` directory
    - Extract `name` and `description` from all `SKILL.md` files
    - Guess module association based on skill name (e.g. `stripe` → `payment` module)
    - Ask user to review/adjust the auto-generated mapping table before saving to `project-context/SKILL.md`

11. **[NEW]** Generate / Update `.agent/setup.sh` (Interactive Skill Setup):

    > **🚨 ABSOLUTE RULE: NEVER OVERWRITE `.agent/setup.sh`. MERGE ONLY.**
    > The setup.sh file contains project-specific logic (IDE symlinks, Git tracking, scaffolding) that took significant effort to create.
    > You are ONLY allowed to ADD or REMOVE entries in the `REQUIRED_SKILLS=(...)` array.
    > If you cannot find a `REQUIRED_SKILLS` array in the file, DO NOT TOUCH THE FILE. Ask user for guidance.
    > If `npx skills` fails, report the error and STOP. Do NOT generate any fallback script.

    **Sub-steps:**

    a. Parse the detected core tech stack AND major dependencies from `package.json` (e.g. `@sentry/react-native` → sentry, `firebase`, `stripe`, `@reduxjs/toolkit` → redux).
    b. Look up `ai-dev-toolkit/scripts/skill-registry.json` → match `tech_stack_mapping` entries.
    c. Run `npx skills find <keyword>` for BOTH the core tech stack AND each major dependency discovered. If this command fails, report the error and continue with registry-only results.
    d. **PROPOSAL ONLY (STOP & ASK)**: Present the combined list of recommended skills. Ask: "I recommend these skills for your project. Which ones should I include?"
    e. **WAIT FOR EXPLICIT CONFIRMATION** (Rule 2).
    f. Check if `.agent/setup.sh` already exists:
    - **DOES NOT EXIST** → Create `.agent/setup.sh` from the toolkit `scripts/setup.sh` (adapted for project use), inject confirmed skill names into a `REQUIRED_SKILLS` array, and run `chmod +x .agent/setup.sh`.

12. Generate Architect & Utilities Documentation (`/scan-modules` logic):
    - **12a. Core Utilities Map**: Use the deep scan buffer from Step 4 to generate `docs/core-utils.md`. Record all available utility functions, helpers, decorators, and constants.
      - **⚠️ ANTI-BLOAT RULE**: Keep this file EXTREMELY COMPACT. List only the filename, function signature (name + primary args), and a 3-word purpose. Do NOT include raw code bodies or excessive markdown formatting. This file serves as a rapid-lookup dictionary for the AI.
    - **12b. Business Modules**: For each module detected in Step 3, if no docs folder exists → create `docs/modules/<module-name>/` and generate `docs/modules/<module-name>/README.md`:
      - List pattern, structure, key files, and dependencies
    - **12c. Main Index**: Generate `docs/INDEX.md` listing all modules and linking to their auto-generated READMEs and the compact `docs/core-utils.md` map.

13. (Removed — tasks/ scaffolding no longer used)

14. IMPORTANT: Do NOT copy global skills into `.agent/skills/`.
    `.agent/skills/` is for project-specific skills ONLY.
    Global skills live in `~/.agents/skills/` (managed by `npx skills`).

15. Report summary to user:
    - Project type & Build command detected
    - Module classification table
    - Shared code found
    - New docs folders created
    - Topic-Skill mapping generated
    - Interactive Skill Setup completed
    - Files created/updated

## Staleness Check (for other workflows)

Other workflows (`/plan`, `/debug`, `/review`) should add this as Step 0:

```
0. Check project-context SKILL.md staleness:
   - Missing? → Suggest: "Run /refresh-context first"
   - Older than 30 days? → Suggest: "Run /refresh-context to refresh"
   - >50 commits since last update? → Suggest: "Run /refresh-context --update"
```
