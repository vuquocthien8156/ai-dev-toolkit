---
description: Generate ClickUp tasks from git changes. Analyzes diffs, splits into tasks, and creates via ClickUp MCP.
---

# Create Tasks from Git Changes

Generate task titles and descriptions from git changes, then create them on ClickUp.

## Step 0 — Collect Git Info

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

## Step 1 — Deep Analysis & Split into Tasks

### 1a. Understand the Code (MANDATORY — Do NOT skip)

For each changed file in the diff:

1. **Read the FULL diff** — not just `--stat`. Understand what lines were added/removed and WHY.
2. **Open source files** if diff lacks context — use `view_file` on the original file to understand:
   - What function/class was modified
   - What the surrounding code does
   - What module/domain this belongs to
3. **Read commit messages** — they often explain intent better than raw diffs.
4. **Trace the impact** — if a function signature changed, who calls it? If a new column was added, where is it used?

### 1b. Group into Logical Tasks

1. Group changes by **logical unit of work** (feature, bugfix, refactor, etc.).
   - Changes to the same domain/module that serve one purpose = 1 task.
   - Unrelated changes = separate tasks.
   - Do NOT split 1 task per file — split by **business purpose**.
2. For each task, classify type: `Feature`, `Bugfix`, `Refactor`, `Chore`.

### 1c. Quality Gate (MUST pass before proceeding to Step 2)

Before generating any title or description, self-check for EACH task:

- [ ] **Can I explain WHY this change was needed?** (not just WHAT changed)
- [ ] **Can I describe the business impact in 1 sentence?** (not technical jargon)
- [ ] **Do I understand what the code actually does?** (not guessing from file names)
- [ ] **Are the key changes specific enough?** (someone can review without reading the diff)

❌ If any checkbox fails → go back to 1a and read more context.
✅ Only proceed to Step 2 when ALL checkboxes pass for ALL tasks.

## Step 2 — Generate Task Content

For each identified task, generate:

### Title Format

```
[{Type}] {Concise description of what changed}
```

Examples:
- `[Feature] Add isSupporter flag to bypass billing`
- `[Bugfix] Subscription expiration cron NULL detachment`
- `[Refactor] Centralize proration logic into ProrationCalculator`

### Description Format

```
{Business context — 1-2 sentences: what problem this solves, why it was needed}

Key changes:
• {Specific technical change, mention key file/module if relevant}
• {...}

Risk / Note: (optional — only when there's real risk or important dependency)
• REQUIRES: {env var, migration, external dependency, etc.}
• {Breaking change, deployment order, etc.}

Commits:
• {hash} {REPO_URL}/commit/{full_hash}
```

### Description Rules

1. **First line is mandatory** — Business context/why. Write as if explaining to a colleague. No filler.
2. **Key changes** — Specific and concrete. Avoid repeating the task title. Focus on "what someone needs to know".
3. **Risk / Note** — Optional section. Only include when there's a real risk. Use `REQUIRES:` prefix for blockers.
4. **Commits** — Always include GitHub/GitLab links. Auto-generated from `REPO_URL` + commit hash.
5. **DO NOT include**: file/line stats (+178/-9), generic testing checklists, placeholder content, markdown headers (h1/h2/h3).
6. **Plain text only** — No markdown headers. Use UPPERCASE labels for sections. Bullet points with `•`.

## Step 3 — Present & Ask User

1. Present ALL generated tasks in a table:

   | # | Type | Title | Key Changes (summary) |
   |---|------|-------|-----------------------|
   | 1 | Feature | ... | ... |
   | 2 | Bugfix | ... | ... |

2. Show full description for each task.

3. Ask user:
   - **Review**: "Anh muốn chỉnh sửa task nào không?"
   - **Task structure**: Choose ONE:
     - **A) Independent tasks** — Each task is a standalone parent task.
     - **B) Subtasks under a parent** — Create 1 parent task, rest are subtasks.
       - Ask for parent task name (or suggest one).
       - Subtask title format: `{Parent Task Name} — {Subtask Description}`
       - Subtask titles do NOT include the `[Type]` label (inherited from parent context).
   - **ClickUp list**: "Tạo trong list nào trên ClickUp?" — Use `clickup_get_list` to resolve.
   - **Priority**: Ask if user wants to set priority (urgent/high/normal/low) or skip.
   - **Assignee**: Ask if user wants to assign to someone or skip.

## Step 4 — Create on ClickUp

### Option A — Independent Tasks

For each task:
```
clickup_create_task(
  name: "[{Type}] {title}",
  list_id: <resolved_list_id>,
  description: <generated_description>,
  priority: <if provided>,
  assignees: <if provided>
)
```

### Option B — Parent + Subtasks

1. Create parent task first:
   ```
   clickup_create_task(
     name: "[{Type}] {parent_title}",
     list_id: <resolved_list_id>,
     description: <parent_description_or_summary>,
     priority: <if provided>,
     assignees: <if provided>
   )
   ```

2. Create each subtask with parent reference:
   ```
   clickup_create_task(
     name: "{Parent Task Name} — {subtask_description}",
     list_id: <resolved_list_id>,
     parent: <parent_task_id>,
     description: <generated_description>
   )
   ```

## Step 5 — Report

Present results:

```
✅ Created {N} task(s) on ClickUp:

| # | Task ID | Title | URL |
|---|---------|-------|-----|
| 1 | abc123  | ...   | ... |
```

## Anti-Patterns (DO NOT)

- ❌ `Add isSupporter boolean to user entity` — Too vague, repeats title
- ❌ `Files: 12 | +178 / -9` — Nobody cares about line stats
- ❌ `DEV TESTING: Set user as supporter → verify excluded` — Generic, obvious
- ❌ Using ## or ### markdown headers in description — ClickUp renders them too large
- ❌ Writing description that reads like documentation — Keep it conversational
- ❌ Creating 1 task per file changed — Group by logical unit of work
- ❌ Subtask title without parent prefix — Loses context in flat views
