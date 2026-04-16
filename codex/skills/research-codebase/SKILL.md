---
name: research-codebase
description: Conducts targeted codebase research based on resolved scope decisions or research targets. Use when the user wants documentation-first exploration of how an existing system works without proposing changes.
---

# Research Codebase

Use this skill to map the current codebase, not to design changes.

If a question artifact or scoping document exists, use it as the research driver. If not, restate the user's question and derive a short target list yourself. Keep the investigation factual and inside the stated boundaries.

## Core Rules

- Document what exists today
- Do not recommend changes unless the user asks
- Read key source files before making strong claims
- Support important findings with concrete file references
- Mark gaps and unresolved targets explicitly
- Use `artifact-management` when the workflow should persist beyond chat

## Workflow

1. Frame the research.
   - Load the scoping artifact when one exists.
   - Extract the question, scope boundaries, resolved decisions, and research targets.
   - If no artifact exists, derive a small set of targets from the user's question.
   - Restate the framing before broad exploration.

2. Gather evidence.
   - Find the files, docs, tests, config, and interfaces that answer each target.
   - Separate locating files from understanding behavior.
   - Use parallel exploration only for evidence gathering.

3. Verify.
   - Cross-check important claims against source files.
   - Resolve conflicts by reading the code directly.
   - Confirm each target is either answered or clearly unresolved.

4. Synthesize.
   - Summarize the current state in neutral language.
   - Group findings by component or concern.
   - Carry forward any decisions or boundaries that shaped the research.
   - End with design inputs and only the open questions the codebase cannot answer.

5. Persist when needed.
   - In staged work, write the research artifact through `artifact-management`.
   - For one-off questions, inline output is enough unless the user asks for a file.

## Output Format

```markdown
## Research Question

[Goal or user question]

## Summary

[Brief neutral description of what exists]

## Resolved Decisions

[Only include decisions that shaped the research]

## Detailed Findings

### [Component or Area]

**What exists**: [Description with file references]

**Connections**: [Data flow, dependencies, related components]

**Patterns**: [Conventions worth noting]

## Code References

- `[path/to/file.ext:line]` - [why it matters]

## Architecture

[How the important pieces relate]

## Design Inputs

- Facts to preserve: [current-state findings]
- Constraints: [technical boundaries or contracts]
- Exemplars: [patterns worth following]

## Open Questions for Design

- [Only what the codebase cannot answer]
```
