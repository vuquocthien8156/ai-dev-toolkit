# Compression Triggers

Do not wait for an explicit "context limit reached" error. Proactive compression prevents failure.

## Automatic Triggers

1. **The 10-message rule**: After 10 consecutive turns of deep debugging or exploration without a clear resolution, STOP. Summarize findings into `session-context.md` before continuing.
2. **Context Shift**: When the user says "Okay, now let's work on feature Y." Before jumping to Y, summarize the completion of feature X and clear your mental workspace.
3. **Massive Output**: If a command (`npm run test`, `docker logs`) produces hundreds of lines, immediately follow the `long-log-strategy.md` rule. Do not let the output sit unprocessed in the chat context.
4. **Plan Changes**: When an implementation plan changes midway, immediately rewrite the central `implementation_plan.md` artifact. This acts as a forced compression step.
