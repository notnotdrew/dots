---
name: thinking-patterns
description: Applies structured reasoning patterns that produce concise, auditable output artifacts. Use when the user asks to think through a problem, compare options, plan work, calculate precisely, verify a conclusion, or synthesize multiple inputs.
---

# Thinking Patterns

Use a named pattern when visible structure helps more than a plain answer.

Goal: produce a short artifact the user can inspect. Do not expose raw internal reasoning.

## Choose A Pattern

Use the lightest pattern that removes ambiguity.

| Need | Pattern | Aliases |
| --- | --- | --- |
| Trace a sequence | Chain of Thought | `cot`, `chain` |
| Break a question apart | Atomic Thought | `aot`, `atomic` |
| Compare options | Tree of Thoughts | `tot`, `tree` |
| Plan or outline | Skeleton of Thought | `sot`, `skeleton` |
| Compute exactly | Program of Thoughts | `pot`, `program` |
| Verify a result | Self-Consistency | `sc`, `verify` |
| Merge findings | Graph of Thoughts | `got`, `graph` |

Default order when the user does not choose: `program`, `verify`, `skeleton`, `tree`, `atomic`, `graph`, `chain`.

## Workflow

1. Pick the pattern.
2. State the artifact: trace, options, outline, calculation, check, or synthesis.
3. Show only the structure needed to audit the result.
4. End with a conclusion, recommendation, or next action.

## Rules

- Stay concise.
- Prefer one pattern.
- Escalate to `self-consistency` when verification matters.
- If one pattern is not enough, compose once, then stop.

Reference: [references/patterns.md](references/patterns.md)
