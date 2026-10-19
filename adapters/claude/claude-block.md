<!-- claude-setup:begin -->
## Core rules (managed by ai-dev-toolkit)

@~/.agents/AGENTS.md

## Model routing (managed by ai-dev-toolkit)

- Light read-only work (map repo, find call sites, look up API docs): delegate to the `search`, `grep`, or `docs` subagents (Haiku). Do not pass a `model` override when invoking them.
- Call the advisor (Opus) before finalizing a plan.
- Call the advisor when the same error repeats a second time.
- Call the advisor before reporting a task as done.
- In Bash, search code with `rg` instead of `grep -r` (keep `grep` for piped script/log output).
<!-- claude-setup:end -->
