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
4. Create a plan in `tasks/todo.md` with checkable items
5. Read module architecture pattern from project-context
6. Identify layers and entry points according to detected pattern
7. List files to create/modify
8. Ask user to confirm plan before proceeding
