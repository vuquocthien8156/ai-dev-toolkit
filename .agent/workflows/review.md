---
description: Systematic code review checklist. Checks patterns, types, errors, performance.
---

1. Read project-context SKILL.md
2. Check: Does the code follow the correct module pattern?
3. Check: Type safety (no `any`, proper interfaces)
4. Check: Error handling (no silent catches)
5. Check: N+1 queries (missing relations/joins)
6. Check: Missing test coverage
7. Check: Unused imports and dead code
8. Present findings as a checklist with severity levels
