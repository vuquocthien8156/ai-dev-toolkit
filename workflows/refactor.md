---
description: Refactor code for quality and architecture alignment. Action-oriented (vs /review which is read-only).
---

0. Read project-context SKILL.md for module patterns and Workflow Hints.
   📚 Load skills: `code-review`, `typescript-mastery`

1. Ask user for refactor scope if unclear:
   - Which files/modules?
   - What outcome? (extract, move, simplify, type-fix)

2. Define **Scope Contract** BEFORE touching code:

   | Category          | Files                                  |
   | ----------------- | -------------------------------------- |
   | **IN SCOPE**      | (list files/dirs explicitly)           |
   | 🚫 **OFF-LIMITS** | Everything outside the refactor target |

   > DO NOT refactor unrelated code, even if it looks messy.
   > DO NOT introduce new patterns — follow existing conventions.

3. Capture baseline BEFORE changes:

   ```
   cd <project-root> && source ~/.zshrc && <verify-command-from-SKILL.md>
   ```

4. Apply refactoring (pick applicable):
   - **Extract**: Break large files (>300 lines) into focused units
   - **Move**: Relocate code to correct layer (per module pattern in SKILL.md)
   - **Simplify**: Remove dead code, consolidate duplicates
   - **Type**: Replace `any` with proper interfaces, add return types
   - **Rename**: Fix inconsistent naming conventions

4b. **Behavior Preservation Checklist** (MANDATORY after any refactoring):

   **Before refactor** — document the public API surface:
   - List all public inputs (params, DTOs) and their types
   - List all return types and possible error types
   - List all side effects (DB writes, API calls, events emitted, queue jobs)
   - List edge case behaviors (null handling, empty arrays, default values)

   **After refactor** — verify SAME surface preserved:
   - ✅ Same inputs accepted, same outputs returned
   - ✅ Same errors thrown for same invalid inputs
   - ✅ Same side effects triggered in same order
   - ✅ No new side effects introduced, none removed

   **Red flags** — if ANY of these changed, the refactor altered behavior:
   - Return type changed (even subtly: `T` → `T | undefined`)
   - Error handling differs (catch scope, error types, rethrow)
   - New side effect added or existing one removed
   - Null/undefined behavior changed
   - Method visibility changed (private → public or vice versa)

5. After refactoring, verify baseline still passes:
   - Type check on modified files only
   - Run related tests

6. Document significant structural changes if applicable.
