---
description: Generate ClickUp tasks from git changes, existing tasks, or conversation plans. Analyzes, splits into tasks, and creates via ClickUp MCP.
---

# Create Tasks Workflow

Generate task titles and descriptions, then create them on ClickUp.
Supports 3 input sources: git changes, existing ClickUp task, or conversation plan.

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

→ Proceed to **Step 2 — Quality Gate**.

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
   - Each subtask = 1 concrete deliverable
   - Subtask title format: `{Parent Task Name} — {Subtask Description}`
   - Subtask titles do NOT include `[Type]` label (inherited from parent).

→ Proceed to **Step 2 — Quality Gate**.

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

→ Proceed to **Step 2 — Quality Gate**.

---

## Step 2 — Quality Gate (ALL PATHS)

Before generating any title or description, self-check for EACH task:

- [ ] **Can I explain WHY this task is needed?** (not just WHAT it does)
- [ ] **Can I describe the business impact in 1 sentence?** (not technical jargon)
- [ ] **Do I truly understand the scope?** (not guessing from names)
- [ ] **Are the key changes/deliverables specific enough?** (someone can act on it without extra context)
- [ ] **Is the effort ≤ 8 hours?** If estimated > 8h → MUST split into smaller subtasks

### Effort-Based Splitting Rule

- Estimate effort for each task (rough hours of actual dev work).
- If a task > 8h → it is too large. Propose splitting into subtasks where each ≤ 8h.
- Present the split suggestion to user: "Task X ước lượng ~12h, recommend tách thành 2 subtasks:"
- User decides whether to accept the split or keep as-is.

❌ If any checkbox fails → go back to Step 1 and analyze more.
✅ Only proceed to Step 3 when ALL checkboxes pass for ALL tasks.

---

## Step 3 — Generate Task Content

### Title Format

```
[{Type}] {Concise description of what changed/needed}
```

Examples:

- `[Feature] Add isSupporter flag to bypass billing`
- `[Bugfix] Subscription expiration cron NULL detachment`
- `[Refactor] Centralize proration logic into ProrationCalculator`

### Description Format

```
{Business context — 1-2 sentences: what problem this solves, why it was needed}

Key changes:
• {Specific technical change or deliverable}
• {...}

Risk / Note: (optional — only when there's real risk or important dependency)
• REQUIRES: {env var, migration, external dependency, etc.}
• {Breaking change, deployment order, etc.}

Commits: (only for Path A — Git changes)
• {hash} {REPO_URL}/commit/{full_hash}
```

### Effort Estimate

Include a rough effort estimate for each task. This will be set as `time_estimate` on ClickUp.
Format: hours (e.g., `~4h`, `~2h`, `~8h`). Round to nearest hour.

### Description Rules

1. **First line is mandatory** — Business context/why. Write as if explaining to a colleague. No filler.
2. **Key changes** — Specific and concrete. Avoid repeating the task title. Focus on "what someone needs to know".
3. **Risk / Note** — Optional section. Only include when there's a real risk. Use `REQUIRES:` prefix for blockers.
4. **Commits** — Only for Path A. Always include repo links. Auto-generated from `REPO_URL` + commit hash.
5. **DO NOT include**: file/line stats (+178/-9), generic testing checklists, placeholder content, markdown headers (h1/h2/h3).
6. **Plain text only** — No markdown headers. Use UPPERCASE labels for sections. Bullet points with `•`.

---

## Step 4 — Review & Finalize (MANDATORY — ALL PATHS)

**NEVER create tasks without user review and explicit confirmation.**

1. Present ALL generated tasks in a table:

   | #   | Type    | Title | Effort | Key Changes (summary) |
   | --- | ------- | ----- | ------ | --------------------- |
   | 1   | Feature | ...   | ~4h    | ...                   |
   | 2   | Bugfix  | ...   | ~2h    | ...                   |

   ⚠️ Flag any task with effort > 8h and suggest splitting.

2. Show full description for each task.

3. **Ask user to review**:
   - "Anh muốn chỉnh sửa task nào không?"
   - Iterate until user is satisfied with ALL task content.

4. **Ask task structure** — Choose ONE:
   - **A) Independent tasks** — Each task is a standalone parent task.
   - **B) Subtasks under a parent** — Create 1 parent task, rest are subtasks.
     - Ask for parent task name (or suggest one).
     - Subtask title format: `{Parent Task Name} — {Subtask Description}`
     - Subtask titles do NOT include the `[Type]` label (inherited from parent context).
   - _(Path B defaults to subtasks under the existing parent task.)_

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
     Common examples: Module, Type, Environment — but do NOT hardcode options.
     Let user pick from the dynamically fetched options.

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

---

## Anti-Patterns (DO NOT)

- ❌ `Add isSupporter boolean to user entity` — Too vague, repeats title
- ❌ `Files: 12 | +178 / -9` — Nobody cares about line stats
- ❌ `DEV TESTING: Set user as supporter → verify excluded` — Generic, obvious
- ❌ Using ## or ### markdown headers in description — ClickUp renders them too large
- ❌ Writing description that reads like documentation — Keep it conversational
- ❌ Creating 1 task per file changed — Group by logical unit of work
- ❌ Subtask title without parent prefix — Loses context in flat views
- ❌ Creating tasks without user review — ALWAYS present and get confirmation first
- ❌ Extracting vague "maybe" items from conversation — Only create tasks for decided items
