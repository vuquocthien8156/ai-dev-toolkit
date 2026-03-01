---
description: Verification checklist before declaring any task complete. Evidence-based completion.
---

0. Read project-context SKILL.md for Verification Command (build/lint)
1. Re-read the original plan/checklist
2. For EACH checklist item, verify it is actually implemented:
   - Open the file and confirm the change exists
   - Not just "addressed" — actually working
3. Run project's Verification Command (from project-context). If missing, ask user.
4. Fix any type/lint errors found
5. Report explicitly:
   - ✅ Done items (with file paths)
   - ❌ Remaining items (with reasons)
   - ⚠️ Blocked items (needs user input)
6. Only declare "done" when ALL items are ✅
