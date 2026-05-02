---
description: Restructures oversized context files to prevent AI context window bloat.
---

# Context Restructuring Workflow

Use this workflow when a `SKILL.md` or `CONTEXT.md` file exceeds 200 lines after generation or modification.
Our strict rule is that a Context Hub MUST stay ≤150 lines (routing table + overview only).

## Process

1. **Measure**: 
   - Count the total lines of the target file. If ≤150 lines → no action needed, stop.
   - If it exceeds the threshold, proceed.

2. **Analyze Sections**: 
   - List all `##` sections with line counts in a table.

3. **Propose Partition Plan (STOP & ASK)**: 
   - Group sections by topic.
   - Show which sections go to which partition file with estimated line counts.
   - Example partitions for a project SKILL.md:
     - `references/architecture.md`
     - `references/conventions.md`
     - `references/infrastructure.md`
   - Ask the user to approve the partition plan.

4. **Execute Split (After Confirmation)**:
   - Create the new partition files with the extracted content.
   - Rewrite the central hub file to be ≤150 lines. It should only contain the high-level overview and a Markdown routing table pointing to the new partitions.

5. **Verify No Knowledge Lost**: 
   - Compare total content — hub + partitions must hold all original knowledge. 
   - Report: "All N sections preserved across M files."

6. **Update References**: 
   - Fix any cross-references to the original file in other documentation or skills.
