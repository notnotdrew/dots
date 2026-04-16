# Phase 1: Analyze Contradictions

Find instructions that cannot all be true at once.

## Inputs

- Discovered instruction files
- Full file contents

## Procedure

1. Extract each directive with source path, line range, category, and strength (`MUST`, `SHOULD`, `prefer`, `avoid`).
2. Compare directives across files and within files.
3. Flag:
   - direct contradictions
   - incompatible workflows
   - conflicting tool preferences
   - overlapping rules with different wording or strength
4. Present only conflicts that require a decision.

## Report Format

```markdown
### [Conflict]

- A: `path:line` - [instruction]
- B: `path:line` - [instruction]
- Type: [contradiction | workflow | tooling | style | strength]
- Options:
  1. Keep A
  2. Keep B
  3. Merge into: [wording]
```

## Output

- Contradiction report
- Resolved instruction set, or explicit unresolved items
