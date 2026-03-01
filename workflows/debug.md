---
description: Step-by-step debugging methodology. Trace data flow through layers.
---

0. Check if `.agent/skills/project-context/SKILL.md` exists and is fresh
   - Missing? → Suggest: "Run /refresh-context first"
   - Older than 30 days or >50 commits since? → Suggest: "Run /refresh-context --update"
1. Read project-context SKILL.md
2. Reproduce: Understand the exact error/symptom
3. Hypothesize: Form 2-3 likely root causes
4. Investigate: Check logs, trace data flow
5. Read module pattern from project-context
6. Trace through layers according to detected pattern
7. Fix: Propose minimal fix
8. Verify: Suggest how to verify the fix works

## Long Log Strategy (when output > 200 lines)

9. Read TAIL first (last 50 lines) → find error/exception
10. If more context needed → read 50 lines before error
11. Use `grep_search` for keywords: error, exception, failed, stack trace
12. NEVER load entire log into context window
13. Summarize findings into `session-context.md`
