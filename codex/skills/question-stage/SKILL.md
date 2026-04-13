---
name: question-stage
description: Asks the key questions a human must answer before codebase research begins. Use when the user wants clarifying questions, early scope definition, or asks you to narrow a task before researching.
---

# Question Stage

## Quick Start

Use this skill when the task is still fuzzy and the next useful step is to ask a small set of questions that changes what code, systems, or documents research should inspect.

If the task is already specific enough to research safely, say so and move to `$research-codebase` instead of manufacturing questions.
When this skill is the `Q` step in a QRDSPI flow, the output should leave the next step with a compact decisions handoff that targets research without carrying implementation opinions forward.
When this skill is part of a persisted workflow, use `artifact-management` so the resolved scope becomes the default handoff artifact rather than disposable chat text.

## Choose Your Approach

**The user referenced a local artifact**
Read that file completely before asking questions.

**The user referenced a Jira ticket**
If `managing-jira` is available, load the ticket first and ask questions from the ticket plus the user's request.

**The user gave only a brief task description**
Work from the task description alone and ask only the questions that materially change scope, research targets, or the definition of done.

## Instructions

- Start from the user's provided task description only
- If the input includes a local file path, read that file completely before asking questions
- If the input references a Jira ticket and `managing-jira` is available, use it before asking questions
- Do not research the codebase unless the user explicitly asks for research after answering
- Do not suggest implementations or preferred solutions
- Keep tradeoffs neutral
- Ask 3-7 questions total
- Each question must change where research should look, what system boundary matters, or what "done" means
- After the user answers, restate the decisions in a compact handoff with explicit research targets
- In a staged workflow, persist the resolved scope by default using `artifact-management`
- If the task is simple enough that no meaningful design decisions exist, say so directly and tell the user they can proceed to `$research-codebase`

## Workflow

1. Gather the input.
   - Use the task description as given.
   - If the task references a readable local file, read it fully.
   - If the task references a Jira ticket and `managing-jira` is available, load the ticket before drafting questions.
   - If the task depends on some other external document that is not available locally, ask the user to paste the relevant details instead of guessing.

2. Distill the task.
   - Write a one-sentence goal describing what "done" looks like.
   - Identify the decisions that materially affect what code, systems, or docs should be inspected next.
   - Identify likely out-of-scope boundaries.
   - Identify unknowns that research must answer rather than the user deciding now.

3. Ask the questions.
   - Present 3-7 concrete questions.
   - Give 2-3 plausible options per question when possible.
   - Phrase options as tradeoffs, not recommendations.
   - Prefer questions about ownership, target surface area, compatibility constraints, data boundaries, rollout scope, and non-goals.

4. Stop after presenting the questions.
   - Wait for the user's answers before researching the codebase or doing any later-stage work.

5. After the user answers, restate the resolved decisions.
   - Summarize the chosen direction under `Resolved Decisions`.
   - Confirm `Scope Boundaries` and explicit non-goals.
   - List `Research Targets` as objective areas to inspect, not proposed changes.
   - Name the next workflow step as `$research-codebase`.
   - In a staged workflow, locate or create the question artifact through `artifact-management`, update it in place on revisions, and return the artifact path.
   - For casual one-off help, inline output is enough if the user did not ask for persistence.

## Report

Use this format when asking questions:

```markdown
Based on [source], the goal is: **[one sentence]**.

Before I research the codebase, I need your input on these decisions:

**Q1.** [Decision that changes where work should look]
- Option A: [approach] - [tradeoff]
- Option B: [approach] - [tradeoff]

**Q2.** [Decision that changes where work should look]
- Option A: [approach] - [tradeoff]
- Option B: [approach] - [tradeoff]

**Scope boundaries**:
- Not doing: [out-of-scope item]

**Unknowns for research**:
- [question research must answer]

Once you answer these, I can target the research step precisely.
```

Use this format after the user answers:

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

- Proceed to `$research-codebase` using these research targets and boundaries.
```

## Examples

**Input:** "I need to add audit logging for admin actions."

**Output:**

```markdown
Based on your task description, the goal is: **capture a reliable record of meaningful admin actions without expanding scope beyond the intended surfaces**.

Before I research the codebase, I need your input on these decisions:

**Q1.** Which admin actions count for this first pass?
- Option A: Authentication and role changes only - narrower scope, faster validation
- Option B: All mutating admin actions - broader coverage, more surfaces to inspect

**Q2.** Where should audit records live?
- Option A: Existing application database - easier correlation, tighter schema coupling
- Option B: External logging pipeline - better separation, more integration points to inspect

**Q3.** Is this task backward-compatible only?
- Option A: No API or UI contract changes - research stays focused on internal wiring
- Option B: UI and API changes are allowed - research must include admin surfaces and client expectations

**Scope boundaries**:
- Not doing: end-user activity logging

**Unknowns for research**:
- Whether a shared event model or logging abstraction already exists

Once you answer these, I can target the research step precisely.
```

## Guidelines

- Prefer questions that remove entire branches of investigation
- Avoid asking for information that can be learned cheaply from later research
- Do not ask generic preference questions unless they affect scope or system boundaries
- If the user has already answered a decision implicitly, do not ask it again
- Keep the handoff obvious: after answers arrive, summarize the resolved decisions and name the next research target
- If you persisted the handoff, keep the topic slug and artifact path stable across later edits
