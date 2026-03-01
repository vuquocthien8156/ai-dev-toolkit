---
description: Systematic code review checklist. Checks patterns, types, errors, performance.
---

0. Check if `.agent/skills/project-context/SKILL.md` exists and is fresh
   - Missing? → Suggest: "Run /refresh-context first"
   - Older than 30 days or >50 commits since? → Suggest: "Run /refresh-context --update"
1. Read project-context SKILL.md
2. Check code against module architecture pattern from project-context
3. Check: Type safety (no `any`, proper interfaces)
4. Check: Error handling (no silent catches)
5. Check: N+1 queries (missing relations/joins)
6. Check: Missing test coverage
7. Check: Unused imports and dead code
8. Present findings as a checklist with severity levels
