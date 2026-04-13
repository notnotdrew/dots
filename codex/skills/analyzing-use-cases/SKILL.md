---
name: analyzing-use-cases
description: Analyzes stories and acceptance criteria into structured use cases using Cockburn's framework. Use when preparing a story for implementation, expanding acceptance criteria into scenarios, decomposing behavior before planning, or when the user asks for use case analysis or scenario discovery.
---

# Analyzing Use Cases

Turn a story, ticket, or research artifact into a behavioral specification using Alistair Cockburn's use case framework.

The output is a use case document with a main success scenario, extensions, preconditions, postconditions, acceptance-criteria coverage, and TDD mapping. It should give `implementation-plan`, `planning-tdd`, or `practicing-tdd` a behavioral spine instead of forcing them to infer one from a loose story.

## Quick Start

Given a story, ticket, or approved research artifact:

1. Read every provided input fully.
2. Classify the goal level.
3. Identify the system boundary, actors, and stakeholders.
4. Draft the main success scenario as numbered actor/system steps.
5. Discover extensions at each step.
6. Define preconditions and postconditions.
7. Cross-check every acceptance criterion.
8. Write the final use case with [templates/use-case-document.md](templates/use-case-document.md).

For goal levels, step grammar, and extension heuristics, load [references/cockburn-framework.md](references/cockburn-framework.md).

## When To Use

Use this skill when:

- research is complete but the behavior is still too loose for planning
- a Jira ticket or story needs scenario decomposition before coding
- acceptance criteria need expansion into concrete happy paths and failure modes
- the user asks for use case analysis, scenario discovery, or behavioral analysis
- a planned implementation needs a better test-discovery surface

Do not use this skill when:

- the request is still too ambiguous to research safely; use `question-stage` first
- the story is really an epic that needs slicing; use `slicing-elephant-carpaccio` first
- the work is already at detailed implementation-plan level

## Core Principles

1. **Behavioral, not structural**
   Describe actor actions and system responses, not code, architecture, endpoints, or storage details.

2. **Grounded**
   Derive claims from the ticket, acceptance criteria, research, and current artifacts. Do not invent requirements.

3. **Extension-driven**
   The main scenario is only the spine. Most implementation risk lives in the extensions.

4. **Interactive by default**
   Prefer confirming classification, main scenario, and major extensions before finalizing. If the user explicitly wants a single-pass answer, state assumptions and continue.

5. **TDD-ready**
   Each main-scenario step implies a happy-path test. Each extension implies an edge-case test. Preconditions become setup or guard clauses. Postconditions become assertions.

## Workflow

### Step 1: Load Inputs

1. Read all provided story, ticket, artifact, and research inputs fully before drafting.
2. If the request references Jira issues such as `ABC-123`, use `managing-jira` first.
3. If a research artifact already exists, treat it as a hard input instead of re-researching from scratch.
4. If the story is still materially ambiguous after reading, stop and ask the minimum question needed before analysis.

### Step 2: Classify The Goal Level

Classify the story using Cockburn's hierarchy. See [references/cockburn-framework.md](references/cockburn-framework.md) when needed.

| Level | Icon | Meaning |
| --- | --- | --- |
| Summary | ☁️ | Multiple goals or sessions. Too broad for one use case. |
| User-goal | 🌊 | One actor, one sitting, one goal. Correct scope for a use case. |
| Subfunction | 🐟 | One step inside a larger goal. Too narrow on its own. |

Present the classification with evidence from the source material.

- If it is `☁️ Summary`, recommend `slicing-elephant-carpaccio`.
- If it is `🐟 Subfunction`, name the likely parent user-goal and ask whether to analyze that instead.
- If it is `🌊 User-goal`, proceed.

### Step 3: Identify Scope, Actors, And Stakeholders

Extract:

- **Scope**: the system under design
- **Primary actor**: who initiates the use case and has the goal
- **Supporting actors**: other systems or people involved
- **Stakeholders and interests**: people or teams with requirements the use case should surface

Go beyond the obvious user. Include security, support, operations, compliance, or product stakeholders when the inputs justify them.

### Step 4: Draft The Main Success Scenario

Write the happy path as numbered steps using Cockburn's grammar:

- actor step: `The user ...`
- system step: `The system ...`

Rules:

- keep the steps observable and technology-neutral
- keep granularity consistent
- keep the scenario focused on goal completion
- prefer 3-9 steps; more usually means the scope is wrong

Present the draft before finalizing when the workflow is interactive.

### Step 5: Discover Extensions

For each main-scenario step, look for:

- validation failures
- authorization or business-rule failures
- external-system failures
- unexpected data state
- timing or expiry issues
- legitimate alternate paths

Use Cockburn notation such as `2a`, `2b`, `4a`.

Each extension should name:

1. the condition at the numbered step
2. the system response
3. whether the flow resumes, loops, branches, or ends

Cross-check the extensions against the source acceptance criteria. Flag any criterion not covered by the main scenario or an extension.

### Step 6: Define Preconditions And Postconditions

Capture:

- **Preconditions**: what must already be true before step 1
- **Success guarantees**: what must be true after the happy path completes
- **Minimum guarantees**: what must remain true even when the use case fails

Keep them specific, observable, and testable.

### Step 7: Write The Final Use Case

Use [templates/use-case-document.md](templates/use-case-document.md).

Default to inline output unless the workflow already relies on durable artifacts or the user asks to persist the document.

If persistence is needed:

1. Use `artifact-management` to resolve or reuse the artifact root.
2. Do not invent a sixth QRDSPI stage.
3. Persist the use case as a sidecar document such as `use-cases/use-case--<slug>.md` under the active artifact root or repo-local artifact root.
4. Link that sidecar file from the active research, design, or plan artifact when relevant.

### Step 8: Verify Completeness

Before finalizing, check:

- every acceptance criterion maps to a main step, extension, precondition, or postcondition
- no major failure mode from the inputs is unaccounted for
- the goal level is correct
- the steps are behavioral rather than implementation-specific
- the postconditions are observable
- the TDD mapping is concrete enough to seed failing tests

## Casual Vs Fully Dressed

Use **casual** format for straightforward stories with one primary actor and few extensions.

Use **fully dressed** format when the work includes:

- multiple actors or external systems
- security, compliance, or payment concerns
- non-obvious stakeholder interests
- complex recovery paths or failure handling

Default to casual unless the complexity clearly justifies the full template.

## Skill Handoffs

- `question-stage`: the request is still too ambiguous for analysis
- `managing-jira`: the source of truth is a Jira ticket
- `slicing-elephant-carpaccio`: the story is summary-level and too broad
- `research-codebase`: the behavior depends on current code reality not yet captured in artifacts
- `implementation-plan`: the use case is approved and needs a concrete execution plan
- `planning-tdd` or `practicing-tdd`: turn the scenario and extensions into a test-first implementation sequence

## Examples

**Input:** "Analyze `ABC-123` into a use case before we plan implementation."

**Action:** Load the ticket with `managing-jira`, classify the goal level, draft the main scenario, discover extensions, and produce a use case document with acceptance-criteria coverage and TDD mapping.

**Input:** "Break these acceptance criteria into happy path and edge cases."

**Action:** Treat the criteria as source inputs, derive the main scenario and extensions, then return a casual use case if the scope stays simple.
