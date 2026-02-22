# AGENTS.md Template

# Copy this to your project root for GitHub Copilot / Codex support.

# These tools read AGENTS.md for project-specific instructions.

## Project Context

<!-- Replace with your project description -->

This is a TypeScript project. Follow these rules strictly.

## Coding Standards

- Never use `any` type. Use `unknown` + type guards.
- Always declare return types for functions.
- Interface for object shapes, type for unions/intersections.
- Functions: single purpose, <20 lines.
- Use `readonly` for immutable data.
- PascalCase for classes, camelCase for variables, kebab-case for files.

## Architecture Rules

<!-- Add your architecture-specific rules -->

- Follow existing module patterns
- Keep controllers thin — routing + validation only
- Business logic in services/use-cases

## Output Language

- All code, comments, variable names, documentation: English only
- Never write non-English text in code files
