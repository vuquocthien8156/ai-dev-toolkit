# Workflow Protocol — Deep Details

Reference for non-trivial tasks. Load when entering plan mode or verification.

---

## 1. Plan Mode Protocol

Enter plan mode for: 3+ steps, architectural decisions, or vague requirements.

- If something goes sideways → STOP and re-plan immediately.
- Plan MUST include:
  a. Problem Statement (2-3 sentences)
  b. Analysis: investigation results, root causes, options considered
  c. Proposed Changes: file-by-file with specific code snippets or diffs
  d. Task Checklist: granular items with clear acceptance criteria
  e. Verification Steps: exact commands to verify each change
- Format: tables for comparisons, code blocks for changes, mermaid for flows.
- Single Source of Truth: after user confirms a decision, IMMEDIATELY update the plan.
- Plans must be human-readable and self-contained — a different agent or session must be able to resume from the plan alone.

## 2. File Map Contract

MUST create before implementation when task touches 3+ files:

| Category | Files | Notes |
|----------|-------|-------|
| **MODIFY** | `path/to/file.ts` | What changes |
| **CREATE** | `path/to/new.ts` | Purpose |
| **READ** (context only) | `path/to/ref.ts` | Why reading |
| 🚫 **OFF-LIMITS** | `path/to/unrelated/` | Reason |

- Always use relative paths from project root (never absolute).
- The File Map is a strict contract. Do NOT modify files outside MODIFY/CREATE.

## 3. Gap Analysis Protocol

Before starting OR resuming execution of any plan:

a. Re-read the entire plan from top to bottom.
b. Check for: unanswered questions, unvalidated assumptions, missing edge cases, undefined error handling, missing dependencies.
c. Code-verifiable gaps → self-verify by reading code, searching symbols, checking types/imports. Do NOT ask the user what you can answer yourself from the codebase.
d. Business/product gaps → ask user.
e. If ANY unresolvable gap remains → STOP. List gaps explicitly and resolve before proceeding.
f. Proceed only after confirming: "Zero gaps remaining."

This applies to: new plans, resumed plans, and plans approved in previous conversations.

## 4. Verification Checklist

Before declaring ANY task complete:

a. Re-read the original plan/checklist.
b. Confirm EACH item is actually implemented (not just "addressed").
c. Run type check/lint ONLY on files you modified during this task. Errors in other files → ignore.
d. Define exact verification commands UPFRONT in the plan (not after the fact).
e. Red flags — STOP if you catch yourself saying: "should work", "probably passes", "likely fine", or trusting another agent's claim without own evidence.
f. If implementation is partial, EXPLICITLY state:
   - ✅ What IS done (with file list)
   - ❌ What is NOT done yet (with reasons)
   - NEVER say "done" or "complete" when items remain.
g. After ALL plan items done → auto-run verification workflow.

## 5. Root-Cause Priority (for debugging)

Every debug/fix plan MUST present solutions in this order:

a. 🏆 **Best Practice (Recommended)**: the expert-approved, architecturally sound solution. Research and cite best practices.
b. 📚 **Advanced/Reference**: solutions experts use but may not fit current architecture. Include for learning — explain WHY experts do it, WHEN it applies.
c. ⚡ **Pragmatic Solution**: a simpler path that still solves root cause, if (a) is too complex for current scope.
d. 🚨 **Workaround** (ONLY if no other option): clearly label as "CHEAT". Explain WHY it's a cheat, WHAT risks it carries, WHEN to revisit.

- Always root-cause first. Workaround = absolute last resort.
- Bug reports → fix autonomously. Point at logs, errors, failing tests → resolve. Zero hand-holding required from user.

## 6. Knowledge Routing

After every task, evaluate: "Is there knowledge worth preserving?"

- Business decisions & knowledge → `docs/modules/<module>/domains/` (Entity Pages)
- Patterns/conventions → project context files
- Repeatable processes → workflow definitions
- Only preserve if at least ONE criterion met:
  - Reusable across projects or modules (not one-off)
  - Counter-intuitive (someone would likely get it wrong)
  - Costly to rediscover (took significant debugging/research)
- If content is mostly noise → save NOTHING rather than weak knowledge.
- After corrections from user → capture the lesson in project docs.
