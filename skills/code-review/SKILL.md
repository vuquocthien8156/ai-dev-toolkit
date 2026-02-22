---
name: code-review
description: >
  Systematic code review checklist for TypeScript/NestJS projects.
  Covers type safety, architecture compliance, performance, error handling,
  and DDD pattern verification.
---

# Code Review Checklist

## How to Use

When reviewing code (your own or others'), go through each section below.
Flag issues with severity:

- 🔴 **Critical** — Must fix before merge (bugs, security, data loss)
- 🟡 **Warning** — Should fix (tech debt, performance, maintainability)
- 🟢 **Suggestion** — Nice to have (readability, consistency)

---

## 1. Type Safety

- [ ] No `any` types anywhere
- [ ] All exported functions have explicit return types
- [ ] DTOs use `class-validator` decorators for input validation
- [ ] No unsafe type assertions (`as X` without prior validation)
- [ ] Nullable types handled explicitly (`?:` or `| null`)
- [ ] No implicit `any` from untyped imports

## 2. Architecture Compliance

### For DDD Modules

- [ ] Domain layer has NO imports from Infrastructure or Framework
- [ ] Aggregates enforce business invariants internally
- [ ] Use Cases have single `execute()` method
- [ ] Repository interfaces defined in Domain, implemented in Infrastructure
- [ ] DTOs only in Presentation layer, domain objects internally
- [ ] Cross-aggregate references by ID only (not by object)

### For Legacy Modules

- [ ] Service contains business logic (not controller)
- [ ] Controller is thin — routing + validation only
- [ ] Entity relationships properly defined

## 3. Error Handling

- [ ] No empty catch blocks (`catch (e) {}`)
- [ ] Errors have meaningful messages with context
- [ ] Custom exceptions for domain-specific errors
- [ ] HTTP exceptions only in Controller/Presentation layer
- [ ] Async operations have proper error boundaries

## 4. Performance

- [ ] No N+1 queries (check `find` calls in loops)
- [ ] Queries use appropriate `relations` / `join` when needed
- [ ] No synchronous heavy operations blocking event loop
- [ ] Pagination for list endpoints
- [ ] Indexing for frequently queried fields

## 5. Code Quality

- [ ] Functions < 20 lines, single responsibility
- [ ] No dead code or unused imports
- [ ] No TODO/FIXME without linked issue
- [ ] Naming follows conventions (PascalCase/camelCase/kebab-case)
- [ ] No magic numbers — use named constants
- [ ] No duplicated logic — extract to shared utilities

## 6. Testing

- [ ] New public methods have unit tests
- [ ] Tests follow Arrange-Act-Assert pattern
- [ ] Test names describe behavior, not implementation
- [ ] Mocks/stubs for external dependencies
- [ ] Edge cases covered (null, empty, boundary values)

## 7. Security

- [ ] No secrets or credentials in code
- [ ] Input validation on all external data
- [ ] Authorization checks where needed
- [ ] SQL injection prevention (parameterized queries)
- [ ] No sensitive data in logs

## 8. Documentation

- [ ] Public APIs have JSDoc comments
- [ ] Complex business logic explained with comments
- [ ] Breaking changes documented
- [ ] README updated if architecture changed
