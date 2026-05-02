---
name: llm-wiki-schema
description: Defines the global structural standard for any LLM Wiki in this project. All wiki pages must adhere to this schema.
---

# LLM Wiki Schema

This document defines the strict standard for maintaining the LLM Wiki. When updating or creating documentation using the `/docs` workflow, you MUST follow these rules exactly.

## 1. Core Architecture

The wiki consists of three layers:
1. **The Wiki (`docs/modules/.../`)**: The LLM-maintained layer consisting of Entity Pages, Concept Pages, Execution Flow Docs, Decision Docs, and logs.
2. **The Index (`docs/index.md`)**: The root entry point linking everything together.
3. **The Schema (this file)**: Conventions and structure rules. Co-evolved by user and LLM over time.

## 2. YAML Frontmatter (MANDATORY)

EVERY markdown file you create or update in the Wiki MUST contain a YAML frontmatter block at the very top. This is critical for Dataview and automation.

```yaml
---
tags: [domain, topic]
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

### C. Standardized Domain Layout
Mọi Domain folder nên tuân thủ cấu trúc phân lớp sau:
```text
domains/<domain-name>/
├── index.md           # Entry point & Domain context
├── <entity>.md        # Entity Pages (Gộp logic nội bộ tại đây)
├── flows/             # Chứa *.flow.md (HOW code runs)
├── decisions/         # Chứa các kiến thức về thiết kế/giải pháp (WHY)
└── test-cases/        # Chứa kịch bản test & Verification templates
```

### D. Atomic & Distilled Rule (Anti-Bloat)
- **200-line rule**: Tuyệt đối không để một file Markdown vượt quá 200 dòng.
- Nếu vượt quá, AI phải chủ động đề xuất **tách (Split)** hoặc **tóm lược (Distill)** nội dung.
- Ưu tiên sự súc tích (Precision over Volume).

### E. Entity Pages (`docs/modules/<module>/domains/<domain>/<entity>.md`)
- Organize knowledge around business entities (e.g., `subscription.md`, `invoice.md`).
- Focus on: attributes, states, business rules, and internal logic.

### F. Execution Flow Docs (`docs/modules/<module>/domains/<domain>/flows/*.flow.md`)
- **HOW** the code runs: Sequence diagrams and call chains.
- Template:
  ```markdown
  # <Feature> — Code Flow
  > **Entry point**: `ClassName.methodName()`
  ## Sequence Diagram (Mermaid)
  ## Call Chain
  ## Key Decision Points
  ```

### G. Decision Docs (`docs/modules/<module>/domains/<domain>/decisions/*.md`)
- **WHY** a specific solution was chosen: Rationale, trade-offs, and architecture decisions.
- Use when the reasoning is complex and spans beyond a simple code comment.

### H. Test Case Docs (`docs/modules/<module>/domains/<domain>/test-cases/*.md`)
- Chứa kịch bản test, verification templates, và hướng dẫn kiểm thử đặc thù cho domain.

### I. Visuals & Diagrams (Mermaid Best Practices)
1. **Always use `mermaid` code blocks**.
2. **Never commit heavy binary images** (PNG/JPG).
3. Keep diagrams simple. Break complex flows (> 15 nodes) into sub-diagrams.

## 4. Operational Workflows

The `/docs` workflow supports three operation modes. See `docs.md` for the full process.

- **Update**: Append distilled knowledge to Entity Pages after code changes.
- **Synthesize**: File valuable answers/analyses back into the wiki as Concept/Decision Pages.
- **Lint**: Health-check the wiki for orphan pages, contradictions, stale claims, and the **200-line rule**.

## 5. Co-Evolution
This schema is not static. It grows with the project.

## 6. The Golden Rule
The Wiki is a persistent, compounding artifact. You are the maintainer. Do the bookkeeping. Cross-reference everything. Distill the noise.
