# Search-Outline-Target Pattern

The most token-efficient way to explore a new codebase. Never load full files during initial discovery.

## 1. Search (Broad discovery)

Use `list_dir` to understand general structure, or `grep_search` with keywords.
`grep_search` is excellent because it returns single lines of context, not full files.

## 2. Outline (Contextual understanding)

Once you find candidate files, DO NOT view them yet.
Use `view_file_outline` to see the classes, methods, and structure.
This provides 80% of the understanding for 10% of the token cost.

## 3. Target (Precision reading)

Use `view_code_item` to read ONLY the specific function or class you identified from the outline.
Only use `view_file` (with StartLine/EndLine) if you need the exact implementation details bridging multiple functions.
Never use `view_file` without line numbers unless the file is very small (< 100 lines).
