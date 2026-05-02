---
description: Maintain and update the project's LLM Wiki (knowledge base). Use after complex features, architecture changes, or for periodic wiki maintenance.
---

# LLM Wiki Documentation Workflow

Use this workflow to update or restructure the project's documentation using the LLM Wiki pattern.

## Core Principles

- **The Wiki is a persistent, compounding artifact.** Do not create isolated monolithic files.
- **The LLM does the bookkeeping.** Cross-referencing, updating indexes, flagging contradictions — this is your job, not the human's.
- **Index First:** Always read `docs/index.md` (or the module's `index.md`) before creating or editing files.
- **Entity Pages:** Organize knowledge around core business entities (e.g., `subscription.md`, `invoice.md`), not features or tickets.
- **Cross-Reference:** Actively interlink pages using standard Markdown links `[Link Text](./target-file.md)`.
- **Append-Only Log:** Always record changes in `log.md`.
- **Visuals:** Use `mermaid` code blocks for diagrams. Never commit heavy binary images to Git.

## Process

### 0. Load Core Rules
You MUST read `.agents/skills/llm-wiki-schema/SKILL.md` and `.agents/skills/llm-wiki-router/SKILL.md` to understand the strict structural and formatting rules (like mandatory YAML frontmatter).

### 1. Locate the Root Index
Find the main documentation folder (usually `docs/`) and read `docs/index.md`.
If `docs/index.md` does not exist, ask the user if you should initialize the Root Wiki.

### 2. Choose Operation Mode
Ask the user (or infer from context) which mode to run:

#### Mode A: Update (Default)
Record knowledge from the current conversation into the wiki.

1. **Identify Target Domain** — Determine which module the knowledge belongs to (e.g., `docs/modules/payment/`). Read the module's local `index.md`. **If the domain/folder does not exist, initialize it using the boilerplate from `.agents/templates/domain-boilerplate/`.**
2. **Entity Page Resolution** — Find the most relevant Entity Page. If it exists, APPEND. Only CREATE a new page if the concept is entirely new.
3. **Cross-Reference Check** — Does this change affect other entities? If yes, update those pages with a brief note and link.
4. **Frontmatter Check** — Ensure every touched file has valid YAML frontmatter (`tags`, `date_updated`).
5. **Log Entry** — Append to `log.md`: `## [YYYY-MM-DD] update | <Topic>`

#### Mode B: Synthesize (Query → File Back)
File a valuable answer or analysis back into the wiki as a Concept Page.

Use this when: the LLM just explained a complex system flow, compared architectural approaches, or answered a cross-cutting question that shouldn't be lost in chat history.

1. **Evaluate** — "Does this answer hold long-term value for the team?" If no, skip.
2. **Choose Page Type** — Entity Page (domain-specific) or Concept Page (cross-cutting, goes in `use-cases/`).
3. **Write** — Create or append the distilled synthesis. Use comparison tables or mermaid diagrams where they explain better than prose.
4. **Cross-Reference & Index** — Link from related Entity Pages. Add to module `index.md`.
5. **Log Entry** — `## [YYYY-MM-DD] synthesize | <Topic>`

#### Mode C: Lint (Wiki Health-check)
Periodic maintenance pass over the wiki.

1. **Scan** — Read the module's `index.md` and all linked pages.
2. **Check for**:
   - Orphan pages (no inbound links from any other page)
   - Contradictions between pages
   - Stale claims superseded by recent code changes
   - Important concepts mentioned but lacking their own page
   - Missing cross-references (e.g., page mentions "Invoice" but no link to `invoice.md`)
   - Entity pages exceeding 200 lines (candidates for splitting)
3. **Report** — Present findings to user with proposed fixes.
4. **Fix** — After user approval, apply fixes.
5. **Log Entry** — `## [YYYY-MM-DD] lint | <Module> — N issues found, M fixed`

### 3. Schema Evolution Check
After significant wiki changes, evaluate:
"Do we need new conventions, new page types, or structural changes to the schema?"
If yes → Propose updating `.agents/skills/llm-wiki-schema/SKILL.md` and get user approval before editing.

### 4. Verification
Review the changes to ensure no previous knowledge was accidentally deleted. You are a maintainer; your job is to distill and append, never to blindly overwrite unless explicitly invalidating stale knowledge.
