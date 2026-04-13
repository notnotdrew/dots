---
name: exploring-codebase
description: Conducts targeted codebase research based on resolved scope decisions or research targets. Use when the user wants documentation-first exploration of how an existing system works without proposing changes.
---

# Exploring Codebase

## Quick Start

Use this skill after the scope is clear and the next step is to map what already exists in the codebase: where it lives, how it works, and how components connect.

This skill is for documentation-first research. Describe what exists today before discussing changes.

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
- If no scoping artifact exists, derive focused research targets from the user's question
- Wait until the relevant evidence is gathered before synthesizing
- Do not recommend implementations, refactors, or preferred approaches unless the user explicitly asks

## Workflow

1. Load the research driver.
   - If the user provides a local decisions artifact or task document, read it completely.
   - Extract the goal, resolved decisions, scope boundaries, and research targets when present.
   - If no artifact exists, restate the user's question and break it into a small number of research targets yourself.

2. Decompose the investigation.
   - Identify the code areas, interfaces, documents, and patterns most likely to answer the question.
   - Separate discovery tasks such as locating files from explanation tasks such as understanding flows or patterns.
   - Keep the investigation inside the agreed scope boundaries.

3. Research the codebase.
   - Find the relevant files, modules, tests, docs, and configuration.
   - Read the most important source files directly.
   - Use parallel exploration where it helps, but only synthesize after the supporting evidence is in hand.
   - Track data flow, control flow, dependencies, and notable conventions.

4. Verify the findings.
   - Cross-check important claims against the source.
   - Resolve conflicting findings by reading the code directly.
   - Make sure file references are accurate and useful.

5. Synthesize the research.
   - Summarize what exists in concise neutral language.
   - Group findings by component or concern.
   - Carry forward resolved decisions and scope boundaries when they shaped the investigation.
   - End with open questions only where the codebase does not answer them.

6. Persist only when needed.
   - Save a research artifact only if the user asks for one or the current workflow already expects written research output.

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
```

## Guidelines

- Prefer targeted research over broad tours of the repository
- Use scoping decisions to exclude irrelevant subsystems
- If a claim matters, support it with a direct file reference
- Distinguish between what is explicit in code and what is an inference from multiple sources
- Keep summaries neutral and avoid critique unless the user asks for evaluation
- If the codebase answers the question completely, say so plainly instead of padding the report
