# Examples & Violations — Reference

Concrete examples of good and bad AI coding behavior. Load when needed for reinforcement.

---

## PART A — PERSONAL PROTOCOL EXAMPLES

### 1. Confirmation Protocol

❌ User says "có thể dùng X" → SUGGESTION, not confirmation. Ask: "Confirm dùng X?"
❌ User asks "tại sao Y?" → QUESTION, not confirmation. Answer first, then ask permission.
❌ User reviews plan without comment → NOT approval. Ask: "Approve plan này?"
❌ User says "hmm" or "đúng chưa nhỉ?" → DOUBT. Address the doubt first.
✅ Only apply after explicit: "yes", "OK", "confirm", "đồng ý", "apply đi"

### 2. Scope Violations

❌ "While I'm here, let me also fix..." — NO. Stay on target.
❌ Refactoring unrelated code during a bugfix
❌ Adding type hints/docstrings to code you didn't change
❌ Reformatting quotes, whitespace while fixing a bug
✅ Only change lines that fix the reported issue
✅ Match existing style: single quotes, no type hints, same spacing

### 3. Over-Engineering

❌ Strategy pattern + Factory + Interface for a single calculation
❌ Cache + Validator + Notification system when user just said "save preferences"
❌ Proposing 3 design options when user just wants it fixed
❌ "Flexibility" or "configurability" that wasn't requested
✅ One function. Add complexity when actually needed, not before.
✅ 50 lines > 200 lines if they solve the same problem.

### 4. Verification Red Flags

❌ "should work", "probably passes", "likely fine"
❌ Trusting another agent's claim without own evidence
❌ Checking only happy path, skipping edge cases
❌ Running partial tests (1 of N suites) and claiming "tests pass"
❌ Not checking exit codes after terminal commands
✅ State exact verification command and check full output
✅ Test both happy path and edge cases

### 5. Delegation Anti-Patterns

❌ Vague: "Research this codebase" → agent returns nothing useful
❌ Retrying same failed prompt to sub-agent
❌ Accepting sub-agent result without spot-checking
❌ Delegating simple tasks (read one file, grep one symbol) to sub-agents
✅ Specific: "Read src/auth/service.ts, list all exported functions with signatures"
✅ Include context: "We're debugging a login bug. The error is X. Check if function Y handles case Z."
✅ After vague result → switch to direct tools immediately

### 6. Context Drift & Architecture

❌ "Cleanup should run here" → 2 messages later: "actually no, it should run there" → TOO FAST
❌ Presenting conclusion without checking actual code or docs
❌ Proposing 3 different code paths → Ask user: "preferred approach?" first
❌ Jumping to implementation before user validates high-level design
✅ Think through edge cases FIRST, verify from code, state conclusion ONCE
✅ For architecture: ask user vision → then propose
✅ Verify facts from code/docs before stating them

---

## PART B — CODE EXAMPLES (Karpathy-inspired)

### 7. Think Before Coding — Hidden Assumptions

**User:** "Add a feature to export user data"

❌ **What LLMs do (wrong):**
```python
def export_users(format='json'):
    users = User.query.all()  # All users? Privacy?
    with open('users.json', 'w') as f:  # File location assumed
        json.dump([u.to_dict() for u in users], f)  # Fields assumed
```
Problems: Assumed ALL users, assumed file location, assumed which fields, assumed format.

✅ **What should happen:**
```
Before implementing, I need to clarify:
1. Scope: Export all users or filtered subset? (privacy implications)
2. Format: Download file? Background job? API endpoint?
3. Fields: Which user fields? (some might be sensitive)
4. Volume: How many users? (affects approach)
Simplest approach: paginated JSON API endpoint.
```

### 8. Think Before Coding — Multiple Interpretations

**User:** "Make the search faster"

❌ **What LLMs do:** Immediately add caching + indexes + async without asking which "faster" matters.

✅ **What should happen:**
```
"Make the search faster" could mean:
1. Faster response time → database indexes, cache frequent queries
2. Handle more concurrent searches → async, connection pooling
3. Faster perceived speed → show partial results, progressive loading
Current search: ~500ms. Which aspect matters most?
```

### 9. Simplicity First — Over-Abstraction

**User:** "Add a function to calculate discount"

❌ **What LLMs do:** Strategy pattern + DiscountConfig + DiscountCalculator = 40+ lines
```python
class DiscountStrategy(ABC):
    @abstractmethod
    def calculate(self, amount: float) -> float: pass

class PercentageDiscount(DiscountStrategy): ...
class FixedDiscount(DiscountStrategy): ...
class DiscountConfig: ...
class DiscountCalculator: ...
# 40+ lines of setup for a simple calculation
```

✅ **What should happen:**
```python
def calculate_discount(amount: float, percent: float) -> float:
    """Calculate discount amount. percent should be 0-100."""
    return amount * (percent / 100)
```
Add complexity when you actually need multiple discount types. Not before.

### 10. Simplicity First — Speculative Features

**User:** "Save user preferences to database"

❌ **What LLMs do:** PreferenceManager with cache, validator, merge, notification = 30+ lines

✅ **What should happen:**
```python
def save_preferences(db, user_id: int, preferences: dict):
    db.execute(
        "UPDATE users SET preferences = ? WHERE id = ?",
        (json.dumps(preferences), user_id)
    )
```
Add caching/validation/merging later — when the need actually appears.

### 11. Surgical Changes — Drive-by Refactoring

**User:** "Fix the bug where empty emails crash the validator"

❌ **What LLMs do:**
```diff
- # Check email format
+ """Validate user data."""               # Added docstring nobody asked for
+ if not email or '.' not in email:       # "Improved" validation beyond the fix
+ if len(username) < 3:                   # Added username validation nobody asked for
```

✅ **What should happen:**
```diff
  def validate_user(user_data):
      # Check email format
-     if not user_data.get('email'):
+     email = user_data.get('email', '')
+     if not email or not email.strip():
          raise ValueError("Email required")
```
Only changed: the specific lines that fix empty email handling.

### 12. Surgical Changes — Style Drift

**User:** "Add logging to the upload function"

❌ **What LLMs do:** Also change quote style, add type hints, add docstring, reformat whitespace.

✅ **What should happen:** Add logging lines only. Match existing style (single quotes, no type hints, same spacing pattern).

### 13. Goal-Driven Execution — Vague vs Verifiable

**User:** "Fix the authentication system"

❌ **Vague:** "I'll review the code, identify issues, make improvements, test changes."

✅ **Verifiable:**
```
What specific auth issue? If "users stay logged in after password change":
1. Write test: change password → verify old session invalidated → Verify: test fails
2. Implement: invalidate sessions on password change → Verify: test passes
3. Edge cases: multiple sessions, concurrent changes → Verify: additional tests pass
4. Regression: existing auth tests still pass → Verify: full suite green
```

### 14. Goal-Driven Execution — Test-First

**User:** "The sorting breaks when there are duplicate scores"

❌ **What LLMs do:** Immediately change sort logic without confirming the bug.

✅ **What should happen:**
```python
# 1. Write test that reproduces the issue
def test_sort_with_duplicate_scores():
    scores = [
        {'name': 'Alice', 'score': 100},
        {'name': 'Bob', 'score': 100},
        {'name': 'Charlie', 'score': 90},
    ]
    result = sort_scores(scores)
    # Verify: run 10 times, fails with inconsistent ordering

# 2. Fix with stable sort
def sort_scores(scores):
    return sorted(scores, key=lambda x: (-x['score'], x['name']))
    # Verify: test passes consistently
```

---

## PART C — ANTI-PATTERNS SUMMARY

| Principle | Anti-Pattern | Fix |
|-----------|-------------|-----|
| Think Before Coding | Silently assumes scope, format, fields | List assumptions, ask for clarification |
| Simplicity First | Abstract pattern for single-use code | One function until complexity is needed |
| Surgical Changes | Reformats + adds type hints during bugfix | Only change lines for the reported issue |
| Goal-Driven | "I'll review and improve the code" | "Write test for bug → make it pass → verify" |
| Ask Before Acting | Edits after user says "hmm" | Wait for explicit "yes/OK/confirm" |
| Plan With Precision | Generic plan name, no file map | Named plan + file map + gap analysis |
| Delegate | "Research this" to sub-agent | Specific deliverable + context + format |
