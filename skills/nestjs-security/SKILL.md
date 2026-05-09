---
name: nestjs-security
description: NestJS security and error handling patterns. Use when implementing authentication, authorization guards, input validation, or centralized exception handling.
license: MIT
metadata:
  author: ai-dev-toolkit
  version: "1.0.0"
  source: split from nestjs-best-practices (security + error categories)
---

# NestJS Security & Error Handling

Best practices for securing NestJS applications and handling errors consistently.

## When to Apply

- Implementing JWT authentication or authorization
- Writing guards, interceptors for auth
- Adding input validation with class-validator
- Setting up centralized exception filters
- Implementing rate limiting or output sanitization

## Rule Categories

| Priority | Category | Impact | Prefix |
|----------|----------|--------|--------|
| 3 | Error Handling | HIGH | `error-` |
| 4 | Security | HIGH | `security-` |

### Security Rules (`security-*`)

- `security-auth-jwt` — Secure JWT authentication
- `security-validate-all-input` — Validate with class-validator
- `security-use-guards` — Authentication and authorization guards
- `security-sanitize-output` — Prevent XSS attacks
- `security-rate-limiting` — Implement rate limiting

### Error Handling Rules (`error-*`)

- `error-use-exception-filters` — Centralized exception handling
- `error-throw-http-exceptions` — Use NestJS HTTP exceptions
- `error-handle-async-errors` — Handle async errors properly

## Usage

Read individual rule files for detailed explanations and code examples:

```
rules/security-auth-jwt.md
rules/security-validate-all-input.md
rules/error-use-exception-filters.md
```
