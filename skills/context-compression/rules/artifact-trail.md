# Artifact Trail

To prevent total context loss when a session is truncated or reset, rely on physical files rather than LLM memory.

## The Strategy

Instead of remembering what needs to be built across 5 messages, immediately encode that knowledge into:

1. `tasks/todo.md`: Represents **What needs to be done**.
2. `implementation_plan.md`: Represents **How it will be done**.
3. `tasks/session-context.md`: Represents **Where we are now**.

By creating artifacts, you create an external "trail" that can be instantly retrieved. If a session resets, the first action should be to read these three files to completely recover the mental model of the task.
