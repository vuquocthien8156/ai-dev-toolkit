---
description: Interactive workflow to detect tech stack and propose community skills for installation.
---

# Interactive Skill Setup Workflow

Use this workflow to automatically detect the project's dependencies and install relevant community skills.

## Process

1. **Tech Stack Detection**:
   - Read `package.json`, `pyproject.toml`, or `go.mod` to find major dependencies (e.g., `firebase`, `stripe`, `@reduxjs/toolkit`).
   - If `package.json` exists, detect the core framework (e.g., Next.js, NestJS, React Native).

2. **Skill Discovery**:
   - Use `npx skills find <keyword>` for BOTH the core tech stack AND each major dependency discovered. 
   - If this command fails, gracefully fall back to proposing generic skills based on your knowledge.

3. **Proposal (STOP & ASK)**:
   - Present a combined list of recommended skills to the user.
   - Example prompt: "I recommend these skills for your project. Which ones should I install locally?"
   - **CRITICAL**: Wait for explicit confirmation before proceeding.

4. **Installation**:
   - For each confirmed skill, execute `npx -y skills add <skill>` via a tool call in the project root.
   - Skills will be downloaded cleanly to `.agents/skills/`.

5. **Cross-IDE Symlinking**:
   - Create relative IDE symlinks so all IDEs detect the new skills automatically.
   - Run these commands:
     - `ln -sfn ../.agents/skills .cursor/skills`
     - `ln -sfn ../.agents/skills .claude/skills`
     - `ln -sfn ../.agents/skills .windsurf/skills`
     - `ln -sfn ../.agents/skills .continue/skills`

6. **Git Tracking**:
   - Ensure `.agents`, `.claude`, `.cursor`, `.windsurf`, and `.continue` are REMOVED from `.gitignore` so the self-contained zero-config architecture is committed to Git.
