---
name: nestjs-api
description: NestJS API design, testing, microservices, and DevOps patterns. Use when designing REST endpoints, writing tests, setting up queues/health checks, or configuring logging and graceful shutdown.
license: MIT
metadata:
  author: ai-dev-toolkit
  version: "1.0.0"
  source: split from nestjs-best-practices (api + test + micro + devops categories)
---

# NestJS API, Testing, Microservices & DevOps

Best practices for API design, testing infrastructure, microservice patterns, and deployment in NestJS.

## When to Apply

- Designing REST API endpoints (DTOs, interceptors, versioning, pipes)
- Writing unit or E2E tests for NestJS modules
- Setting up message queues or event patterns
- Implementing health checks for orchestration
- Configuring structured logging or graceful shutdown

## Rule Categories

| Priority | Category | Impact | Prefix |
|----------|----------|--------|--------|
| 6 | Testing | MEDIUM-HIGH | `test-` |
| 8 | API Design | MEDIUM | `api-` |
| 9 | Microservices | MEDIUM | `micro-` |
| 10 | DevOps & Deployment | LOW-MEDIUM | `devops-` |

### API Design Rules (`api-*`)

- `api-use-dto-serialization` — DTO and response serialization
- `api-use-interceptors` — Cross-cutting concerns
- `api-versioning` — API versioning strategies
- `api-use-pipes` — Input transformation with pipes

### Testing Rules (`test-*`)

- `test-use-testing-module` — Use NestJS testing utilities
- `test-e2e-supertest` — E2E testing with Supertest
- `test-mock-external-services` — Mock external dependencies

### Microservices Rules (`micro-*`)

- `micro-use-patterns` — Message and event patterns
- `micro-use-health-checks` — Health checks for orchestration
- `micro-use-queues` — Background job processing

### DevOps Rules (`devops-*`)

- `devops-use-config-module` — Environment configuration
- `devops-use-logging` — Structured logging
- `devops-graceful-shutdown` — Zero-downtime deployments

## Usage

Read individual rule files for detailed explanations and code examples:

```
rules/api-use-dto-serialization.md
rules/test-use-testing-module.md
rules/devops-use-logging.md
```
