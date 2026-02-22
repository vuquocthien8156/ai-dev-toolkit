# Lessons Learned

## 2026-02-22: /init-project merge approach

**Lesson**: `/init-project` update mode must MERGE, never override.
Human-added knowledge always has higher value than auto-scan results.

**Rule**: All existing knowledge = valuable. Scan only SUPPLEMENTS, never replaces.
If scan finds conflict (e.g. old version ≠ new version), show both and ask user.

**Implementation**:

- `<!-- AUTO-GENERATED -->` sections → merge (add new, update versions, never delete)
- `<!-- PRESERVED -->` sections → never touch
- Unmarked sections → show diff, ask user (could be human-added)

**Source**: Real-world testing in `hr-leave-module` project revealed that simple
overwrite/skip modes lose valuable human context. The scan→buffer→diff→confirm
flow ensures no knowledge is lost.
