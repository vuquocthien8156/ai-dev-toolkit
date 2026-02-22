---
description: Step-by-step debugging methodology. Trace data flow through layers.
---

0. Check if `.agent/skills/project-context/SKILL.md` exists and is fresh
   - Missing? → Suggest: "Run /init-project first"
   - Older than 30 days or >50 commits since? → Suggest: "Run /init-project --update"
1. Read project-context SKILL.md
2. Reproduce: Understand the exact error/symptom
3. Hypothesize: Form 2-3 likely root causes
4. Investigate: Check logs, trace data flow
5. For DDD: Trace Use Case → Service → Port → Gateway
6. For Legacy: Trace Controller → Service → Repository
7. Fix: Propose minimal fix
8. Verify: Suggest how to verify the fix works
