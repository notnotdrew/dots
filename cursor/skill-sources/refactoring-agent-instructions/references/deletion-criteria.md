# Deletion Criteria

Criteria for identifying instructions that should be flagged for removal. Every flagged item requires user approval before deletion.

## Category 1: Agent Already Knows

Instructions that restate behavior a competent coding agent will already exhibit by default. These waste tokens without changing behavior.

Flag when the instruction:
- says "write clean code", "be thorough", or "think carefully"
- says "follow best practices" without naming the practices
- tells the agent to understand the code before editing it
- restates how standard tools work
- tells the agent to use normal engineering judgment without a project-specific override

Examples to DELETE:
- "Write clean, maintainable code"
- "Make sure to handle edge cases"
- "Think step by step"
- "Read existing code before modifying it"
- "Follow the DRY principle"

Examples to KEEP:
- "Use snake_case for all database columns"
- "Retry timeouts 3 times with exponential backoff"
- "Use Zod for runtime validation at API boundaries"

## Category 2: Too Vague

Instructions that are not actionable because they do not specify what behavior should change.

Flag when the instruction:
- uses words like "appropriate", "good", "proper", or "suitable" without defining them
- says "follow best practices" without listing the practices
- could mean different things to different reviewers
- would not materially change the agent's output if removed

Examples to DELETE or REWRITE:
- "Follow best practices"
- "Use appropriate error handling"
- "Write good tests"
- "Keep code organized"

## Category 3: Overly Obvious

Instructions that any competent developer would follow in normal professional work.

Flag when the instruction:
- states something universal and baseline
- adds no project-specific guidance
- would not help the agent choose between two plausible approaches

Examples to DELETE:
- "Test your code before committing"
- "Use version control"
- "Review your changes before submitting"
- "Make sure the code compiles"
- "Do not introduce syntax errors"

## Category 4: Duplicates Built-In Behavior

Instructions that merely restate what the toolchain, repo automation, or the agent's default workflow already enforces.

Flag when the instruction:
- restates default tooling behavior
- repeats automated formatting or linting rules already enforced elsewhere
- duplicates pre-commit, CI, or editor automation without adding a meaningful override

Examples to DELETE:
- "Use git for version control"
- "Format code with Prettier" when formatting is already automated
- "Run the linter before committing" when hooks or CI already enforce it

## Category 5: Outdated

Instructions referencing deprecated tools, old versions, or patterns the codebase no longer uses.

Flag when the instruction:
- references replaced dependencies or commands
- describes a pattern that conflicts with the current codebase
- assumes older repo structure or old conventions

Only flag this category when the current project provides evidence that the instruction is stale.

## Category 6: Aspirational

Instructions that describe an ideal state rather than a concrete, verifiable rule.

Flag when the instruction:
- uses "strive for", "aim to", "ideally", or "when possible"
- describes a goal instead of an operational rule
- cannot be objectively checked

Examples to DELETE or REWRITE:
- "Strive for 100% test coverage"
- "Aim for small functions"
- "Try to keep PRs small"

## Presentation Format

When flagging items, use this structure:

```markdown
**"[Quoted instruction]"** (from [file:line])
- Category: [Agent Already Knows | Too Vague | Overly Obvious | Duplicates Built-In | Outdated | Aspirational]
- Why: [One sentence explaining why it adds no value]
- Recommendation: DELETE | REWRITE as: "[specific replacement]"
```

## Decision Rule

When unsure whether to flag an instruction:
- If removing it would not change agent behavior, flag it
- If removing it would change behavior, keep it
- When in doubt, keep it and let the user decide
