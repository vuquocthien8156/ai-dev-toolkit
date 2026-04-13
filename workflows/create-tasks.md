---
description: Generate ClickUp tasks from git changes, existing tasks, or conversation plans. Analyzes, splits into tasks, and creates via ClickUp MCP.
---

# Create Tasks Workflow

Generate task titles and descriptions, then create them on ClickUp.
Supports 3 input sources: git changes, existing ClickUp task, or conversation plan.

📚 Load skill: `task-creation` — for title format, description template, quality gate, and anti-patterns.

---

## Step 0 — Detect Source

Ask user which source to use:

- **A) Git changes** — Create tasks from code diffs/commits
- **B) ClickUp task** — Break down an existing task into subtasks
- **C) Conversation plan** — Extract tasks from discussion/plan in current conversation

Then proceed to the matching Step 1 branch.

---

## Step 1 — Analyze (branch by source)

### Path A: Git Changes

// turbo

1. Detect remote URL for commit links:

   ```
   cd <project-root> && git remote get-url origin
   ```

   Convert to HTTPS format if SSH. Store as `REPO_URL`.

2. Ask user for the diff source. Options:

   - **Staged changes**: `git diff --cached`
   - **Branch diff**: `git diff <base>..HEAD` (ask base branch, default: `main`)
   - **Commit range**: `git log --oneline <range>` + `git diff <range>`
   - **Last N commits**: `git log --oneline -N` + `git diff HEAD~N..HEAD`

3. Get the changes:

   ```
   git diff --stat <source>
   git diff <source>
   git log --oneline <source>
   ```

4. **Deep analysis (MANDATORY)**:

   For each changed file in the diff:
   - **Read the FULL diff** — not just `--stat`. Understand what lines were added/removed and WHY.
   - **Open source files** if diff lacks context — use `view_file` to understand the surrounding code, module, and domain.
   - **Read commit messages** — they often explain intent better than raw diffs.
   - **Trace the impact** — if a function signature changed, who calls it? If a new column was added, where is it used?

5. Group changes by **logical unit of work**:
   - Changes to the same domain/module that serve one purpose = 1 task.
   - Unrelated changes = separate tasks.
   - Do NOT split 1 task per file — split by **business purpose**.

6. For each task, classify type: `Feature`, `Bugfix`, `Refactor`, `Chore`.

7. **Commits section**: Auto-generate links using `REPO_URL/commit/<full_hash>`.

→ Proceed to **Step 2 — Quality Gate** (defined in `task-creation` skill).

---

### Path B: ClickUp Task Breakdown

1. Ask user for the **task ID** or search by name:

   ```
   clickup_get_task(task_id: <id>, subtasks: true)
   ```

2. Read the task thoroughly:
   - Title, description, comments, attachments
   - Existing subtasks (avoid duplicates)
   - Custom fields, priority, assignees

3. **Assess description clarity**:
   - **Clear description** → proceed to deep analysis.
   - **Vague/unclear description** → before splitting, ASK user to clarify scope:
     - "Parent task description chưa rõ scope. Anh bổ sung context được không?"
     - Or offer to research: read related tasks, ClickUp comments, codebase context.
     - Do NOT guess scope from vague titles alone.

4. **Deep analysis (MANDATORY)**:
   - Understand the full scope of the parent task.
   - Identify distinct deliverables / action items within it.
   - Each subtask should be independently completable.
   - Check task comments for additional context or decisions.

5. Propose subtask breakdown:
   - Follow subtask naming convention from `task-creation` skill.

→ Proceed to **Step 2 — Quality Gate** (defined in `task-creation` skill).

---

### Path C: Conversation Plan

1. Read the **current conversation context** — look for:
   - Implementation plans, feature discussions, decision outcomes
   - Action items mentioned in discussion
   - Agreed-upon work items

2. **Deep analysis (MANDATORY)**:
   - Extract concrete, actionable tasks (not vague ideas).
   - Each task must have a clear "done" condition.
   - Distinguish between: decided (create task) vs. still discussing (skip).
   - Reference specific conversation points for traceability.

3. Group extracted items into logical tasks:
   - Related items serving one feature = 1 task.
   - Classify type: `Feature`, `Bugfix`, `Refactor`, `Chore`.

→ Proceed to **Step 2 — Quality Gate** (defined in `task-creation` skill).

---

## Step 2 — Quality Gate

Run the Quality Gate checklist from the `task-creation` skill.
ALL checkboxes must pass for ALL tasks before proceeding.

Apply the Effort-Based Splitting Rule: any task > 8h → propose split to user.

---

## Step 3 — Generate Task Content

Use the title format, description template, and rules from the `task-creation` skill.
Include effort estimate for each task.

---

## Step 4 — Review & Finalize (MANDATORY — ALL PATHS)

**NEVER create tasks without user review and explicit confirmation.**

1. Present ALL generated tasks in a table:

   | # | Type | Title | Effort | Key Changes (summary) |
   |---|------|-------|--------|------------------------|
   | 1 | Feature | ... | ~4h | ... |
   | 2 | Bugfix | ... | ~2h | ... |

   ⚠️ Flag any task with effort > 8h and suggest splitting.

2. Show full description for each task.

3. **Ask user to review**:
   - "Anh muốn chỉnh sửa task nào không?"
   - Iterate until user is satisfied with ALL task content.

4. **Ask task structure** — Choose ONE:
   - **A) Independent tasks** — Each task is a standalone parent task.
   - **B) Subtasks under a parent** — Create 1 parent task, rest are subtasks.
     - Ask for parent task name (or suggest one).
     - Follow subtask naming convention from `task-creation` skill.
   - *(Path B defaults to subtasks under the existing parent task.)*

5. **Ask ClickUp details**:
   - **List**: "Tạo trong list nào trên ClickUp?" — Use `clickup_get_list` to resolve.
   - **Priority**: Ask if user wants to set (urgent/high/normal/low) or skip.
   - **Assignee**: Default = authenticated user. Use `clickup_resolve_assignees(["me"])`.
     Ask if user wants to change or assign to someone else.
   - **Custom fields**: After resolving list, discover available custom fields:
     ```
     clickup_get_custom_fields(list_id: <resolved_list_id>)
     ```
     Present relevant drop-down/label fields to user and ask which to set.
     Do NOT hardcode field names or options — always fetch dynamically.

6. **Final confirmation**: "Ready to create {N} tasks. Confirm?"

   Only proceed after explicit user approval.

---

## Step 5 — Create on ClickUp

### Pre-creation: Resolve defaults

```
clickup_resolve_assignees(["me"]) → default_assignee_id
```

### Option A — Independent Tasks

For each task:
```
clickup_create_task(
  name: "[{Type}] {title}",
  list_id: <resolved_list_id>,
  description: <generated_description>,
  priority: <if provided>,
  assignees: [<default_assignee_id>],
  time_estimate: <effort_in_minutes>,
  custom_fields: [<user_selected_fields>]
)
```

### Option B — Parent + Subtasks

1. Create parent task first (or use existing parent for Path B):
   ```
   clickup_create_task(
     name: "[{Type}] {parent_title}",
     list_id: <resolved_list_id>,
     description: <parent_description_or_summary>,
     priority: <if provided>,
     assignees: [<default_assignee_id>],
     time_estimate: <total_effort_in_minutes>,
     custom_fields: [<user_selected_fields>]
   )
   ```

2. Create each subtask with parent reference:
   ```
   clickup_create_task(
     name: "{Parent Task Name} — {subtask_description}",
     list_id: <resolved_list_id>,
     parent: <parent_task_id>,
     description: <generated_description>,
     assignees: [<default_assignee_id>],
     time_estimate: <effort_in_minutes>,
     custom_fields: [<user_selected_fields>]
   )
   ```

---

## Step 6 — Report

Present results:

```
✅ Created {N} task(s) on ClickUp:

| # | Task ID | Title | URL |
|---|---------|-------|-----|
| 1 | abc123  | ...   | ... |
```
