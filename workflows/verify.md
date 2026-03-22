---
description: Verification checklist before declaring any task complete. Evidence-based completion.
---

0. Read project-context SKILL.md for Verification Command (build/lint)
1. Re-read the original plan/checklist
2. For EACH checklist item, verify it is actually implemented:
   - Open the file and confirm the change exists
   - Not just "addressed" — actually working
3. Run project's Verification Command (from project-context). If missing, ask user. IMPORTANT: `cd` to project root and `source ~/.zshrc` before running!
4. Fix type/lint errors ONLY in the files you modified. Do NOT touch other files.
5. Report explicitly:
   - ✅ Done items (with file paths)
   - ❌ Remaining items (with reasons)
   - ⚠️ Blocked items (needs user input)
6. Only declare "done" when ALL items are ✅

## Red Flags Checklist

If you catch yourself doing ANY of these, your verification is INVALID. Stop and redo.

- ❌ Using language: "should work", "probably passes", "likely fine", "looks good"
- ❌ Trusting another agent's or tool's claim without running your OWN verification
- ❌ Verifying only the happy path — skipping error cases, edge cases, empty inputs
- ❌ Running partial tests (1 of N suites) and claiming "all tests pass"
- ❌ Not checking exit codes after terminal commands (`echo $?`)
- ❌ Claiming done based on "no errors visible" without reading FULL output
- ❌ Skipping verification for "trivial" changes — ALL changes get verified
- ❌ Declaring complete when the plan/checklist still has unchecked items
