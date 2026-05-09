---
name: nestjs-architecture
description: NestJS module architecture and dependency injection patterns. Use when creating/refactoring NestJS modules, fixing circular dependencies, or designing service boundaries and DI tokens.
license: MIT
metadata:
  author: ai-dev-toolkit
  version: "1.0.0"
  source: split from nestjs-best-practices (arch + di categories)
---

# NestJS Architecture & Dependency Injection

Best practices for NestJS module organization and IoC container usage.

## When to Apply

- Creating new NestJS modules or services
- Refactoring module boundaries or shared providers
- Fixing circular dependency errors
- Designing injection tokens and interfaces
- Implementing repository pattern or event-driven architecture

## Rule Categories

| Priority | Category | Impact | Prefix |
|----------|----------|--------|--------|
| 1 | Architecture | CRITICAL | `arch-` |
| 2 | Dependency Injection | CRITICAL | `di-` |

### Architecture Rules (`arch-*`)

- `arch-avoid-circular-deps` — Avoid circular module dependencies
- `arch-feature-modules` — Organize by feature, not technical layer
- `arch-module-sharing` — Proper module exports/imports, avoid duplicate providers
- `arch-single-responsibility` — Focused services over "god services"
- `arch-use-repository-pattern` — Abstract database logic for testability
- `arch-use-events` — Event-driven architecture for decoupling

### Dependency Injection Rules (`di-*`)

- `di-avoid-service-locator` — Avoid service locator anti-pattern
- `di-interface-segregation` — Interface Segregation Principle (ISP)
- `di-liskov-substitution` — Liskov Substitution Principle (LSP)
- `di-prefer-constructor-injection` — Constructor over property injection
- `di-scope-awareness` — Understand singleton/request/transient scopes
- `di-use-interfaces-tokens` — Use injection tokens for interfaces

## Usage

Read individual rule files for detailed explanations and code examples:

```
rules/arch-avoid-circular-deps.md
rules/di-prefer-constructor-injection.md
```
