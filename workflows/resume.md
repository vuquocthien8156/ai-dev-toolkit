---
description: Discover and restore context from recent conversations in the toolkit brain.
---

# /resume Workflow

1. **Scan Brain**:
   List recent directories in `~/.gemini/antigravity/brain/` sorted by modification date.

2. **Identify Candidates**:
   Read `handoff.md` or `checkpoint.md` in the last 3-5 sessions to find relevant tasks.

3. **User Selection**:
   Present findings:
   "Found these related sessions:
   1. [Date] Task: <Title> - State: <status>
   2. [Date] Task: <Title> - State: <status>
   Which one should I resume from?"

4. **Rehydration**:
   Once selected, read the full `handoff.md`/`checkpoint.md` and associated plan.
   - Summarize the state into the current conversation.
   - Propose the next immediate step.

5. **Done**:
   Confirm: "Context rehydrated. Ready to continue task: <title>."
