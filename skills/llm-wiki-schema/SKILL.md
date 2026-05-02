---
name: llm-wiki-schema
description: Defines the global structural standard for any LLM Wiki in this project. All wiki pages must adhere to this schema.
---

# LLM Wiki Schema

This document defines the strict standard for maintaining the LLM Wiki. When updating or creating documentation using the `/docs` workflow, you MUST follow these rules exactly.

## 1. Core Architecture

The wiki consists of three layers:
1. **The Wiki (`docs/modules/.../`)**: The LLM-maintained layer consisting of Entity Pages, Concept Pages, Execution Flow Docs, and logs.
2. **The Index (`docs/index.md`)**: The root entry point linking everything together.
3. **The Schema (this file)**: Conventions and structure rules. Co-evolved by user and LLM over time.

## 2. YAML Frontmatter (MANDATORY)

EVERY markdown file you create or update in the Wiki MUST contain a YAML frontmatter block at the very top. This is critical for Dataview and automation.

```yaml
---
tags: [domain, entity-name]
date_updated: YYYY-MM-DD
---
```

Fields:
- `tags`: Domain and topic identifiers for categorization and search.
- `date_updated`: Last modification date. Always update when editing a page.

## 3. Formatting & Structure Rules

### A. The Index (`docs/index.md`)
The index is a catalog. Keep it concise.
- List links to Entity/Concept pages.
- Provide exactly ONE line of summary per link.
- Categorize by domain/module.

### B. The Log (`docs/log.md`)
The log is an append-only timeline of the wiki's evolution.
- Every entry MUST use this exact prefix format: `## [YYYY-MM-DD] action | Topic`
- Example: `## [2026-05-02] synthesize | Added legacy migration saga flow`
- This ensures the log is easily parsed by `grep`.

### C. Entity Pages (`docs/domains/*.md`)
- Organize knowledge around business entities (e.g., `subscription.md`, `invoice.md`), NOT features or tickets.
- Do not create monolithic files. If a file exceeds 200 lines, consider breaking it down or distilling the essence.

### D. Concept Pages (`docs/modules/<module>/use-cases/*.md`)
- Cross-cutting knowledge that spans multiple entities: system flow comparisons, architectural decisions, migration strategies.
- Use when the knowledge doesn't naturally belong to a single Entity Page.
- Prefer comparison tables and mermaid diagrams over long prose.

### E. Execution Flow Docs (`docs/modules/<module>/domains/<domain>/flows/*.flow.md`)
- Sequence diagrams and call chains that map how code executes for a specific feature.
- Purpose: Allow agents to debug and navigate code WITHOUT reading source files.
- Naming convention: `<feature>.flow.md` (e.g., `checkout-preview.flow.md`).
- Each domain's `index.md` SHOULD have a `## Execution Flows` section linking to these.
- Template:
  ```markdown
  ---
  tags: [domain-name, flow]
  date_updated: YYYY-MM-DD
  ---
  # <Feature> — Code Flow
  > **Entry point**: `ClassName.methodName()`
  > **Read when**: <1-line trigger condition>
  ## Sequence Diagram
  ```mermaid
  sequenceDiagram
    participant A as Client
    participant B as Service
    A->>B: Request
    B-->>A: Response
  ```
  ## Call Chain
  1. `file.ts` → `method()`
  ## Key Decision Points
  (branching logic, edge cases)
  ```

### F. Visuals & Diagrams (Anti-Bloat Rule & Mermaid Best Practices)
To prevent Git repo bloat and ensure clear communication:
1. **Always use `mermaid` code blocks** for architecture diagrams, flowcharts, ERDs, and sequence diagrams.
   - *Mermaid Rule*: Keep it simple. Avoid giant, unreadable spaghetti graphs. Break complex flows into smaller, focused sub-diagrams. Use semantic node labels.
2. **Never commit heavy binary images** (PNG/JPG) to the docs folder.
3. For UI screenshots or videos, upload to external hosts (Jira, GitHub Issues, S3) and link them.
4. Exception: lightweight SVG files are acceptable if Mermaid cannot express the diagram.

## 4. Operational Workflows

The `/docs` workflow supports three operation modes. See `docs.md` for the full process.

- **Update**: Append distilled knowledge to Entity Pages after code changes.
- **Synthesize**: File valuable answers/analyses back into the wiki as Concept Pages.
- **Lint**: Health-check the wiki for:
  - Orphan pages (no inbound links).
  - Contradictions between pages.
  - Stale claims.
  - Missing cross-references (e.g., if Subscription mentions Invoice, there should be a `[Link]` to `invoice.md`).
  - Entity pages exceeding 200 lines.

## 5. Co-Evolution
This schema is not static. When new patterns emerge (e.g., a new page type, a new naming convention), propose updates to this file. The schema grows with the project.

## 6. The Golden Rule
The Wiki is a persistent, compounding artifact. You are the maintainer. Do the bookkeeping. Cross-reference everything. Distill the noise.
