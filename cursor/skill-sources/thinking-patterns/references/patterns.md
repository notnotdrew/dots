# Thinking Patterns Reference

This reference defines each thinking pattern in Codex-native terms. Each pattern should produce concise, inspectable output artifacts rather than private raw reasoning.

## Invocation Rules

- If the user names a pattern or alias, use that pattern directly unless it plainly conflicts with the task.
- If the user asks to "think through" something without naming a pattern, auto-select the lightest pattern that reduces ambiguity.
- If the initial pattern reaches a conclusion that still needs confidence, escalate to Self-Consistency instead of stretching the first pattern beyond its job.

## Auto-Selection Defaults

Use this priority order when no explicit pattern is named:

1. Program of Thoughts for exact computation or deterministic transformation
2. Self-Consistency for explicit verification requests
3. Skeleton of Thought for plans, outlines, and phased structures
4. Tree of Thoughts for option selection and design trade-offs
5. Atomic Thought for research and decomposition
6. Graph of Thoughts for synthesis across existing inputs
7. Chain of Thought for sequential tracing and causal walkthroughs

## Chain of Thought (CoT)

Linear reasoning with explicit intermediate steps.

### Aliases

`chain-of-thought`, `cot`, `chain`

### Use When

- Debugging code or tracing execution flow
- Walking through a process with ordered dependencies
- Explaining a causal chain
- Solving stepwise logic where each step depends on the previous one

### Output Commitment

Produce:

- A numbered step trace
- The key state, assumption, or transition in each step
- A brief verification against the original question

Do not dump every possible thought. Show only the steps needed to make the conclusion inspectable.

### Process

1. Restate the problem briefly.
2. Identify what is known and what must be determined.
3. Break the work into sequential steps.
4. Execute each step visibly.
5. Verify the result against the original goal.

### Anti-Patterns

- Using it when the real need is exploring alternatives
- Producing long, low-signal traces
- Skipping the verification step

### Escalate To Self-Consistency When

- The trace supports a high-stakes decision
- The user asks for a double-check after the walkthrough
- Hidden edge cases could invalidate an otherwise clean sequence

## Atomic Thought (AoT)

Break the problem into independent atomic sub-questions, answer those, then contract the answers into a final conclusion.

### Aliases

`atomic-thought`, `aot`, `atomic`

### Use When

- Researching before planning or implementation
- Answering questions that span multiple knowledge areas
- Investigating a topic where sub-questions have clear dependencies

### Output Commitment

Produce:

- A compact dependency map of sub-questions
- Answers to the leaf questions
- A contracted final answer that shows how the pieces came together

### Process

1. Decompose the question into sub-questions.
2. Mark dependencies between them.
3. Answer the independent leaf questions first.
4. Contract those answers into the parent question.
5. Repeat until the original question becomes directly answerable.

### Anti-Patterns

- Using it for simple single-hop questions
- Keeping an ever-growing running narrative instead of contracting findings
- Creating fake dependencies between unrelated sub-questions

### Escalate To Self-Consistency When

- The contracted conclusion will drive a consequential recommendation
- Several leaf answers are uncertain enough that a second validation pass is warranted

## Tree of Thoughts (ToT)

Explore several candidate approaches, evaluate them, then choose the best path.

### Aliases

`tree-of-thoughts`, `tot`, `tree`

### Use When

- Comparing implementation approaches
- Evaluating design trade-offs
- Brainstorming where the first idea may not be best
- Selecting between multiple valid paths

### Output Commitment

Produce:

- Two to four distinct approaches
- A brief evaluation of each approach
- A recommendation with reasons

### Process

1. Frame the decision.
2. Generate two to four materially different approaches.
3. Evaluate each for feasibility, progress, reversibility, and risk.
4. Expand the strongest option or two.
5. Choose a recommendation, or report that no option is strong enough yet.

### Anti-Patterns

- Using it for clearly linear tasks
- Generating too many branches to evaluate well
- Presenting options without a recommendation when one is warranted

### Escalate To Self-Consistency When

- The recommended option has significant downside if wrong
- Two leading options remain close after evaluation

## Skeleton of Thought (SoT)

Generate structure first, then expand it.

### Aliases

`skeleton-of-thought`, `sot`, `skeleton`

### Use When

- Planning implementation work
- Producing outlines, roadmaps, or phased plans
- Structuring complex responses before filling in details

### Output Commitment

Produce:

- Phase 1: a skeleton only
- Phase 2: targeted expansion of each skeleton point

Keep the boundary between structure and expansion explicit.

### Process

1. Identify the major sections, phases, or components.
2. Put them in dependency order.
3. Validate the skeleton covers the scope.
4. Expand each point without drifting beyond its slot in the structure.

### Anti-Patterns

- Expanding during the skeleton phase
- Making the skeleton too vague to guide the work
- Ignoring dependencies between sections

### Escalate To Self-Consistency When

- The outline must satisfy hard sequencing or dependency constraints
- The plan will be handed off and ambiguity would be costly

## Program of Thoughts (PoT)

Use code execution for precise computation while keeping the surrounding reasoning human-readable.

### Aliases

`program-of-thoughts`, `pot`, `program`

### Use When

- Multi-step arithmetic or formula work
- Financial, statistical, or data-processing calculations
- Deterministic transformations where exactness matters

### Output Commitment

Produce:

- A short explanation of the approach
- Executable code with clear variable names
- The computed result with interpretation

### Process

1. Identify what must be computed.
2. Translate the logic into executable code.
3. Run the code.
4. Present the results and explain what they mean.

### Anti-Patterns

- Using code for trivial arithmetic
- Showing code without tying it back to the question
- Forgetting to interpret the result

### Escalate To Self-Consistency When

- The computed output should be checked by an independent formula, sanity bound, or alternate implementation
- Small arithmetic or transformation errors would materially change the decision

## Self-Consistency

Use multiple independent checks or perspectives to validate an answer.

### Aliases

`self-consistency`, `sc`, `verify`

### Use When

- The answer is high-stakes
- The user asks for verification or a double-check
- Edge cases are likely
- Confidence matters as much as the conclusion

### Output Commitment

Produce:

- Three to five independent checks or perspectives
- The result from each
- A consensus or discrepancy analysis
- A confidence statement

### Process

1. Choose multiple genuinely different checks.
2. Run them independently.
3. Compare their results.
4. Investigate discrepancies.
5. Report the final conclusion and confidence.

### Anti-Patterns

- Rephrasing the same check several times
- Hiding disagreements
- Running more checks than the task justifies

### Prefer This Pattern When

- Verification is explicitly part of the user's request
- The cost of being wrong is larger than the cost of running multiple checks
- Another pattern produced a recommendation that still needs confidence

## Graph of Thoughts (GoT)

Integrate several inputs into one coherent synthesis.

### Aliases

`graph-of-thoughts`, `got`, `graph`

### Use When

- Synthesizing research from multiple sources
- Combining brainstormed ideas into a plan
- Converging on one answer after parallel exploration
- Reconciling partial solutions or findings

### Output Commitment

Produce:

- The key insight from each input
- Agreements and conflicts
- Conflict resolution or unresolved tensions
- A unified synthesis with provenance

### Process

1. Identify the inputs that need integration.
2. Extract the important insight from each.
3. Align compatible findings.
4. Call out conflicts and resolve them where possible.
5. Produce a coherent synthesis and note remaining uncertainty.

### Anti-Patterns

- Listing inputs without integrating them
- Forcing a false synthesis when the inputs genuinely conflict
- Losing track of which source contributed which idea

### Escalate To Self-Consistency When

- The synthesis will be used as a final recommendation rather than a working summary
- Conflicts were resolved by judgment calls that should be independently challenged
