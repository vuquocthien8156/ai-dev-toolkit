---
name: llm-wiki-router
description: Rules for maintaining the project's LLM Wiki. Use this to route knowledge properly.
---

# LLM Wiki Router

## Core Principle

Do not lose valuable context. Extract architectural decisions, bug fix patterns, and domain knowledge into the project's LLM Wiki using the `/docs` workflow.

**The Wiki is the Source of Truth.** If code and wiki contradict, the wiki represents the *intended* logic (unless flagged as stale).

## Inquiry Rule (Self-Correction)

Before answering any architectural or domain-specific question, you MUST run a metadata scan to locate the most relevant Source of Truth:
- Command: `grep -r "description:" docs/`
- Action: Read the `description` fields to identify which file contains the definitive answer before reading the full content or making assumptions.

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
| Execution flows (HOW code runs)         | `docs/modules/<module>/domains/<domain>/flows/` | `<feature>.flow.md`       |
| Architectural decisions (WHY/Trade-offs)| `docs/modules/<module>/domains/<domain>/decisions/` | `<topic>.md`            |
| Test scenarios & verification           | `docs/modules/<module>/domains/<domain>/test-cases/` | `<scenario>.md`        |
| Coding patterns & conventions           | `.agents/skills/project-context/SKILL.md` | Append to relevant section     |
| Repeatable agent workflows              | `.agents/workflows/`                      | `command-name.md`              |
| Wiki Index                              | `docs/index.md`                          | Markdown list of links         |
| Change Log                              | `docs/log.md`                            | Append-only timestamped list   |

## Merge vs Split Strategy

Before taking action, evaluate whether to append to an existing file or create a new one:

### 1. Merge (Append)
**Triggers:**
- Knowledge belongs to a single Entity (Internal logic).
- Explains attributes, states, or simple data rules.
- New content is small (< 15 lines).
- File size after merging remains < 200 lines.

### 2. Split (Create New)
**Triggers:**
- Logic spans > 2 Entities (Cross-cutting).
- Requires a complex Mermaid diagram (> 15 nodes).
- Is a standalone process, runbook, or verification checklist.
- Merging would cause the file to exceed **200 lines**.

## Trigger

At the end of a successful task, before declaring "DONE", evaluate:
"Did we establish a new pattern or figure out something complex?"
If Yes → Propose running the `/docs` workflow to update the LLM Wiki.

Additionally, after answering a complex architectural question or explaining a system flow:
"Should we file this synthesis as a Concept Page using `/docs`?"
If Yes → Run `/docs` in Synthesize mode.
