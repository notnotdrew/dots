# Tim Pope Commit Message Format

Use this reference when the repository does not define a stronger local convention and the commit message needs detailed formatting guidance.

## Core Rules

1. Separate subject and body with a blank line.
2. Aim for a subject near 50 characters.
3. Treat 72 characters as a hard subject limit.
4. Capitalize the subject.
5. Do not end the subject with a period.
6. Use imperative mood.
7. Wrap body lines at 72 characters.
8. Use the body, when there is one, for the why the diff cannot show.

## Subject Guidance

The subject is one plain clause saying what the commit does, in a form that completes this sentence:

`If applied, this commit will [subject]`

Good:

- `Add user authentication`
- `Fix login timeout in OAuth callback`
- `Refactor payment retries for clarity`

Bad:

- `Added user authentication`
- `Fixes login timeout`
- `Updated stuff`
- `WIP`
- `Give each isolated review job its whole instruction in the handoff` (packed; say `Make job handoffs self-contained`)

Useful subject verbs:

- `Add`
- `Fix`
- `Update`
- `Refactor`
- `Remove`
- `Rename`
- `Move`
- `Extract`
- `Simplify`
- `Improve`
- `Replace`
- `Support`
- `Handle`
- `Implement`
- `Configure`
- `Document`

## When to Write a Body

Default to none. Use a body only when the diff cannot tell a future reader why the change was made.

Typical triggers:

- the motivation is not visible in the code
- the approach is surprising enough that someone might undo it
- there is a tradeoff or caveat
- the change is breaking
- an issue must be closed or migration notes recorded

Touching many files is not a trigger.

## What the Body Should Do

The body explains why, in one or two short paragraphs. It does not describe what changed; the diff does that. It does not list the files or pieces touched, and it does not say what was left alone.

## Common Patterns

### Issue references

Put issue references at the end of the body.

```text
Fix image resize memory leak

Release buffers after each resize operation so repeated jobs do
not accumulate process memory over time.

Fixes #456
Refs #400
```

### Breaking changes

Call them out explicitly.

```text
Remove deprecated v1 API endpoints

BREAKING CHANGE: Remove the /api/v1/* routes. Clients must use
/api/v2/* instead.
```

### Multi-part thematic commits

Keep the subject on the shared theme, not every individual edit. Do not bullet the edits in the body; the diff already lists them.

```text
Improve error handling in the payment flow

Gateway timeouts were surfacing as a blank 500 with nothing in the
logs to go on.
```

## Edge Cases

### Trivial changes

Subject only is fine when the change is genuinely obvious and isolated.

Examples:

- `Fix typo in README`
- `Update copyright year`

### Reverts

Follow Git’s standard revert structure and explain the reason for the revert when useful.

### Work in progress

Avoid vague `WIP` messages in shared history. Prefer a descriptive checkpoint or use fixup commits when appropriate.

## Final Checklist

- subject is imperative
- subject is capitalized
- subject has no trailing period
- subject passes the completion test
- subject stays at or under 72 characters
- body is separated by one blank line
- body lines wrap at 72 characters
- body is absent, or explains only the why
- issue references are at the end
- no AI attribution appears anywhere
