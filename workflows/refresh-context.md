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
     Build a Module Classification table with: name, pattern, file count, key entry point.

4. **[NEW]** Scan Shared/Common Code:
   - Detect `src/common/`, `src/shared/`, `src/core/`, `libs/`
   - List key utils, decorators, guards, interceptors → add to buffer

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
   ## Tech Stack
   ## Module Classification
   ## Shared/Common Code (Key utils/services)
   ## Architecture (Pattern, Layer order)
   ## Conventions (Naming, Testing, Git)
   ## Proactive Quality Checks
   ## Key Entry Points
   ## Human Notes <!-- PRESERVED -->
   ```

9. Generate `.agent/skills/knowledge-router/SKILL.md`:
   - (Same content as previous init-project, routing rules for decisions, patterns, lessons)

10. **[NEW]** Generate Topic-Skill Mapping table:
    - Scan `.agent/skills/` directory
    - Extract `name` and `description` from all `SKILL.md` files
    - Guess module association based on skill name (e.g. `stripe` → `payment` module)
    - Ask user to review/adjust the auto-generated mapping table before saving to `project-context/SKILL.md`

11. Generate Module Documentation (`/scan-modules` logic):
    - For each module detected in Step 3, generate `docs/<module>/README.md`:
      - List pattern, structure, key files (controllers, services, entities, etc)
      - List dependencies (imports/exports from `*.module.ts`)
    - Generate `docs/INDEX.md` listing all modules and linking to their READMEs.
    - Ask user: "Do you want to generate/update the docs/<module> READMEs now? [Y/n]"

12. Create scaffolding if not exists:
    - `tasks/todo.md` — empty checklist
    - `tasks/lessons.md` — empty lessons file

13. IMPORTANT: Do NOT copy global skills into `.agent/skills/`.
    `.agent/skills/` is for project-specific skills ONLY.
    Global skills live in `~/.agents/skills/` (managed by setup script).

14. Report summary to user:
    - Project type & Build command detected
    - Module classification table
    - Shared code found
    - New docs folders created
    - Topic-Skill mapping generated
    - Files created/updated

## Staleness Check (for other workflows)

Other workflows (`/plan`, `/debug`, `/review`) should add this as Step 0:

```
0. Check project-context SKILL.md staleness:
   - Missing? → Suggest: "Run /refresh-context first"
   - Older than 30 days? → Suggest: "Run /refresh-context to refresh"
   - >50 commits since last update? → Suggest: "Run /refresh-context --update"
```
