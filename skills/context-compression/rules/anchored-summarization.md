# Anchored Summarization

When a conversation is long, older messages naturally drop out of the context window. Summarization creates "anchors" that preserve critical knowledge.

## How to Anchor

Instead of a generic summary ("We worked on the payment module"), create structured anchors:

1. **Current Goal**: What is the exact task we are trying to finish right now?
2. **Key Decisions**: What technical choices did the user explicitly confirm?
3. **Crucial Constraints**: What roadblocks did we discover that we must avoid?
4. **Active Files**: Which exact file paths are we currently modifying?

## Where to Anchor

Do not just write the anchor in the chat (it will scroll away). Write the anchor to a permanent task file like `tasks/session-context.md` or `tasks/todo.md`.

_Example session-context.md anchor:_

```markdown
# Session State

- Goal: Fix duplicate Stripe invoices on plan upgrade.
- Decision: Use `voidAutoInvoice` flag dynamically instead of hardcoding.
- Constraint: Post-paid invoices must always maintain `billingCycleAnchor: 'unchanged'`.
- Active File: `src/modules/payment/services/stripe.service.ts`
```
