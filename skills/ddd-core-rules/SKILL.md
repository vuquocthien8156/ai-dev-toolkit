---
name: ddd-core-rules
description: >
  DDD best practices for any project. Aggregate rules, layer dependencies,
  tactical patterns (Entity, Value Object, Domain Event, Port/Adapter).
  Sources: Eric Evans, Martin Fowler, nestjslatam/ddd.
---

# DDD Core Rules

> [!IMPORTANT]
> When active in a DDD-structured module (identified via `project-context/SKILL.md`), strictly adhere to these layer dependencies and patterns.

## Domain-Driven Design Modules

Load the appropriate rule file based on the layer or pattern you are currently modifying:

| Rule File                     | When to Use                                                                                        |
| ----------------------------- | -------------------------------------------------------------------------------------------------- |
| `rules/layer-dependencies.md` | General overview of allowed imports and layer flow. Always read first when modifying architecture. |
| `rules/tactical-patterns.md`  | When creating/modifying Aggregates, Entities, Value Objects, or Domain Events.                     |
| `rules/anti-patterns.md`      | Common mistakes to avoid in DDD codebases.                                                         |

## Quick Reference

```
Domain ← Application ← Infrastructure ← Presentation
```

_Domain is pure. Infrastructure is dirty. Application orchestrates. Presentation routes._
