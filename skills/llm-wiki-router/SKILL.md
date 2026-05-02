---
name: llm-wiki-router
description: Rules for maintaining the project's LLM Wiki. Use this to route knowledge properly.
---

# LLM Wiki Router

## Core Principle

Do not lose valuable context. Extract architectural decisions, bug fix patterns, and domain knowledge into the project's LLM Wiki using the `/docs` workflow.

## Quality Rules (Essence Distillation)

- DISTILL, never summarize. Remove noise; keep decision-grade core.
- Format: [Context] → [Decision/Rule] → [Condition/Scope] in 1-2 sentences.
- Each entry must be SELF-CONTAINED (readable without conversation history).
- Preserve critical: numbers, thresholds, file paths, environment scope.

## Where to Save What (Wiki Pattern)

| Type                                    | Location                                 | Format                         |
| --------------------------------------- | ---------------------------------------- | ------------------------------ |
| Business rules & domain logic           | `docs/modules/<module>/domains/`         | Entity Pages (`subscription.md`) |
| Cross-cutting use cases                 | `docs/modules/<module>/use-cases/`       | Concept Pages (`tenant.md`)      |
| Execution flows (sequence & call chains)| `docs/modules/<module>/domains/<domain>/flows/` | `<feature>.flow.md`       |
| Coding patterns & conventions           | `.agents/skills/project-context/SKILL.md` | Append to relevant section     |
| Repeatable agent workflows              | `.agents/workflows/`                      | `command-name.md`              |
| Wiki Index                              | `docs/index.md`                          | Markdown list of links         |
| Change Log                              | `docs/log.md`                            | Append-only timestamped list   |

## Entity Merge Rule

Before creating a new file, ALWAYS read `docs/index.md`. 
If an Entity Page exists for the topic (e.g., `invoice.md`), APPEND the new knowledge as a section. Only create new files for entirely new concepts. Do NOT create monolithic files.

## Trigger

At the end of a successful task, before declaring "DONE", evaluate:
"Did we establish a new pattern or figure out something complex?"
If Yes → Propose running the `/docs` workflow to update the LLM Wiki.

Additionally, after answering a complex architectural question or explaining a system flow:
"Should we file this synthesis as a Concept Page using `/docs`?"
If Yes → Run `/docs` in Synthesize mode.
