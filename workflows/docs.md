---
description: Auto-document business logic after feature discussions or complex bug fixes
---

# Auto-Documentation Workflow

Use after feature discussions, business logic decisions, or complex bug fixes.

## Steps

0. Read `project-context/SKILL.md` to get the base documentation path and module information.
1. If `tasks/session-context.md` exists, detect the current active module from it.
2. If no session context exists, identify which module the knowledge belongs to from the conversation (or ask the user).
3. Check existing docs in the module's doc folder (e.g. `docs/<module>/`) to avoid duplication.
4. Draft the document following the standard structure:
   - Title, Date, Context
   - Problem/Background
   - Decision/Solution (with Mermaid diagrams for flows if applicable)
   - Consequences/Trade-offs
   - Links to source files
5. Determine doc type and place in correct subfolder:
   - Business logic decision → `<docs-path>/<module>/decisions/`
   - Flow/process explanation → `<docs-path>/<module>/flows/`
   - API guide → `<docs-path>/<module>/api/`
   - Cross-cutting guide → `<docs-path>/_guides/`
6. Present the draft to user for review before saving.
