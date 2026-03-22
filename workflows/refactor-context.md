---
description: Restructure oversized SKILL.md or CONTEXT.md files into hub + partitions. Preserves all knowledge.
---

// turbo-all

## When to Use

- Project SKILL.md exceeds 200 lines
- Module CONTEXT.md exceeds 200 lines
- After `/refresh-context` generates a large context file
- When context loading is slow or wasting tokens

## Steps

1. **Identify target file** — ask user if not obvious:
   - `.agent/skills/project-context/SKILL.md` (project-level)
   - `docs/modules/<module>/CONTEXT.md` (module-level)

2. **Measure and report**:
   - Count total lines
   - If ≤200 lines → "File is within limits, no restructuring needed." STOP.
   - If >200 lines → continue

3. **Analyze sections** — read the file and list all `##` sections with line counts:
   ```
   | Section | Lines | Category |
   |---------|:-----:|----------|
   | Overview | 25 | hub |
   | Module Classification | 40 | architecture |
   | DDD Pattern Rules | 60 | architecture |
   | ... | ... | ... |
   ```

4. **Propose partition plan** — group sections by topic:

   **For project SKILL.md** (fixed categories):
   ```
   project-context/
   ├── SKILL.md                    ← Hub (≤150 lines)
   └── references/
       ├── architecture.md         ← Module patterns, DDD/Legacy rules
       ├── conventions.md          ← Naming, testing, git
       ├── infrastructure.md       ← CI/CD, deployment, Docker
       └── quality-checks.md       ← Quality checks, verification commands
   ```

   **For module CONTEXT.md** (flexible, domain-driven):
   ```
   docs/modules/<module>/
   ├── CONTEXT.md                  ← Hub (≤150 lines)
   └── context/
       ├── <topic-1>.md
       ├── <topic-2>.md
       └── <topic-3>.md
   ```
   Categories are proposed by agent based on content analysis. User decides final grouping.

5. **Show plan to user** — present the partition plan with:
   - Which sections go to which partition
   - Estimated line counts per partition
   - Ask: "Approve this split? [Y / adjust / cancel]"

6. **Execute split** (after confirmation):
   a. Create partition files with extracted content
   b. Rewrite hub to ≤150 lines:
      - Keep: Overview, key abstractions, routing table
      - Add routing table pointing to each partition:
        ```markdown
        ## Context Partitions
        | Topic | File | When to Load |
        |-------|------|-------------|
        | ... | `references/X.md` | When working on X |
        ```
   c. Mark all sections with `<!-- AUTO-GENERATED -->` where applicable

7. **Verify no knowledge lost**:
   - Compare total content: hub + all partitions ≥ original file content
   - Check: no sections dropped, no text truncated
   - Report: "✅ All N sections preserved across M files"

8. **Update references** — if other files reference the original:
   - Update `SKILL.md` routing tables
   - Update any `<!-- see CONTEXT.md §X -->` references
