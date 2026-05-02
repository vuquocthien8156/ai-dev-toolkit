---
name: project-scanner
description: Rules and heuristics for deep-scanning a codebase to detect its architecture, module patterns, tech stack, and core utilities.
---

# Project Scanner Heuristics

This skill provides the rules for analyzing a codebase. It is primarily used by workflows like `/refresh-context`.

## 1. Project Type Detection
Scan the root to classify the overall framework:
- `*.module.ts` in `src/` → NestJS
- `app/` or `pages/` with `next.config.js` → Next.js
- `src/features/` or `src/screens/` → React Native / Feature-based
- `packages/` or `apps/` with `pnpm-workspace.yaml` → Monorepo
- `manage.py` → Django
- `go.mod` → Go
- None of above → Generic

## 2. Module Pattern Classification
For backend/monolith projects, classify each directory inside `src/modules/` or `src/`:
- Has `domain/` + `application/` + `infrastructure/` → **DDD (Domain-Driven Design)**
- Has nested sub-modules inside it → **Composite Module**
- Has `model/` + `view/` + `controller/` → **MVC**
- Everything else (e.g., flat `.controller.ts` and `.service.ts` files) → **Legacy/Flat**

## 3. Deep Scanning Core Utilities
When asked to index shared utilities:
- Look in `src/common/`, `src/shared/`, `src/core/`, `libs/`, `utils/`, `helpers/`, `constants/`.
- **CRITICAL**: Do NOT just list filenames. You MUST use regex/search tools to extract the actual exported function/class names and signatures (e.g., `export function formatDate(date: Date)`).
- This deep scan ensures the AI knows *exactly* which utils exist so it can reuse them.

## 4. Documentation Strategy (`docs/core-utils.md`)
When generating the utilities map, follow the **ANTI-BLOAT RULE**:
Keep the file EXTREMELY COMPACT. List only the filename, function signature, and a 3-word purpose. Do NOT include raw code bodies.
Example:
`- utils/date.ts: formatDate(date: string) -> Standardizes date format`

## 5. Quality & Verification Checks
- Read `package.json` to find the primary linting and type-checking scripts (e.g., `npx tsc --noEmit`).
- Detect ORM patterns (TypeORM, Prisma) and flag common risks (e.g., N+1 query risks).
