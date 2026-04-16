---
name: simplify-code
description: Simplifies recently changed code without altering behavior. Use after implementation or refactoring when the goal is to reduce unnecessary complexity, noisy comments, and speculative abstractions while preserving exact functionality.
---

# Simplify Code

Use after code edits to make the result clearer, smaller, and easier to maintain without changing behavior.

Default scope:
- simplify the code changed in the current task unless the user broadens scope
- preserve exact behavior
- prefer clarity over terseness
- follow the surrounding style

## Core Rules

- Never change behavior.
- Every edit must earn its place through clearer reading or lower maintenance cost.
- Prefer explicit code over clever code.
- Remove speculative abstractions.

## Workflow

### 1. Keep scope tight

Prefer the files or sections changed in the current task. If scope is unclear, simplify only the touched area.

### 2. Simplify structure

Remove or reduce:
- unnecessary nesting
- indirection that hides the main path
- helpers or abstractions used only once
- generic naming that obscures intent
- conditionals that can be flattened safely
- repeated logic where one local extraction clarifies the code

### 3. Clean comments

Remove comments that:
- restate obvious code
- duplicate good naming
- are outdated or misleading

Keep comments that:
- explain why a choice exists
- clarify tricky algorithms
- document interface contracts
- warn about non-obvious behavior or edge cases

### 4. Remove YAGNI

Remove complexity that exists only for hypothetical future use:
- unused extension points
- defensive branches for impossible states
- generic wrappers around one concrete use case
- one-off abstractions that read worse than the inlined code

### 5. Verify behavior

Before finishing, confirm:
- inputs and outputs are unchanged
- side effects happen in the same circumstances
- tests still pass or still express the intended behavior

Run targeted tests when practical. If you cannot verify with tests, say so explicitly.

## Output

When reporting work, summarize:
- what was simplified
- what redundant or speculative code was removed
- what was verified and what was not

## Relationship To Other Skills

- Use `review-code` when the task is evaluation-only and should return findings instead of edits.
- Use broader refactoring workflows only when the user wants a larger redesign.
