---
description: Step-by-step debugging methodology. Trace data flow through layers.
---

1. Read project-context SKILL.md
2. Reproduce: Understand the exact error/symptom
3. Hypothesize: Form 2-3 likely root causes
4. Investigate: Check logs, trace data flow
5. For DDD: Trace Use Case → Service → Port → Gateway
6. For Legacy: Trace Controller → Service → Repository
7. Fix: Propose minimal fix
8. Verify: Suggest how to verify the fix works
