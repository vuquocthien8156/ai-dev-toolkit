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

## Process

### 0. Multi-Project Awareness
Read `.agent/skills/project-context/SKILL.md` (or equivalent) to identify the project's documentation base path. Do NOT assume `docs/modules/` is the only location.

### 0.5 Mode Detection
Before proceeding, determine the implementation mode based on the user request:

**A. Knowledge Aggregation Mode** (User provides a folder or mentions a broad domain):
1. Read `CONTEXT.md` in the target module to understand the domain map.
2. Scan ALL existing files in that domain folder (overviews, decisions, flows).
3. Find the BEST existing file to append each knowledge point to:
   - Topic overview/Lifecycle? → `_overview.md` or `domain-lifecycle.md`.
   - Tactical/One-off decision? → Search `decisions/` for overlapping topics → append.
   - Architectural guardrail? → Update `CONTEXT.md`.
4. ONLY create a new file if the topic is genuinely unrelated to all existing files.
5. Propose the placement strategy to the user before writing.

**B. Single Decision Capture** (Standard conversation flow):
→ Proceed with the steps below.

### 1. Identify Module and Domain
Identify which module and domain the decision belongs to. If unsure, ask the user.

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

4b. **File creation gate** — A new file is justified ONLY when ALL of these are true:
   - Topic is unrelated to ALL existing files in `decisions/` AND `flows/`
   - Contains ≥3 distinct decision points (not a single fix note)
   - Knowledge is reusable (not a one-off bug fix absorbed into code)
   - If in doubt, APPEND to existing file rather than creating new

4c. **Consolidation check** — Before creating, also check:
   - Could this be a section in an existing `flows/*.md`?
   - Could this update `CONTEXT.md` directly (if architecturally significant)?
   - Could this append to `decision-log.md` (if it's a small tactical choice)?

4d. **Naming guidelines**:
    - Use a kebab-case filename (e.g., `stripe-metadata-clearing.md`).
    - **CRITICAL**: Before creating, check: Does ANY file in this domain cover an OVERLAPPING topic? If yes, you MUST append to that file instead of creating a new one.
   - Date prefix ONLY for time-sensitive decisions: `2026-03-09-fix-tenant-isolation.md`
   - NO date prefix for permanent architectural docs: `offline-pay-later-architecture.md` ✅
   - Avoid generic names: `fix.md` ❌, `notes.md` ❌

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
