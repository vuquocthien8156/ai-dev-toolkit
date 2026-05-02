---
description: Maintain and update the project's LLM Wiki (knowledge base). Use after complex features or architecture changes.
---

# LLM Wiki Documentation Workflow

Use this workflow to update or restructure the project's documentation using the LLM Wiki pattern.

## Core Principles

- **The Wiki is a persistent, compounding artifact.** Do not create isolated monolithic files.
- **Index First:** Always read `docs/index.md` (or the module's `index.md`) before creating or editing files.
- **Entity Pages:** Organize knowledge around core business entities (e.g., `subscription.md`, `invoice.md`) or specific use cases, rather than generic folders like `decisions/` or `flows/`.
- **Cross-Reference:** Actively interlink pages using standard Markdown links `[Link Text](./target-file.md)`.
- **Append-Only Log:** Always record changes in `log.md`.

## Process

### 0. Load Core Rules
You MUST read `.agents/skills/llm-wiki-schema/SKILL.md` and `.agents/skills/llm-wiki-router/SKILL.md` to understand the strict structural and formatting rules (like mandatory YAML frontmatter).

### 1. Locate the Root Index
Find the main documentation folder (usually `docs/`) and read `docs/index.md`.
If `docs/index.md` does not exist, ask the user if you should initialize the Root Wiki.

### 2. Identify the Target Domain
Determine which module or domain the new knowledge belongs to (e.g., `docs/modules/payment/`).
Read the module's local `index.md` if it exists.

### 3. Entity Page Resolution
Instead of creating a new "decision" file, find the most relevant **Entity Page**:
- E.g., if the user changes how subscriptions renew, look for `subscription.md` or `renewal.md`.
- **UPDATE**: If the entity page exists, append or modify the relevant section.
- **CREATE**: ONLY create a new entity page if the concept is entirely new. If creating a new page, you MUST add a link to it in the local `index.md`.

### 4. Cross-Referencing Check
After modifying an entity page, consider:
- Does this change affect other entities? (e.g., modifying `Subscription` might affect `Invoice`).
- If yes, read those entity pages and add a brief note with a cross-reference link to the primary updated page.

### 5. Write to the Log
Open the relevant `log.md` (either root `docs/log.md` or module `docs/modules/<module>/log.md`) and append a timestamped entry:
`## [YYYY-MM-DD] <Action> | <Topic>`
Example: `## [2026-05-02] Update | Added offline renewal conditions to subscription.md`

### 6. Verification
Review the changes to ensure no previous knowledge was accidentally deleted. You are a maintainer; your job is to distill and append, never to blindly overwrite unless explicitly invalidating stale knowledge.
