---
name: context-compression
description: Strategies for managing and summarizing context when approaching conversational token limits.
---

# Context Compression Skill

> [!IMPORTANT]
> A full context window is a paralyzed AI. Proactive compression is required to keep sessions productive over long periods.

Activate these rules when a session becomes long, logs become massive, or context limits approach.

## Compression Strategies

Load the appropriate strategy from the `rules/` directory:

| Strategy                          | When to Use                                                                       |
| --------------------------------- | --------------------------------------------------------------------------------- |
| `rules/anchored-summarization.md` | Session is getting long, need to drop old details but keep core goals.            |
| `rules/compression-triggers.md`   | Knowing exactly _when_ to start compressing context.                              |
| `rules/artifact-trail.md`         | Using file artifacts (`tasks/session-context.md`) instead of conversation memory. |
| `rules/long-log-strategy.md`      | Processing massive error logs or test outputs.                                    |
