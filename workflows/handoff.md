---
description: Prepare a concise summary for a new conversation. Use to save tokens and clear context.
---

# /handoff Workflow

1. **Synthesize Work**:
   Extract core information from the current session:
   - **Original Objective**: What was the starting goal?
   - **Progress Summary**: What was built/fixed.
   - **Crucial Context**: Logic discovered, complex bugs found, or specific file dependencies.
   - **Decisions**: Why we chose A over B.
   - **Next Session Start**: The exact first step for the next conversation.

2. **Create Handoff Artifact**:
   Write to `brain/<conversation-id>/handoff.md`. Use a dense, agent-friendly format.

3. **Recommendation**:
   Advise the user: "✅ Handoff ready. You can now start a fresh conversation to maximize token window. Just tell the new agent to read this handoff file."
