---
name: thinking-patterns
description: Applies structured reasoning patterns that produce concise, auditable output artifacts. Use when the user asks to think through a problem, compare options, plan work, calculate precisely, verify a conclusion, or synthesize multiple inputs.
---

# Thinking Patterns

Use explicit reasoning patterns when the task benefits from a visible method rather than a single compressed answer.

The goal is not to expose private internal reasoning. The goal is to produce concise, user-visible artifacts such as step lists, option tables, outlines, calculations, verification passes, and synthesis notes that a human can inspect.

## Quick Start

Use this skill in one of three ways:

- Auto-select when the user says "think through this", "work through this", "compare these", "plan this", or otherwise asks for visible reasoning without naming a pattern.
- Respect explicit selection when the user names a pattern or alias such as `atomic`, `tree`, `skeleton`, `program`, `verify`, or `graph`.
- Escalate to `self-consistency` when the answer needs an explicit verification pass rather than just a structured first-pass analysis.

Default to the lightest pattern that makes the work easier to follow:

- Debugging or causal tracing: Chain of Thought
- Research or multi-hop understanding: Atomic Thought
- Comparing options or evaluating approaches: Tree of Thoughts
- Planning, outlining, or sequencing work: Skeleton of Thought
- Precise calculations or deterministic transformations: Program of Thoughts
- Double-checking a conclusion or high-stakes answer: Self-Consistency
- Merging several findings into one view: Graph of Thoughts

If two patterns are plausible, choose the one that reduces ambiguity earliest:

- Need facts before a decision: start with Atomic Thought
- Need options before a recommendation: start with Tree of Thoughts
- Need shape before details: start with Skeleton of Thought
- Need convergence after parallel work: finish with Graph of Thoughts

## Working Rules

- Produce concise external reasoning, not raw internal chain-of-thought
- Match the pattern to the task instead of defaulting to a long explanation
- Keep the output structured enough to audit and short enough to use
- Prefer explicit headings, numbered steps, compact tables, or checklists
- End with a clear conclusion, recommendation, or result
- Escalate to verification patterns when the stakes or uncertainty are high
- Treat aliases as first-class selectors, not informal hints
- Prefer one pattern unless a clear handoff between phases adds value

## Pattern Selection Guide

| Task Type | Pattern | Aliases | Use This When | Avoid This When |
| --- | --- | --- | --- | --- |
| Debugging, tracing, stepwise logic | Chain of Thought | `cot`, `chain` | Ordered dependencies drive the answer | Real alternatives must be explored first |
| Research, decomposition, multi-hop questions | Atomic Thought | `aot`, `atomic` | You need sub-questions before conclusions | A direct single-pass answer is already clear |
| Comparing approaches, design choices | Tree of Thoughts | `tot`, `tree` | Several valid options deserve evaluation | The path is already effectively decided |
| Planning, outlining, sequencing work | Skeleton of Thought | `sot`, `skeleton` | Structure should come before expansion | The task is too small for an outline |
| Calculations, formulas, data transforms | Program of Thoughts | `pot`, `program` | Precision matters more than mental math | The computation is trivial |
| Verification, validation, confidence check | Self-Consistency | `sc`, `verify` | The result should be checked independently | A first-pass answer is enough |
| Synthesis, integration, convergence | Graph of Thoughts | `got`, `graph` | Multiple inputs must become one view | Inputs can simply be listed side by side |

## Auto-Selection Heuristics

When the user does not name a pattern, choose in this order:

1. `program` if exact computation or deterministic transformation is central.
2. `self-consistency` if the user explicitly asks to verify, double-check, or be sure.
3. `skeleton` if the output should be a plan, outline, or phased structure.
4. `tree` if the main value is comparing options or selecting an approach.
5. `atomic` if the work depends on decomposing a question or research target.
6. `graph` if several existing findings need synthesis.
7. `chain` for sequential tracing, debugging, or causal explanation.

If uncertainty remains after that pass, name the likely candidates and choose the simpler one.

## Escalate To Self-Consistency

Escalate from another pattern into `self-consistency` when:

- The user asks for verification, a double-check, or a confidence read
- The answer will drive an irreversible, expensive, or high-risk action
- Multiple checks can be run cheaply relative to the cost of being wrong
- The initial reasoning path produced a conclusion that still feels brittle

Do not default to `self-consistency` for every task. Use it when verification is part of the job, not when it would only add ceremony.

## Workflow

1. Classify the task.
   - Is the main need tracing, decomposition, comparison, planning, computation, verification, or synthesis?
   - If the user named a pattern or alias, use that unless it clearly conflicts with the task.
   - If multiple patterns apply, pick the first pattern that reduces ambiguity.

2. Declare the structure.
   - Use a short heading or lead-in that signals the pattern.
   - Tell the user what artifact they will get, such as a trace, option set, outline, or verification pass.

3. Execute the pattern visibly.
   - Show only the reasoning structure the user needs to inspect the work.
   - Keep each step or branch concrete and relevant to the decision or result.

4. Conclude cleanly.
   - Summarize the answer, recommendation, or next action.
   - If confidence is limited, say what remains uncertain.

## Pattern Summaries

### Chain of Thought

Use for sequential reasoning, debugging, causal analysis, and stepwise walkthroughs.

- Aliases: `chain-of-thought`, `cot`, `chain`
- Output: Numbered steps with brief verification
- Best when: The answer depends on ordered dependencies
- Avoid when: Multiple competing approaches should be explored first
- Escalate to `self-consistency` when the trace will be used to justify a high-stakes conclusion

### Atomic Thought

Use for decomposing a question into smaller independent sub-questions before recombining the answers.

- Aliases: `atomic-thought`, `aot`, `atomic`
- Output: Dependency map, atomic answers, contracted conclusion
- Best when: The task spans multiple independent facts or subsystems
- Avoid when: A direct single-pass explanation is enough
- Escalate to `self-consistency` after contraction when the final conclusion needs independent validation

### Tree of Thoughts

Use for exploring multiple valid approaches before choosing one.

- Aliases: `tree-of-thoughts`, `tot`, `tree`
- Output: 2-4 approaches, evaluation, recommendation
- Best when: Trade-offs matter and the first idea may not be best
- Avoid when: The task is obviously linear or already decided
- Escalate to `self-consistency` when the chosen option carries high downside if selected incorrectly

### Skeleton of Thought

Use for structure-first planning.

- Aliases: `skeleton-of-thought`, `sot`, `skeleton`
- Output: High-level skeleton first, then expansion
- Best when: You need scope, phases, or sections before details
- Avoid when: The task is too small to justify an outline
- Escalate to `self-consistency` when the structure must be checked against hard constraints or dependencies

### Program of Thoughts

Use when precision matters more than mental arithmetic.

- Aliases: `program-of-thoughts`, `pot`, `program`
- Output: Short explanation, executable code, computed results
- Best when: Calculations, formulas, or deterministic transformations are involved
- Avoid when: The arithmetic is trivial
- Escalate to `self-consistency` when the computed result should be validated by an independent check or sanity bound

### Self-Consistency

Use for independent checks before finalizing a conclusion.

- Aliases: `self-consistency`, `sc`, `verify`
- Output: Multiple checks or perspectives, discrepancy handling, confidence statement
- Best when: The decision is high-impact or error-prone
- Avoid when: The cost of verification exceeds the value

### Graph of Thoughts

Use when several findings or partial solutions must become one coherent answer.

- Aliases: `graph-of-thoughts`, `got`, `graph`
- Output: Inputs, agreements, conflicts, resolution, synthesis
- Best when: Research, brainstorming, or parallel work needs convergence
- Avoid when: The inputs can simply be listed without integration
- Escalate to `self-consistency` when the final synthesis must survive independent scrutiny

## Composition Patterns

Combine patterns when the workflow naturally has phases:

- Research -> Synthesis: Atomic Thought -> Graph of Thoughts
- Planning -> Option selection: Skeleton of Thought -> Tree of Thoughts
- Implementation reasoning -> Verification: Chain or Program of Thoughts -> Self-Consistency
- Brainstorm -> Converge: Tree of Thoughts -> Graph of Thoughts

Use composition sparingly. If one pattern is enough, stop there.

## References

See [references/patterns.md](references/patterns.md) for fuller pattern definitions, process templates, and anti-patterns.

## Success Criteria

A thinking pattern is being used well when:

- The selected pattern fits the task
- The output is visibly structured and easy to audit
- The structure helps the user make or verify a decision
- The final answer is clear and shorter than the analysis needed to get there
