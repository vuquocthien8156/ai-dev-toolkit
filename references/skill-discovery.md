# Skill Discovery Guide

## Finding Skills

```bash
# Search for skills by keyword
npx skills find <query>

# Examples
npx skills find "react native"
npx skills find "nestjs"
npx skills find "typescript"
npx skills find "ddd"
```

## Installing Skills

```bash
# Install from GitHub repo (all skills in that repo)
npx skills add <owner/repo>

# Install specific skill from a repo
npx skills add <owner/repo> --skill <skill-name>

# Example
npx skills add vercel/next.js --skill next-performance
```

## Curated Catalogs

### Primary Resources

| Catalog                  | URL                                                                                                     | Description                                                |
| ------------------------ | ------------------------------------------------------------------------------------------------------- | ---------------------------------------------------------- |
| **skills.sh**            | [skills.sh](https://skills.sh)                                                                          | Central registry. Browse by category, filter by popularity |
| **Antigravity Awesome**  | [GitHub](https://github.com/sickn33/antigravity-awesome-skills)                                         | Curated for Antigravity specifically                       |
| **Awesome Agent Skills** | [GitHub](https://github.com/VoltAgent/awesome-agent-skills)                                             | Cross-platform catalog (works with any AI IDE)             |
| **Awesome Cursorrules**  | [GitHub](https://github.com/PatrickJS/awesome-cursorrules/tree/main/rules)                              | 100+ stack-specific rules for Cursor                       |
| **Antigravity Prompts**  | [GitHub](https://github.com/x1xhlol/system-prompts-and-models-of-ai-tools/tree/main/Google/Antigravity) | Reference system prompts                                   |

### Relevant Stack Rules (from awesome-cursorrules)

| Stack                    | Rule Set                                             |
| ------------------------ | ---------------------------------------------------- |
| **NestJS + TypeScript**  | `typescript-nestjs-best-practices-cursorrules-promp` |
| **React Native + Expo**  | `react-native-expo-cursorrules-prompt-file`          |
| **React + TypeScript**   | `typescript-react-cursorrules-prompt-file`           |
| **Next.js + TypeScript** | `nextjs-typescript-cursorrules-prompt-file`          |
| **Code Quality**         | `javascript-typescript-code-quality-cursorrules-pro` |
| **Jest Testing**         | `jest-unit-testing-cursorrules-prompt-file`          |
| **Git Commits**          | `git-conventional-commit-messages`                   |

> **Note**: `.cursorrules` format ≠ `SKILL.md` format. To convert:
>
> 1. Create folder: `your-skill-name/SKILL.md`
> 2. Add YAML frontmatter: `name` + `description`
> 3. Paste cursorrules content as markdown body

## Evaluating Skills

Before installing a skill, check:

- ⭐ Stars/popularity — community validation
- 📝 Content quality — specific rules vs generic advice
- 🔧 Stack match — does it match your actual tech stack?
- 📏 Size — avoid bloated skills (>50 files = likely too much context)

### Strategy: Keep Few, Keep Curated

> Installing 100+ generic skills dilutes AI attention. Better: 5–10 curated skills with project-specific context.

| Category                        | Recommendation                                      |
| ------------------------------- | --------------------------------------------------- |
| Super-Coder (SOLID, Clean Code) | Keep 1-2 curated. AI already knows these basics.    |
| Tech-Stack (NestJS, React, RN)  | ✅ High value if matched to your stack              |
| QA & Debugging                  | `verification-before-completion` + custom is enough |
| Documentation                   | `documentation-templates` + Knowledge Router        |
| UI/UX Design                    | ✅ Useful for FE/mobile/personal projects           |
