---
description: Technical investigation before committing to an approach. Research-only, no production code changes.
---

0. Read project-context SKILL.md for existing architecture and constraints.

1. Clarify the investigation question with user:
   - What are we trying to learn?
   - What are the constraints?
   - What defines success?

2. Research:
   - Search official docs, APIs, existing codebase
   - Create proof-of-concept in `/tmp/` only — NEVER in project source
   - Test feasibility with minimal code

3. Document findings in `docs/_guides/spike-<topic>.md`:
   - **Question**: What we investigated
   - **Findings**: What we learned (with code samples)
   - **Recommendation**: Proposed approach
   - **Trade-offs**: Pros/cons of alternatives
   - **Effort estimate**: Rough complexity

4. Present conclusion:
   - ✅ Feasible — ready to implement with approach X
   - ⚠️ Feasible with caveats — works but need to handle Y
   - ❌ Not feasible — alternatives: A, B

5. Do NOT modify project source code. Spike = research only.
