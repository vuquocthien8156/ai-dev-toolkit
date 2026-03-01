# Progressive Disclosure

When investigating a complex component or bug, reveal information in layers, stopping as soon as you have enough context to proceed.

## The Disclosure Hierarchy

1. **Signatures**: What are the inputs/outputs? (Use `view_file_outline`)
2. **Implementation**: What is the immediate logic? (Use `view_code_item`)
3. **Dependencies**: What does this logic rely on? (Search imports, then repeat steps 1-2 on deps)
4. **Context**: How does this fit into the file/module? (Read surrounding lines with `view_file`)
5. **Full State**: (Last resort) Load the entire file.

## Why this matters

Loading a 1000-line file to check a 5-line function pushes out other critical context (like the user's original request or the current implementation plan). Progressive disclosure protects your short-term memory.
