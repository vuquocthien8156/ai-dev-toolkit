# CLAUDE.md Template

# Copy this to your project root for Claude Code support.

# Claude Code reads this file automatically when opening a project.

## Project Overview

<!-- Replace with your project description -->

This is a TypeScript project using [NestJS/React Native/etc].

## Architecture

<!-- Describe your architecture (DDD, MVC, etc) -->

## Coding Standards

- TypeScript strict mode. No `any`.
- Prefer `interface` for object shapes, `type` for unions.
- Functions: single purpose, <20 lines, verb-first naming.
- Use `readonly` for immutable data.
- DTOs: validate with class-validator.

## Conventions

- File naming: kebab-case (e.g., `user-profile.service.ts`)
- Commit messages: Conventional Commits (`feat:`, `fix:`, `refactor:`)
- Branch naming: `feature/TICKET-description`, `fix/TICKET-description`

## Testing

- Unit tests: Arrange-Act-Assert pattern
- Run: `npm test`
- Type check: `npx tsc --noEmit`

## Important Rules

- PROPOSAL ONLY: Propose changes first, don't edit without confirmation.
- All output in English (code, comments, docs, commits).
- Verify before done: re-read checklist, run type check, confirm each item.
