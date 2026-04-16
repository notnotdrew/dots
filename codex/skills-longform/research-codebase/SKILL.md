---
name: research-codebase
description: Conducts targeted codebase research based on resolved scope decisions or research targets. Use when the user wants documentation-first exploration of how an existing system works without proposing changes.
---

# Research Codebase

## Quick Start

Use this skill after the scope is clear and the next step is to map what already exists in the codebase: where it lives, how it works, and how components connect.

This skill is for documentation-first research. Describe what exists today before discussing changes.
When this follows `$question-stage` for feature work, treat the scoping output as the research driver and avoid re-expanding the original implementation request during research.
Before deeper research, restate the research question, targets, and scope boundaries so the investigation stays factual.
When the workflow is persisted, use `artifact-management` to locate the question artifact first and to write the research artifact as the default handoff.

## Choose Your Approach

**The user provided a scoping artifact or decisions document**
Use it to define the research targets and scope boundaries.

**The user asked a direct codebase question**
Restate the question, derive a small set of research targets, and stay inside that boundary.

## Instructions

- Treat the task as documentation, not design
- Describe what exists, not what should change
- Include concrete file references for important findings
- Read key source files directly before making strong claims
- When the user provides a scoping artifact or decisions document, use that to drive the research areas
- When the user provides only a ticket or prompt but a related question artifact may already exist, search for it via `artifact-management` before deriving fresh targets
- If no scoping artifact exists, derive focused research targets from the user's question
- Decompose the work into explicit research targets before broad exploration
- For proposed feature work, research from the resolved scope and research targets rather than from the desired solution
- Treat parallel exploration as evidence gathering only; complete it before synthesizing
- Restate the research framing if new evidence shows the original target list was incomplete or mis-scoped
- Call out unanswered targets or evidence gaps explicitly instead of filling them with recommendations
- Do not recommend implementations, refactors, or preferred approaches unless the user explicitly asks

## Workflow

1. Load the research driver.
   - If the user provides a local decisions artifact or task document, read it completely.
   - If the workflow is already in progress, use `artifact-management` to find the current question artifact before deriving targets from raw prompts again.
   - Extract the goal, resolved decisions, scope boundaries, and research targets when present.
   - For change work, prefer those extracted research targets over the full feature request so the investigation stays factual.
   - If no artifact exists, restate the user's question and break it into a small number of research targets yourself.
   - Before deeper work, restate the research framing in Codex-native terms: question, targets, and boundaries.

2. Decompose the investigation.
   - Turn the research framing into explicit research targets or sub-questions.
   - Identify the code areas, interfaces, documents, and patterns most likely to answer each target.
   - Separate discovery tasks such as locating files from explanation tasks such as understanding flows or patterns.
   - Identify which evidence-gathering tasks can run in parallel and which depend on earlier findings.
   - Keep the investigation inside the agreed scope boundaries.

3. Research the codebase.
   - Gather evidence for each research target by finding the relevant files, modules, tests, docs, and configuration.
   - Read the most important source files directly.
   - Use parallel exploration where it helps, but keep it in evidence-gathering mode until the active targets are covered.
   - Wait for the active exploration threads to finish before moving into synthesis.
   - Track data flow, control flow, dependencies, and notable conventions.

4. Verify the findings.
   - Cross-check important claims against the source.
   - Resolve conflicting findings by reading the code directly.
   - Confirm each research target is either answered by evidence or explicitly marked unresolved.
   - Make sure file references are accurate and useful.

5. Synthesize the research.
   - Summarize what exists in concise neutral language.
   - Group findings by component or concern, but make sure each research target is covered.
   - Carry forward resolved decisions and scope boundaries when they shaped the investigation.
   - End with compact design inputs so `$design-discussion` can use the factual findings without repeating research.
   - End with open questions only where the codebase does not answer them.

6. Persist only when needed.
   - In a staged workflow, persist the research artifact by default through `artifact-management` and return the path you updated.
   - For casual one-off research, inline output is enough unless the user asks for a file.

## Report

Use this format for the research output:

```markdown
## Research Question

[Goal or user question]

## Summary

[What exists, in 3-5 sentences. No opinions.]

## Resolved Decisions

[Carry forward any scoping decisions that shaped the research]

## Detailed Findings

### [Component or Area]

**What exists**: [Description with file references]

**Connections**: [Data flow, dependencies, and related components]

**Patterns**: [Naming, structure, test patterns, or conventions followed here]

## Code References

- `[path/to/file.ext:line]` - [one-line reason this reference matters]

## Architecture

[How the important pieces relate]

## Design Inputs

- Facts to preserve: [current-state findings that matter for later design]
- Constraints: [technical boundaries or contracts discovered]
- Exemplars: [patterns or components worth following]

## Open Questions for Design

- [Only include questions the codebase itself cannot answer]
```

## Examples

**Input:** "Use this scoping artifact and explore how billing retries work."

**Output:**

```markdown
## Research Question

Document how billing retries currently work within the approved scope from the scoping artifact.

## Summary

Billing retry behavior is implemented across the payment worker, retry scheduling logic, and gateway integration layer. Retry state is persisted before background jobs are enqueued, and failure handling branches on gateway response categories. The current flow relies on shared billing event objects and a retry policy module rather than embedding retry rules in each caller.

## Resolved Decisions

- Limit research to failed charge retries, not subscription lifecycle changes
- Focus on server-side behavior only

## Detailed Findings

### Retry Scheduling

**What exists**: Retry scheduling is coordinated in `app/services/billing/retry_policy.rb:12` and `app/jobs/billing/retry_charge_job.rb:8`, where failed charges are classified and rescheduled.

**Connections**: The retry job consumes persisted billing events and calls the gateway client through the billing service layer.

**Patterns**: Retry intervals are centralized in one policy object and reused by background jobs rather than duplicated per payment flow.

## Design Inputs

- Facts to preserve: Retry classification and scheduling are already shared concerns rather than caller-specific logic.
- Constraints: Retry state is persisted before job execution, and gateway response categories shape subsequent behavior.
- Exemplars: The shared retry policy module and retry job pattern are the current server-side model.
```

## Guidelines

- Prefer targeted research over broad tours of the repository
- Use scoping decisions to exclude irrelevant subsystems
- If a claim matters, support it with a direct file reference
- Distinguish between what is explicit in code and what is an inference from multiple sources
- Use parallel work to collect evidence faster, not to produce early conclusions
- If the research framing changes materially, restate the updated targets before continuing
- Keep summaries neutral and avoid critique unless the user asks for evaluation
- If researching a proposed change, keep desired behavior out of the research narrative except as a scope boundary
- If the codebase answers the question completely, say so plainly instead of padding the report
- Preserve the same topic slug and artifact root when you move from question to research artifacts
