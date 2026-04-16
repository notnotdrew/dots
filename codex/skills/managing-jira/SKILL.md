---
name: managing-jira
description: Summarizes Jira tickets for downstream scoping or planning.
---

# Managing Jira

Use this skill when the input includes Jira issue keys and the next step needs ticket context, not a plan.

## Workflow

1. Verify access with `jira me`.
   If authentication fails, stop and tell the user Jira access needs to be configured.
2. Load the primary ticket with `jira issue view ISSUE-KEY --comments 5`.
3. Read only the comments and linked issues that change scope, sequencing, or dependencies.
4. Return a compact summary.
   Include key, summary, status, type, description summary, meaningful recent comments, and linked issues that matter.
5. Stay descriptive.
   Do not recommend an implementation or turn the ticket into a plan.
6. For persisted QRDSPI flows, pass the ticket key through `SourceInputs`.

## Output

```markdown
## Jira Summary

- Ticket: ABC-123
- Summary: [brief summary]
- Status: [status]
- Type: [issue type]

## Description Summary

[brief summary of request and constraints]

## Recent Clarifications

- [only if it changes scope or expectations]

## Linked Issues That Matter

- XYZ-456 - [why it matters]

## Remaining Ambiguities

- [only if needed]
```

## Rules

- Do not force this skill when no Jira key is present.
- Ignore repetitive status chatter and unrelated linked tickets.
- Keep the summary short enough for the next skill to consume directly.
- If essential detail is missing, say so plainly instead of guessing.
