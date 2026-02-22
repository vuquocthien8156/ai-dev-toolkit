---
name: git-workflow
description: >
  Git conventions for branch naming, commit messages, PR workflow, and
  release management. Follows Conventional Commits standard.
---

# Git Workflow

## Branch Naming

```
<type>/<ticket-id>-<short-description>

# Examples
feature/HR-123-add-leave-approval
fix/HR-456-quota-calculation-error
refactor/HR-789-extract-pricing-service
chore/update-dependencies
```

| Type        | When to use                             |
| ----------- | --------------------------------------- |
| `feature/`  | New functionality                       |
| `fix/`      | Bug fix                                 |
| `refactor/` | Code restructuring (no behavior change) |
| `chore/`    | Dependencies, configs, tooling          |
| `hotfix/`   | Urgent production fix                   |

## Commit Messages (Conventional Commits)

```
<type>(<scope>): <description>

[optional body]

[optional footer]
```

### Types

| Type       | Description                         | Example                                       |
| ---------- | ----------------------------------- | --------------------------------------------- |
| `feat`     | New feature                         | `feat(leave): add auto-approval for < 3 days` |
| `fix`      | Bug fix                             | `fix(billing): correct proration calculation` |
| `refactor` | Restructure without behavior change | `refactor(auth): extract token service`       |
| `docs`     | Documentation only                  | `docs(api): update endpoint descriptions`     |
| `test`     | Add or fix tests                    | `test(billing): add proration edge cases`     |
| `chore`    | Build, tooling, deps                | `chore: upgrade TypeORM to 0.3.20`            |
| `perf`     | Performance improvement             | `perf(query): add index for leave lookups`    |

### Rules

- Subject line: imperative mood, lowercase, no period, max 72 chars
- Body: wrap at 72 chars, explain WHY not WHAT
- Footer: `BREAKING CHANGE:` for breaking changes, `Closes #123` for issues

### Examples

```
feat(billing): implement interval change with proration

Allow subscription interval change from monthly to yearly.
Proration calculated proportionally for remaining days.

Closes HR-567
```

```
fix(saga): prevent duplicate invoice creation

The AdminOnboardingSaga was creating duplicate invoices when
the user clicked submit twice rapidly. Added idempotency check
using metadata key.

Closes HR-890
```

## PR Workflow

### Before Creating PR

1. Rebase on latest `develop`
2. Run `npx tsc --noEmit` — zero errors
3. Run tests — all pass
4. Self-review the diff

### PR Description Template

```markdown
## What

Brief description of the change.

## Why

Business context or bug report.

## How

Technical approach taken.

## Testing

- [ ] Unit tests added/updated
- [ ] Manual testing done
- [ ] Edge cases covered

## Screenshots (if UI)
```

### Review Process

1. Author creates PR and assigns reviewers
2. Reviewer uses code-review SKILL.md checklist
3. Address feedback — resolve conversations
4. Squash merge to `develop`

## Release Flow

```
feature/* → develop → staging → main
              ↑                   ↓
           hotfix/* ←────── main (tag)
```

| Branch    | Purpose             | Deploy to           |
| --------- | ------------------- | ------------------- |
| `develop` | Integration branch  | Dev environment     |
| `staging` | Pre-release testing | Staging environment |
| `main`    | Production ready    | Production          |
