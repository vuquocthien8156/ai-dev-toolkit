---
description: Save current task state to a persistent checkpoint file. Use before conversation switches or long breaks.
---

# /checkpoint Workflow

1. **Information Gathering**:
   - Read the current `task.md` and implementation plan artifacts.
   - Scan the conversation for key decisions, research findings, or code changes not yet documented.

2. **Create Checkpoint File**:
   Write to `brain/<conversation-id>/checkpoint-<timestamp>.md`:
   - **Current Task**: Brief objective.
   - **Progress State**: ✅ Completed / [/] In Progress / ❌ Todo.
   - **Key Decisions**: List of architectural or logic decisions made.
   - **Known Context**: Critical file paths, error logs, or research links.
   - **Remaining Gaps**: Unresolved questions or blocked items.
   - **Next Steps**: What the next session should immediately focus on.

3. **Confirmation**:
   Confirm to the user: "✅ Checkpoint saved at `<path>`. In your next conversation, simply tell the agent to read this checkpoint to resume."
