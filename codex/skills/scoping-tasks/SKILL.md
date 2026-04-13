---
name: scoping-tasks
description: Surfaces the key decisions a human must make before codebase research or implementation begins. Use when the user wants clarifying questions, early scope definition, or asks you to narrow a task before researching.
---

# Scoping Tasks

## Quick Start

Use this skill when the task is still fuzzy and the next useful step is to ask a small set of questions that changes what should be researched or built.

If the task is already specific enough to research or implement safely, say so and move to the next workflow step instead of manufacturing questions.

## Choose Your Approach

**The user referenced a local artifact**
Read that file completely before asking questions.

**The user gave only a brief task description**
Work from the task description alone and ask only the questions that materially change scope, research targets, or the definition of done.

## Instructions

- Start from the user's provided task description only
- If the input includes a local file path, read that file completely before asking questions
- Do not research the codebase unless the user explicitly asks for research after answering
- Do not suggest implementations or preferred solutions
- Keep tradeoffs neutral
- Ask 3-7 questions total
- Each question must change where research should look, what system boundary matters, or what "done" means
- If the task is simple enough that no meaningful design decisions exist, say so directly and tell the user they can proceed to research or implementation

## Workflow

1. Gather the input.
   - Use the task description as given.
   - If the task references a readable local file, read it fully.
   - If the task depends on an external ticket or document that is not available locally, ask the user to paste the relevant details instead of guessing.

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
   - Wait for the user's answers before researching, planning, or implementing.

5. After the user answers, restate the resolved decisions.
   - Summarize the chosen direction.
   - Confirm scope boundaries.
   - List the research targets or implementation areas implied by those decisions.
   - Save an artifact only if the user asks for one or the current workflow already expects written artifacts.

## Report

Use this format when asking questions:

```markdown
Based on [source], the goal is: **[one sentence]**.

Before I research or implement, I need your input on these decisions:

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

Once you answer these, I can target the next step precisely.
```

## Examples

**Input:** "I need to add audit logging for admin actions."

**Output:**

```markdown
Based on your task description, the goal is: **capture a reliable record of meaningful admin actions without expanding scope beyond the intended surfaces**.

Before I research or implement, I need your input on these decisions:

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

Once you answer these, I can target the next step precisely.
```

## Guidelines

- Prefer questions that remove entire branches of investigation
- Avoid asking for information that can be learned cheaply from later research
- Do not ask generic preference questions unless they affect scope or system boundaries
- If the user has already answered a decision implicitly, do not ask it again
- Keep the handoff obvious: after answers arrive, summarize the resolved decisions and name the next research or implementation target
