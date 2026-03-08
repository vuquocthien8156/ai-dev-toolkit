# AI Dev Toolkit V3 - Dynamic Skill Architecture

## 1. Skill Registry (Sổ Điện Tử)

- [x] Create `rules/skill-registry.json` with categorized schemas.
- [x] Add specific `tech_stack` mappings to `skill-registry.json` (e.g., `"react-native": ["expo-app-design", "react-native-best-practices"]`).

## 2. Auto-Generation Engine (Workflow `/refresh-context`)

- [x] Scan the project's `package.json` to identify the tech stack (React, NestJS, Expo, etc.).
- [x] Use `npx skills find <tech_stack>` and query `skill-registry.json` using RAG to extract suitable skills and specific packages.
- [x] **Interactive Proposal (Suggest & Confirm):** Pause the workflow and propose the matched skills to the user for approval. Do NOT auto-generate the file yet.
- [x] Upon user's explicit confirmation, generate `.agent/setup.sh` by copying `scripts/setup-agent-template.sh` and injecting the approved skills list.

## 3. Dynamic Fetcher (`setup.sh` Execution)

- [ ] Upgrade script logic to use `npx skills` CLI instead of `git clone/pull`.
- [ ] Inject command `npx skills add <package_name> --global` for global skills to keep project clean.
- [ ] Inject command `npx skills add <package_name>` for project-specific skills.
- [ ] Inject command `npx skills update` to fetch the latest updates from official repos automatically.
- [ ] Remove logic that manually creates IDE symlinks (let the `npx skills` tool handle linking).

## 4. Verification & Testing

- [ ] Run the updated `/refresh-context` workflow in `hr-forte-mobile-v2` to verify it correctly auto-generates the new `setup.sh`.
- [ ] Run the generated `.agent/setup.sh` in the mobile project to verify it successfully clones missing skills and pulls updates for existing ones.
- [ ] Document lessons learned in `tasks/lessons.md`.
