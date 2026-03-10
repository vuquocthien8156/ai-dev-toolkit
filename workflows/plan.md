---
description: Structured planning for any feature or bugfix. Auto-detects module pattern.
---

// turbo-all

0. Check if `.agent/skills/project-context/SKILL.md` exists and is fresh
   - Missing? → Suggest: "Run /refresh-context first"
   - Older than 30 days or >50 commits since? → Suggest: "Run /refresh-context --update"
1. Read the project-context SKILL.md first
2. Identify which module(s) are affected
3. Detect module pattern from project-context
4. Read module architecture pattern from project-context
5. Identify layers and entry points according to detected pattern

6. Create a **File Map** (MANDATORY):

   | Category                                | Files                  | Notes                     |
   | --------------------------------------- | ---------------------- | ------------------------- |
   | **MODIFY**                              | `path/to/file.ts`      | What specifically changes |
   | **CREATE**                              | `path/to/new-file.ts`  | Purpose of the new file   |
   | **READ** (context only — DO NOT modify) | `path/to/reference.ts` | Why reading this          |
   | 🚫 **OFF-LIMITS** (MUST NOT touch)      | `path/to/unrelated/`   | Reason for exclusion      |

   > The File Map is a strict contract. Do NOT modify files outside MODIFY/CREATE.

7. List step-by-step implementation plan with checkable items

8. Define **Verification Commands** (MANDATORY):
   - Use project-context's Verification Command as baseline
   - List exact build/lint/test commands to run after implementation
   - Example:
     ```
     cd <project-root> && source ~/.zshrc
     npx tsc --noEmit              # Type check
     npx eslint <modified-files>   # Lint only changed files
     npm run test -- --grep "module-name"  # Related tests
     ```

9. Ask user to confirm plan before proceeding
