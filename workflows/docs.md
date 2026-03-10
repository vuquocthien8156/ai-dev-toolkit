---
description: Auto-document business logic after feature discussions or complex bug fixes
---

# Auto-Documentation Workflow

Use after feature discussions, business logic decisions, or complex bug fixes.

## Quality Rules (Essence Distillation)

- **DISTILL, never summarize.** Remove decoration/noise; keep decision-grade core only.
- **Format**: `[Context] → [Decision/Rule] → [Condition/Scope]` in 1-2 sentences.
- Each entry must be **self-contained** (readable without conversation history).
- Preserve critical values: numbers, thresholds, file paths, environment scope.
- If content is mostly noise, write **nothing** rather than weak documentation.

## Steps

0. Read `project-context/SKILL.md` to get the base documentation path and module information.

1. Identify which module the knowledge belongs to from the conversation (or ask the user).

2. **Read module context**: If `docs/modules/<module>/CONTEXT.md` exists, read it first to understand existing knowledge and avoid contradictions.

3. **INVALIDATE FIRST** — Before writing new docs, search existing docs for contradictions:
   - Completed phases still listed as "in progress" → UPDATE or REMOVE
   - Decisions that were reversed in later conversations → REMOVE stale entry
   - Rules that conflict with current codebase → UPDATE
   - Priority: **Remove stale → Update changed → Add new**

4. **Decision merge rule** — BEFORE creating a new decision file:
   - Search existing files in `decisions/` for the **SAME TOPIC**
   - If found → **APPEND** a new dated section (`## Update YYYY-MM-DD`) to the existing file
   - Only create a new file when the topic is **completely unrelated** to all existing decisions

5. Draft the document following the Essence Distillation rules above:
   - Title, Date, Context
   - Problem/Background (1-2 sentences max)
   - Decision/Solution (with Mermaid diagrams for flows if applicable)
   - Consequences/Trade-offs
   - Links to source files

6. Determine doc type and place in correct subfolder:
   - Business logic decision → `<docs-path>/<module>/decisions/`
   - Flow/process explanation → `<docs-path>/<module>/flows/`
   - API guide → `<docs-path>/<module>/api/`
   - Cross-cutting guide → `<docs-path>/_guides/`

7. **Update module README** — After saving, append a link to the new/updated doc in `docs/modules/<module>/README.md`:
   - README serves as the **module docs roadmap/index**
   - If README doesn't exist, create a minimal one with module name and the new link

8. **CONTEXT.md check** — If `docs/modules/<module>/CONTEXT.md` does not exist yet:
   - Suggest to user: "This module has no CONTEXT.md (living architecture doc). Want me to create one?"
   - If confirmed, generate a CONTEXT.md with: Core concepts, Key entities, Architecture overview, Reusable abstractions
   - If CONTEXT.md exists and the new knowledge is architecturally significant → suggest updating it

9. Present the draft to user for review before saving.
