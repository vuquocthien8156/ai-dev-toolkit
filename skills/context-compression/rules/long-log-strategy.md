# Long Log Strategy

When handling compiler errors, test failures, or massive server logs, dumping the full text directly into the chat consumes massive token blocks.

## The 4-Step Processing Loop

1. **Extract TAIL**: Instead of reading the whole log, start with the last 50 lines. The actual error condition is almost always at the end. Use a tool to read just those lines if possible.
2. **Search Keywords**: Use `grep_search` on the log file targeting specific keywords:
   - "Error"
   - "Exception"
   - "Failed"
   - Your known problematic file name
3. **Isolate Stack Trace**: Locate the first occurrence of user-written code in the stack trace. Ignore the 30 frames of framework internals (`node_modules`, `src/core/`).
4. **Summarize**: Only present the exact error message and the exact line of user code causing it. Drop all other logging noise.

_Example summary:_

> "The log shows a `TypeError: undefined is not a function` originating from `src/modules/payment/stripe.service.ts` line 45. All preceding lines are framework startup noise."
