---
description: Refactor code for quality and architecture alignment. Action-oriented (vs /review which is read-only).
---

0. Read project-context SKILL.md for module patterns and Workflow Hints.
   📚 Load skills: `code-review`, `typescript-mastery`

1. Ask user for refactor scope if unclear:
   - Which files/modules?
   - What outcome? (extract, move, simplify, type-fix)

2. Capture baseline BEFORE changes:

   ```
   cd <project-root> && source ~/.zshrc && <verify-command-from-SKILL.md>
   ```

3. Apply refactoring (pick applicable):
   - **Extract**: Break large files (>300 lines) into focused units
   - **Move**: Relocate code to correct layer (per module pattern in SKILL.md)
   - **Simplify**: Remove dead code, consolidate duplicates
   - **Type**: Replace `any` with proper interfaces, add return types
   - **Rename**: Fix inconsistent naming conventions

4. After refactoring, verify baseline still passes:
   - Type check on modified files only
   - Run related tests

5. Document significant structural changes if applicable.
