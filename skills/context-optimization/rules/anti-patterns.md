# Anti-Patterns (What NOT to do)

Avoid these behaviors that rapidly consume context window tokens without providing proportional value.

## 1. Context Dumping

- **Pattern**: Automatically loading all files listed in an import statement before checking if they are needed.
- **Fix**: Use `progressive-disclosure.md`.

## 2. Just-In-Case Searching

- **Pattern**: Running broad `grep_search` commands across the entire `src/` directory for generic terms like "user" or "id".
- **Fix**: Narrow the search scope to specific modules or use more specific keywords like "calculateUserDiscount".

## 3. Re-reading Known Files

- **Pattern**: Calling `view_file` on `package.json` or `tsconfig.json` multiple times in a session.
- **Fix**: Read once, extract the key information, and rely on that summary. If you suspect an update, ask the user.

## 4. Giant Diffs

- **Pattern**: Replacing an entire 800-line file when only 3 lines changed.
- **Fix**: Always use the most precise editing tool available (`replace_file_content` with specific line numbers over full-file overwrites).
