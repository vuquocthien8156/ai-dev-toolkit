---
description: Generate or improve tests for modified code. Follows project patterns.
---

0. Read project-context SKILL.md for test commands, patterns, and Workflow Hints.
   📚 Load skill: `backend-testing`

1. Identify modified files that need tests.
   - Find existing test files near modified code (`*.spec.ts`, `*.test.ts`, `*.test.js`)
   - If exist: follow the SAME patterns (imports, mocking style, describe structure)
   - If none: use the closest test file in the module as reference

2. Generate tests covering:
   - ✅ Happy path (expected inputs → expected outputs)
   - ⚠️ Edge cases (null, empty, boundary values)
   - ❌ Error cases (invalid inputs, thrown exceptions)

3. Run tests:

   ```
   cd <project-root> && source ~/.zshrc && <test-command-from-SKILL.md> <path>
   ```

4. Fix ONLY failing tests related to your changes. Ignore pre-existing failures.

5. Report:
   - Files tested
   - Cases covered
   - Any gaps or untestable areas
