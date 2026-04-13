---
name: simplify-code
description: Simplifies recently changed code without altering behavior. Use after implementation or refactoring when the goal is to reduce unnecessary complexity, noisy comments, and speculative abstractions while preserving exact functionality.
---

# Simplify Code

Use this skill after code edits to make the result clearer, smaller, and easier to maintain without changing behavior.

## Quick Start

Apply this skill when the user asks to:
- simplify code
- clean up a recent change
- remove unnecessary complexity
- polish edited files before review

Default scope:
- focus on the code changed in the current task unless the user broadens scope
- preserve exact behavior
- prefer clarity over terseness
- follow the surrounding codebase style rather than imposing a new one

## Core Rules

- Never change behavior.
- Earn every edit through better readability, consistency, or lower maintenance cost.
- Prefer explicit code over dense cleverness.
- Avoid nested ternaries when plain control flow is clearer.
- Remove speculative abstractions that solve future problems only.

## Workflow

### 1. Identify the simplification target

Prefer the files or sections changed in the current task. If scope is unclear, simplify only the touched area rather than broad surrounding code.

### 2. Simplify structure

Look for:
- unnecessary nesting
- indirection that hides the main path
- helpers or abstractions used only once
- generic naming that obscures intent
- conditionals or branching that can be flattened safely
- repeated logic where one local extraction would clarify the code

### 3. Clean comments

Remove comments that:
- restate obvious code
- duplicate good naming
- explain low-level implementation when a higher-level explanation would help more
- are outdated or misleading

Keep comments that:
- explain why a choice exists
- clarify tricky algorithms
- document interface contracts
- warn about non-obvious behavior or edge cases
- link to external design context

### 4. Check for YAGNI violations

Remove complexity that exists only for hypothetical future use:
- unused extension points
- "just in case" defensive branches for impossible states
- generic frameworks around single concrete use cases
- one-off abstractions that read worse than the inlined code

Principle: a little duplication is often cheaper than the wrong abstraction.

### 5. Verify preservation

Before finishing, confirm:
- inputs and outputs are unchanged
- side effects happen in the same circumstances
- tests still express the intended behavior

Run targeted tests when practical. If you cannot verify with tests, say so explicitly.

## Output

When reporting simplification work, summarize:

### Core Purpose

One sentence describing what the simplified code does.

### Changes Made

- structural simplifications
- comment cleanup
- removed speculative or redundant code

### Verification

- what was checked
- what was not verified

## Relationship To Other Skills

- Use `review-code` when the task is evaluation-only and should return findings instead of edits.
- Use broader refactoring workflows only when the user wants a larger redesign, code-smell analysis, or paradigm-specific refactoring mechanics.

## Bottom Line

Make the edited code easier to understand tomorrow than it was today, without changing what it does.
