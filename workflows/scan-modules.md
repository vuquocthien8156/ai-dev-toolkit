---
description: Scan project modules and generate structured docs. Auto-detects project type and module patterns.
---

// turbo-all

1. Read project-context SKILL.md (if exists) to understand project conventions
2. Detect project type from root markers:
   - `*.module.ts` in src/ → NestJS
   - `app/` or `pages/` → Next.js
   - `src/features/` or `src/screens/` → React Native / Feature-based
   - `packages/` or `apps/` → Monorepo
   - None of above → Generic Node.js
3. Find all module directories based on detected type:
   - NestJS: `src/modules/*` or `src/*` (folders containing `*.module.ts`)
   - Feature-based: `src/features/*` or `src/screens/*`
   - Monorepo: `packages/*` or `apps/*`
   - Generic: top-level `src/*` directories
4. For each module, detect architecture pattern:
   - Has `domain/` + `application/` → DDD
   - Has nested `modules/` → Composite
   - Has `model/` + `view/` + `controller/` → MVC
   - Else → Flat/Legacy
5. For each module, list key files by scanning directory (NO deep reading):
   - Controllers, Services, Entities, Aggregates, Repositories, Use Cases
   - Read only `*.module.ts` (or entry index) for imports/exports
6. Generate `docs/modules/<module-name>/README.md` per module using this template:

   ```
   # <Module Name> Module

   **Pattern**: DDD | Composite | MVC | Flat
   **Generated**: <date> | **Status**: Auto-generated, needs human review

   ## Structure
   - <N> files
   - Key areas: <brief list of subdirectories>

   ## Key Files
   | File | Purpose |
   |------|---------|
   | `xxx.controller.ts` | Routes for ... |
   | `xxx.service.ts` | Business logic for ... |

   ## Dependencies
   - Imports: ModuleA, ModuleB
   - Exports: ServiceX

   ## Docs Convention
   > Only create subfolders when content exists. Do not create empty folders.

   | Subfolder | Purpose |
   |-----------|---------|
   | `decisions/` | Architecture Decision Records (ADRs) |
   | `flows/` | Business flow diagrams and descriptions |
   | `api/` | API documentation and endpoint specs |
   | `test-cases/` | Test scenarios and edge cases |
   ```

7. After all modules scanned, generate `docs/modules/INDEX.md`:

   ```
   # Module Index
   **Project**: <name from package.json>
   **Type**: <detected project type>
   **Scanned**: <date>
   **Total modules**: <N>

   | Module | Pattern | Files | Key Dependencies |
   |--------|---------|-------|------------------|
   | [auth](auth/README.md) | DDD | 12 | user |
   | [user](user/README.md) | Legacy | 5 | — |
   ```

8. Report summary: total modules scanned, patterns found, any anomalies
