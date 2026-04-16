# Thinking Patterns Reference

Use the named pattern directly when the user selects it. Otherwise, choose the lightest pattern that makes the work inspectable. If the result still needs confidence, finish with `self-consistency`.

Default order: `program`, `verify`, `skeleton`, `tree`, `atomic`, `graph`, `chain`.

## Chain of Thought

- Aliases: `chain-of-thought`, `cot`, `chain`
- Use when: the answer depends on ordered steps or causal flow
- Output: short numbered trace, then conclusion
- Avoid when: the real task is comparing options

## Atomic Thought

- Aliases: `atomic-thought`, `aot`, `atomic`
- Use when: the question needs decomposition before it can be answered
- Output: sub-questions, leaf answers, contracted conclusion
- Avoid when: a direct answer is already clear

## Tree of Thoughts

- Aliases: `tree-of-thoughts`, `tot`, `tree`
- Use when: several real options deserve comparison
- Output: two to four approaches, evaluation, recommendation
- Avoid when: the path is already decided

## Skeleton of Thought

- Aliases: `skeleton-of-thought`, `sot`, `skeleton`
- Use when: structure should come before detail
- Output: outline or phases first, then brief expansion
- Avoid when: the task is too small for an outline

## Program of Thoughts

- Aliases: `program-of-thoughts`, `pot`, `program`
- Use when: exact computation or deterministic transformation matters
- Output: short setup, executable code, result
- Avoid when: the computation is trivial

## Self-Consistency

- Aliases: `self-consistency`, `sc`, `verify`
- Use when: verification is part of the job
- Output: independent checks, discrepancies, confidence
- Avoid when: extra checking adds ceremony without value

## Graph of Thoughts

- Aliases: `graph-of-thoughts`, `got`, `graph`
- Use when: several findings must become one answer
- Output: key inputs, agreements, conflicts, synthesis
- Avoid when: inputs can just be listed

## Good Use

- Pick one pattern.
- State the artifact up front.
- Keep the structure visible and short.
- End with a result, recommendation, or next action.

## Simple Compositions

- Research -> synthesize: `atomic` -> `graph`
- Plan -> compare: `skeleton` -> `tree`
- Reason -> verify: `chain` or `program` -> `verify`
