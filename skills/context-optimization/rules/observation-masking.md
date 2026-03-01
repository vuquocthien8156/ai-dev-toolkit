# Observation Masking

The way you structure your internal thoughts and observations directly affects token usage and context window clarity.

## The Verbosity Problem

When reasoning about complex code, dumping the entire output of commands or full function bodies into your thought process burns tokens rapidly. It creates noise for both you and the user.

## The Masking Solution

1. **Summarize over Repeating**: Instead of writing "The function `calculateTax` looks like this: `...`", write "The `calculateTax` function handles rate tiers and returns a float."
2. **Reference over Inclusion**: Use file paths and line numbers instead of copying code snippets when proposing changes. E.g., "I will modify `src/utils.ts` at line 45 to address the null check."
3. **Truncate Outputs**: When dealing with large command outputs, focus only on the error message or relevant segment. Do not summarize the entire 500-line build log.

By masking verbose observations, you preserve the context window for high-value reasoning.
