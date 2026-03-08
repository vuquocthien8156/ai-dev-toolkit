# Lessons Learned

## 2026-03-01: setup.sh Overwrite Bug (CRITICAL)

**What happened:** The `/refresh-context` workflow's Step 11 instructed the AI to "copy template to `.agent/setup.sh`". The AI interpreted this literally and OVERWROTE the entire 107-line setup.sh (containing IDE symlinks, Git tracking, scaffolding logic) with a new 37-line file containing only `echo` statements. This happened TWICE.

**Root cause:** Step 11 lacked:

1. A check for existing file before writing
2. Explicit MERGE semantics (only modify `REQUIRED_SKILLS` array)
3. Error handling for `npx skills` failures (AI generated a "fallback" script instead of stopping)

**Fix applied:**

- Added `.agent/setup.sh` to the Merge Rules table with `MERGE ONLY` behavior
- Rewrote Step 11 with `🚨 ABSOLUTE RULE: NEVER OVERWRITE` header
- Specified exact tool to use: `replace_file_content` on `REQUIRED_SKILLS=(...)` array only
- Added fallback: if no `REQUIRED_SKILLS` array found, DO NOT TOUCH THE FILE

**Pattern to remember:** When a workflow touches user-maintained files, always:

1. Check if file exists first
2. Default to MERGE, never OVERWRITE
3. If external CLI fails, STOP and REPORT — never generate fallback content
