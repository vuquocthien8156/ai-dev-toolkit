---
description: Report current task state by re-reading artifacts. Use when context feels stale or uncertain.
---

# /status Workflow

1. **Re-Read Context**:
   Proactively read (in order):
   - `task.md`
   - Active implementation plan
   - Latest checkpoint (if any)
   - Recent modified files (check `git status` or `ls -lt`)

2. **Generate Report**:
   Present a concise summary:
   - **✅ Completed**: Items verified in the codebase.
   - **[/] In Progress**: Partially implemented items.
   - **❌ Not Started**: Remaining tasks from the plan.
   - **⚠️ Blocked**: Items needing user clarification.

3. **Validation**:
   Ask: "Is this status accurate? Did I miss anything from our recent discussion?"
