---
description: Auto-generate PR description from git changes.
---

// turbo-all

0. Read project-context SKILL.md to identify affected modules.
   📚 Load skill: `git-workflow`

1. Get changed files:

   ```
   cd <project-root> && git diff --name-only main...HEAD
   ```

   Ask user for base branch if `main` is not correct.

2. Get commits:

   ```
   git log --oneline main...HEAD
   ```

3. Generate PR description using this template:

   ```markdown
   ## Summary

   1-2 sentence overview of what this PR does.

   ## Changes

   ### [Module/Component Name]

   - File changes grouped by module
   - What changed and why

   ## Testing

   - How this was tested
   - Test commands or manual steps

   ## Checklist

   - [ ] Breaking changes?
   - [ ] Migration needed?
   - [ ] Config changes?
   - [ ] Docs updated?
   ```

4. Present to user for review before copying.
