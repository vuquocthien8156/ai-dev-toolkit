# BACKEND SPECIFIC RULES (NestJS / Node.js)

> [!IMPORTANT]
> Proactively load these technical skills from `~/.agents/skills/` when the context matches:
>
> | Trigger | Skill to Load |
> |---------|---------------|
> | Writing or reviewing NestJS code | `nestjs-best-practices` |
> | Security review, auth code, secrets | `api-security-best-practices` |
> | Writing or improving tests, `/test` | `backend-testing` |
> | DDD module detected | `ddd-core-rules` |

## Architecture & Boundaries
- Maintain strict separation of concerns following NestJS architecture: Controllers handle HTTP, Services handle business logic.
- Do not mix database calls directly inside Controllers.
- When handling distributed data or external events (e.g., Stripe webhooks), ensure strict adherence to the Outbox Pattern if implemented in the project.

## Impact Radius
- CRITICAL: Before modifying any Service method or DTO, identify its impact radius. Find all Controllers or internal Services that call this method and ensure their typings and data consumption are updated.
- After code modifications, simulate a TypeScript compilation check mentally to ensure no external callers are broken.

## Modern Standards
- Strictly enforce TypeScript types. DO NOT use `any`.
- Keep error handling robust. Use explicit exception throwing (e.g., `BadRequestException`) rather than silent failures.