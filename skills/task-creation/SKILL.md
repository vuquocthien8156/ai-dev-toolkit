---
name: task-creation
description: Task content generation rules — title format, description template, quality gate, effort estimation, and anti-patterns for creating ClickUp tasks.
---

# Task Creation Skill

Rules and templates for generating high-quality task titles and descriptions.
Used by the `/create-tasks` workflow and any task creation context.

---

## Title Format

```
[{Type}] {Concise description of what changed/needed}
```

### Type Labels

- `[Feature]` — New functionality
- `[Bugfix]` — Bug fix
- `[Refactor]` — Code restructure without behavior change
- `[Chore]` — Maintenance, config, CI/CD, dependencies

### Examples

- `[Feature] Add isSupporter flag to bypass billing`
- `[Bugfix] Subscription expiration cron NULL detachment`
- `[Refactor] Centralize proration logic into ProrationCalculator`
- `[Chore] Upgrade TypeORM to v0.3.x`

---

## Subtask Naming Convention

When creating subtasks under a parent task:

```
{Parent Task Name} — {Subtask Description}
```

- Use ` — ` (em dash) as separator.
- Do NOT include `[Type]` label on subtasks — inherited from parent context.
- Parent name prefix WITHOUT the type label.

### Example

```
Parent:  [Bugfix] Subscription Expiration Cron
├── Subscription Expiration Cron — Eager load subscription items
├── Subscription Expiration Cron — Aggregate errors with try/catch
└── Subscription Expiration Cron — Slack alert on partial failure
```

---

## Description Template

```
{Business context — 1-2 sentences: what problem this solves, why it was needed}

Key changes:
• {Specific technical change or deliverable}
• {...}

Risk / Note: (optional — only when there's real risk or important dependency)
• REQUIRES: {env var, migration, external dependency, etc.}
• {Breaking change, deployment order, etc.}

Commits: (only when source is git changes)
• {hash} {REPO_URL}/commit/{full_hash}
```

### Description Rules

1. **First line is mandatory** — Business context/why. Write as if explaining to a colleague. No filler.
2. **Key changes** — Specific and concrete. Avoid repeating the task title. Focus on "what someone needs to know".
3. **Risk / Note** — Optional section. Only include when there's a real risk. Use `REQUIRES:` prefix for blockers.
4. **Commits** — Only when source is git changes. Always include repo links. Auto-generated from remote URL + commit hash.
5. **DO NOT include**: file/line stats (+178/-9), generic testing checklists, placeholder content, markdown headers (h1/h2/h3).
6. **Plain text only** — No markdown headers. Use UPPERCASE labels for sections. Bullet points with `•`.

### Examples

#### Feature Task

```
Some users (e.g. supporters) need system access but should not count as billing seats.
Added isSupporter flag to bypass billing for these users.

Key changes:
• New isSupporter column on AspNetUsers table
• Seat pricing skips supporter users from pool count
• Admin API: cannot swap supporter ↔ regular member (prevent accidental billing)

Commits:
• 6ae0c6ba https://github.com/org/repo/commit/6ae0c6ba0
```

#### Bug Fix Task

```
Expiration cron crashes when subscription relations are not eager loaded,
causing NULL detachment on TypeORM update.

Key changes:
• Eager load subscription items in expiration query
• Wrap each subscription in try/catch, aggregate errors at end
• Slack alert on partial failure with detailed error list

Risk / Note:
• REQUIRES: "Total time in Status" ClickApp enabled for status tracking

Commits:
• b18710a8 https://github.com/org/repo/commit/b18710a8e
```

#### Refactor Task

```
Proration logic was duplicated across 3 pricing strategies (Pool, Identity, Country).
Centralized into ProrationCalculator for consistency and maintainability.

Key changes:
• calculateForPurchase() — unified entry point for trial vs non-trial
• 3-way seat split: covered / trial-deferred / charged
• Day-based proration for trials, rounded-month for yearly

Commits:
• b82b753c https://github.com/org/repo/commit/b82b753c0
```

---

## Quality Gate

Before generating any title or description, self-check for EACH task:

- [ ] **Can I explain WHY this task is needed?** (not just WHAT it does)
- [ ] **Can I describe the business impact in 1 sentence?** (not technical jargon)
- [ ] **Do I truly understand the scope?** (not guessing from names)
- [ ] **Are the key changes/deliverables specific enough?** (someone can act on it without extra context)
- [ ] **Is the effort ≤ 8 hours?** If estimated > 8h → MUST split into smaller subtasks

❌ If any checkbox fails → go back and analyze more.
✅ Only generate content when ALL checkboxes pass for ALL tasks.

---

## Effort Estimation

- Include a rough effort estimate for each task.
- Format: hours (e.g., `~4h`, `~2h`, `~8h`). Round to nearest hour.
- This will be set as `time_estimate` on ClickUp (converted to minutes).

### Effort-Based Splitting Rule

- If a task > 8h → it is too large. Propose splitting into subtasks where each ≤ 8h.
- Present the split suggestion to user before applying.
- User decides whether to accept the split or keep as-is.

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
