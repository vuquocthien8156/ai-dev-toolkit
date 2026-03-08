---
description: Systematic code review checklist. Checks patterns, types, errors, performance.
---

0. Check if `.agent/skills/project-context/SKILL.md` exists and is fresh
   - Missing? → Suggest: "Run /refresh-context first"
   - Older than 30 days or >50 commits since? → Suggest: "Run /refresh-context --update"
     📚 Load skills: `code-review`, `security-best-practices`
1. Read project-context SKILL.md and Workflow Hints for review-specific guidance
2. Check code against module architecture pattern from project-context
3. Check: Type safety (no `any`, proper interfaces)
4. Check: Error handling (no silent catches)
5. Check: N+1 queries (missing relations/joins)
6. Check: Missing test coverage
7. Check: Unused imports and dead code
8. Check: Security concerns
   - No hardcoded secrets, API keys, or credentials in code
   - Authentication/authorization on protected routes/screens
   - Input validation before processing user data
   - No sensitive data exposed in logs or error messages
9. Read Workflow Hints from SKILL.md for project-specific security checks
10. Present findings as a checklist with severity levels (🔴 Critical / 🟡 Warning / 🔵 Info)
