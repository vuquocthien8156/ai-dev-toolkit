---
name: context-optimization
description: Token efficiency patterns. Maximize context window utility by prioritizing precision over volume.
---

# Context Optimization Skill

> [!IMPORTANT]
> Token limits are not just a technical constraint, but a cognitive boundary. Precision reading leads to precision writing.

When managing large codebases or complex tasks, activate these rules to optimize context usage.

## Navigation and Discovery

Rule files provide specific strategies for extracting information with minimal token usage.
Load the appropriate rule file based on your current need:

| Rule File                         | When to Use                                      |
| --------------------------------- | ------------------------------------------------ |
| `rules/search-outline-target.md`  | General codebase exploration (90% token savings) |
| `rules/progressive-disclosure.md` | Deep diving into specific components             |
| `rules/observation-masking.md`    | Reducing output verbosity in reasoning           |
| `rules/budget-management.md`      | Allocating tokens during long sessions           |
| `rules/anti-patterns.md`          | Habits to avoid that burn context                |

## Core Philosophy

- Every line read costs tokens that could be used for reasoning.
- Read only what you must to make the next decision.
- Rely on tools over assumptions. Don't guess what a file contains; use `grep` or `view_file_outline`.
