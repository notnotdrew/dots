---
name: managing-jira
description: Loads Jira tickets into a compact normalized summary for downstream scoping or planning. Use when the input references Jira issue keys such as `ABC-123` and the next skill needs the ticket's summary, description, comments, or linked issues without turning that ticket into a plan.
---

# Managing Jira

## Quick Start

Use this skill when a workflow starts from a Jira ticket instead of a local artifact.

Verify authentication first:

```bash
jira me
```

If authentication fails, stop and tell the user they need to configure Jira access before the ticket can be loaded.

## Instructions

1. Detect whether the input contains one or more Jira issue keys such as `ABC-123`.
   - If not, do not force this skill into the workflow.

2. Load the primary ticket before downstream scoping or planning.
   - Use `jira issue view ISSUE-KEY --comments 5` for the main ticket.
   - Read enough comments to understand recent clarifications or boundary changes.
   - Inspect linked issues when they materially change scope, sequencing, or dependencies.

3. Normalize the result into a compact summary.
   - Include: key, summary, status, type, description summary, meaningful recent comments, and linked issues that affect the work.
   - Omit noise such as repetitive status chatter or unrelated linked tickets.

4. Stay descriptive.
   - Do not recommend an implementation.
   - Do not expand the ticket into a plan.
   - Do not restate every field from Jira when a concise summary will do.

5. Hand off cleanly.
   - Return the normalized ticket summary in plain language.
   - Name open ambiguities only when the ticket itself is unclear.
   - If the Jira ticket should feed a persisted QRDSPI artifact, pass the ticket key through `SourceInputs`.

## Normalized Output

Use this shape:

```markdown
## Jira Summary

- Ticket: ABC-123
- Summary: [one sentence]
- Status: [status]
- Type: [issue type]

## Description Summary

[2-4 sentences covering the actual work request and constraints]

## Recent Clarifications

- [comment-driven clarification that changes scope or expectations]

## Linked Issues That Matter

- XYZ-456 - [why it matters]

## Remaining Ambiguities

- [only if the ticket leaves something materially unclear]
```

## Guidelines

- Prefer one primary ticket plus only the linked issues that actually matter.
- Keep the summary short enough for another skill to consume directly.
- If the ticket clearly lacks essential detail, say so plainly instead of guessing.
- Use Jira as an input source, not as a replacement for local artifact management.
