---
name: llm-wiki-schema
description: Defines the global structural standard for any LLM Wiki in this project. All wiki pages must adhere to this schema.
---

# LLM Wiki Schema

This document defines the strict standard for maintaining the LLM Wiki. When updating or creating documentation using the `/docs` workflow, you MUST follow these rules exactly.

## 1. Core Architecture

The wiki consists of three layers:
1. **Raw Sources (`docs/raw/`)**: The immutable source of truth. You read from these, but never modify them.
2. **The Wiki (`docs/modules/.../`)**: The LLM-maintained layer consisting of Entity Pages, Concept Pages, and logs.
3. **The Index (`docs/index.md`)**: The root entry point linking everything together.

## 2. YAML Frontmatter (MANDATORY)

EVERY markdown file you create or update in the Wiki MUST contain a YAML frontmatter block at the very top. This is critical for Dataview and automation.

```yaml
---
tags: [domain, entity-name]
date_updated: YYYY-MM-DD
source_counts: N
---
```

## 3. Formatting & Structure Rules

### A. The Index (`docs/index.md`)
The index is a catalog. Keep it concise.
- List links to Entity/Concept pages.
- Provide exactly ONE line of summary per link.
- Categorize by domain/module.

### B. The Log (`docs/log.md`)
The log is an append-only timeline of the wiki's evolution.
- Every entry MUST use this exact prefix format: `## [YYYY-MM-DD] action | Topic`
- Example: `## [2026-05-02] ingest | Refactored subscription logic into entity page`
- This ensures the log is easily parsed by `grep`.

### C. Entity Pages (`docs/domains/*.md`)
- Organize knowledge around business entities (e.g., `subscription.md`, `invoice.md`), NOT features or tickets.
- Do not create monolithic files. If a file exceeds 200 lines, consider breaking it down or distilling the essence.

## 4. Operational Workflows

When performing the `/docs` command, execute these operations mentally:

- **Ingest**: When given new information, read it -> identify the affected Entity Page -> append the distilled knowledge -> update the Index if needed -> append a record to the Log.
- **Query/Synthesize**: When asked to answer a question or create a comparison, file the resulting synthesis BACK into the wiki as a new Concept Page if it holds long-term value.
- **Lint**: When reviewing the wiki, look for:
  - Orphan pages (no inbound links).
  - Contradictions between pages.
  - Stale claims.
  - Missing cross-references (e.g., if Subscription mentions Invoice, there should be a `[Link]` to `invoice.md`).

## 5. The Golden Rule
The Wiki is a persistent, compounding artifact. You are the maintainer. Do the bookkeeping. Cross-reference everything. Distill the noise.
