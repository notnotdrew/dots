---
name: writing-for-humans
description: Rewrite dense user-facing drafts into concise, scannable prose. Use as a final polish pass for READMEs, guides, tutorials, onboarding docs, PR descriptions, and commit messages. Do not use for code comments, internal specs, research notes, generated API docs, or structured output.
---

# Writing for Humans

Rewrite drafts into prose people can scan and trust.

## Use It For

User-facing prose: READMEs, guides, tutorials, PR descriptions, commit messages, onboarding docs.

Do not use it for code comments, internal specs, research notes, generated API docs, or structured output.

## Workflow

1. Read the draft once.
2. Lead with the answer, action, or recommendation.
3. Cut filler, hedging, buzzwords, and repeated ideas.
4. Replace abstract claims with concrete facts, names, or numbers.
5. Break long paragraphs and long lists into clear chunks.
6. Return only the rewritten text.

## Rules

- Prefer direct verbs and active voice.
- Put context after the point, not before it.
- Keep headings specific.
- Keep paragraphs short.
- Use lists only when they improve scanning.
- If a sentence survives after removing a phrase, remove it.

## Invocation

```text
Use $writing-for-humans to rewrite the following text.
Return only the rewritten text.

---
[paste draft here]
```

## Check

Before you finish, verify:

- the rewrite is shorter
- the reading order is obvious
- vague language is gone
- the draft still says the same thing
