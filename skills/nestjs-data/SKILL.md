---
name: nestjs-data
description: NestJS database and performance patterns. Use when writing TypeORM/Prisma queries, implementing caching, optimizing DB performance, or managing transactions and migrations.
license: MIT
metadata:
  author: ai-dev-toolkit
  version: "1.0.0"
  source: split from nestjs-best-practices (db + perf categories)
---

# NestJS Database & Performance

Best practices for data access patterns and performance optimization in NestJS.

## When to Apply

- Writing TypeORM or Prisma queries
- Implementing caching strategies (Redis, in-memory)
- Fixing N+1 query problems
- Managing database transactions
- Running or writing migrations
- Lazy loading modules for startup optimization

## Rule Categories

| Priority | Category | Impact | Prefix |
|----------|----------|--------|--------|
| 5 | Performance | HIGH | `perf-` |
| 7 | Database & ORM | MEDIUM-HIGH | `db-` |

### Database Rules (`db-*`)

- `db-use-transactions` — Transaction management
- `db-avoid-n-plus-one` — Avoid N+1 query problems
- `db-use-migrations` — Use migrations for schema changes

### Performance Rules (`perf-*`)

- `perf-async-hooks` — Proper async lifecycle hooks
- `perf-use-caching` — Implement caching strategies
- `perf-optimize-database` — Optimize database queries
- `perf-lazy-loading` — Lazy load modules for faster startup

## Usage

Read individual rule files for detailed explanations and code examples:

```
rules/db-avoid-n-plus-one.md
rules/perf-use-caching.md
rules/db-use-transactions.md
```
