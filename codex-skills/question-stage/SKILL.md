---
name: question-stage
description: Asks the key questions a human must answer before codebase research begins. Use when the user wants clarifying questions, early scope definition, or asks you to narrow a task before researching.
---

# Question Stage

Use this skill when the task is still underspecified and the next useful step is to ask a small set of questions that changes what research should inspect.

If the task is already specific enough to research safely, skip this skill and move to `$research-codebase`.

## Read First

- Use the task description as given.
- If the input includes a local file path, read it fully before asking questions.
- If the input references a Jira ticket and `managing-jira` is available, load it first.
- If a required external document is missing, ask the user to paste the relevant parts.

## Rules

- Do not research the codebase yet unless the user explicitly asks for it.
- Do not suggest implementations or preferred solutions.
- Keep tradeoffs neutral.
- Ask 3-7 questions.
- Ask only questions that change research targets, system boundaries, or the definition of done.
- If no meaningful decisions remain, say so directly and point to `$research-codebase`.
- When this is part of a persisted workflow, use `artifact-management` and keep the handoff stable across revisions.

## Workflow

1. Distill the task into:
   - one-sentence goal
   - decisions the user must make now
   - likely scope boundaries
   - unknowns that research should answer later
2. Ask 3-7 concrete questions.
   - Give 2-3 plausible options when useful.
   - Frame options as tradeoffs, not recommendations.
3. Stop and wait for answers.
4. After the user answers, return a compact handoff:
   - `Resolved Decisions`
   - `Scope Boundaries`
   - `Research Targets`
   - next step: `$research-codebase`

## Output

When asking questions:

```markdown
Based on [source], the goal is: **[one sentence]**.

Before I research the codebase, I need your input on these decisions:

**Q1.** [decision]
- Option A: [approach] - [tradeoff]
- Option B: [approach] - [tradeoff]

**Q2.** [decision]
- Option A: [approach] - [tradeoff]
- Option B: [approach] - [tradeoff]

**Scope boundaries**:
- Not doing: [out-of-scope item]

**Unknowns for research**:
- [question research should answer]
```

After the user answers:

```markdown
## Resolved Scope

**Goal**: [one sentence]

## Resolved Decisions

- [decision] -> [chosen direction]

## Scope Boundaries

- In scope: [boundary]
- Not doing: [explicit non-goal]

## Research Targets

- [code area, interface, workflow, or document to inspect]

## Next Step

- Proceed to `$research-codebase` using these boundaries and targets.
```
