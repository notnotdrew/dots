---
name: analyzing-use-cases
description: Analyzes stories and acceptance criteria into structured use cases using Cockburn's framework. Use when preparing a story for implementation, expanding acceptance criteria into scenarios, decomposing behavior before planning, or when the user asks for use case analysis or scenario discovery.
---

# Analyzing Use Cases

Turn a story, ticket, or research artifact into a behavioral use case using Cockburn's framework.

The output should give planning and TDD skills a clear behavioral spine: main success scenario, extensions, preconditions, postconditions, acceptance-criteria coverage, and TDD mapping.

## Quick Start

1. Read the inputs fully.
2. Classify the goal level.
3. Extract scope, actors, and stakeholders.
4. Draft the main success scenario and extensions.
5. Define preconditions and postconditions.
6. Map acceptance criteria and TDD coverage.
7. Write the result with [templates/use-case-document.md](templates/use-case-document.md).

Load [references/cockburn-framework.md](references/cockburn-framework.md) for goal levels, step grammar, and extension discovery.

## When To Use

Use this skill when:

- research is complete but the behavior is still too loose for planning
- a Jira ticket or story needs scenario decomposition before coding
- acceptance criteria need expansion into concrete happy paths and failure modes
- the user asks for use case analysis, scenario discovery, or behavioral analysis
- a planned implementation needs a better test-discovery surface

Use another skill when:

- the request is still too ambiguous to research safely; use `question-stage` first
- the story is really an epic that needs slicing; use `slicing-elephant-carpaccio` first
- the work is already at detailed plan-implementation level

## Workflow

1. Read all provided story, ticket, artifact, and research inputs fully before drafting.
2. If the request references Jira issues such as `ABC-123`, use `managing-jira` first.
3. If a research artifact already exists, treat it as a hard input instead of re-researching from scratch.
4. If the story is still materially ambiguous after reading, stop and ask the minimum question needed before analysis.

Classify with Cockburn's hierarchy and present the evidence:

- `☁️ Summary`: too broad; hand off to `slicing-elephant-carpaccio`
- `🌊 User-goal`: correct scope; continue
- `🐟 Subfunction`: identify the parent goal before continuing

Then extract:

- scope
- primary actor
- supporting actors
- stakeholders and interests justified by the inputs

Draft the main success scenario as numbered actor/system steps. Keep it observable, technology-neutral, and consistent in granularity.

Add extensions at the step where the flow changes. Use notation such as `2a` and make the outcome explicit: resume, loop, branch, or end.

Define:

- preconditions
- success guarantees
- minimum guarantees

Finish by checking that every acceptance criterion maps to the use case and every major path has a concrete test target.

Use [templates/use-case-document.md](templates/use-case-document.md) for the final structure. Persist only when the workflow already uses durable artifacts or the user asks for it; use `artifact-management` to place the sidecar correctly.

## Casual Vs Fully Dressed

Use **casual** by default for one actor and a small set of extensions.

Use **fully dressed** when the work includes:

- multiple actors or external systems
- security, compliance, or payment concerns
- non-obvious stakeholder interests
- complex recovery paths or failure handling

## Skill Handoffs

- `question-stage`: the request is still too ambiguous for analysis
- `managing-jira`: the source of truth is a Jira ticket
- `slicing-elephant-carpaccio`: the story is summary-level and too broad
- `research-codebase`: the behavior depends on current code reality not yet captured in artifacts
- `plan-implementation`: the use case is approved and needs a concrete execution plan
- `planning-tdd` or `practicing-tdd`: turn the scenario and extensions into a test-first implementation sequence
