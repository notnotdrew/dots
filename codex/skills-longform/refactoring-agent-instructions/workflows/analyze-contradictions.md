# Phase 1: Analyze Contradictions

Scan all discovered agent-instruction files for conflicting, contradictory, or incompatible guidance.

## Inputs

- List of discovered instruction files
- Full content of each file

## Procedure

### 1. Build An Instruction Index

Extract individual instructions from every discovered file. An instruction is any directive that tells the agent what to do, how to behave, or what to produce.

For each instruction, record:
- source file and line range
- category such as style, testing, git, architecture, tooling, or workflow
- directive wording
- strength such as `MUST`, `SHOULD`, `prefer`, `avoid`, or `NEVER`

### 2. Cross-Reference For Conflicts

Compare instructions across files and within files. Look for:

| Type | Example |
| --- | --- |
| Direct contradiction | "Use tabs" vs "Use spaces" |
| Incompatible workflow | "Always write tests first" vs "Prototype before tests" |
| Conflicting tool preference | "Use npm" vs "Use yarn" |
| Style conflict | "Use semicolons" vs "No semicolons" |
| Scope overlap | Two files define the same behavior differently |
| Strength mismatch | "MUST use X" vs "Prefer Y over X" |

### 3. Present Contradictions

For each contradiction, present:

```markdown
### Contradiction: [Brief description]

**File A** (`path/to/file:line`)
> [Quoted instruction]

**File B** (`path/to/file:line`)
> [Quoted instruction]

**Conflict type**: [type]

**Resolution options**
1. Keep File A's version
2. Keep File B's version
3. Merge into: [proposed wording]
```

### 4. Record Resolutions

After the user resolves a contradiction, record:
- winner or merged version
- final wording
- destination category or root placement

## Outputs

- contradiction report
- resolved instruction set
- note that the content is ready for Phase 2

## Edge Cases

- No contradictions found: report that and continue
- Duplicate wording across files: treat as duplication for later pruning, not contradiction
- Unresolved contradiction: keep it visible and flag it before structural edits proceed
