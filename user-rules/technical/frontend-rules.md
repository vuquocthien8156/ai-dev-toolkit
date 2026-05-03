# FRONTEND SPECIFIC RULES (Next.js / React)

> [!IMPORTANT]
> Proactively load these technical skills from `~/.agents/skills/` when the context matches:
>
> | Trigger | Skill to Load |
> |---------|---------------|
> | Writing or reviewing React/Next.js | `vercel-react-best-practices` |

## Architecture & Boundaries
- NEVER place direct database queries or complex webhook logic inside client components.
- Clearly distinguish between Server Components and Client Components (using `"use client"` only when necessary for interactivity).

## Component Reusability
- Before building a new UI component, check the existing shared UI component library.
- If modifying a shared UI component, trace its usages across different pages to ensure layout and prop injections do not break.

## Modern Standards
- Use modern Next.js App Router paradigms. Do not fall back to `pages/` directory patterns.
- Ensure proper SEO tags and metadata generation are maintained when altering page layouts.