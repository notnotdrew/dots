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
8. Use the body to explain what changed and why.

## Subject Guidance

The subject should describe the main action of the commit in a form that completes this sentence:

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

Use a body when the diff alone is not enough for a future reader to understand the change.

Typical triggers:

- multiple files contribute to one behavior change
- the motivation is not obvious from the code
- there are tradeoffs, consequences, or caveats
- the change is breaking
- issues or migration notes should be recorded

## What the Body Should Do

The body should explain:

- what changed at a conceptual level
- why the change was necessary
- what consequences or tradeoffs matter
- what a reviewer or future maintainer should know

The body should not just narrate implementation steps already visible in the diff.

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

Keep the subject focused on the shared theme, not every individual edit.

```text
Improve error handling across payment flow

- Add retry behavior for transient gateway failures
- Log enough context for debugging
- Return clearer user-facing failure messages
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
- body explains what and why
- issue references are at the end
- no AI attribution appears anywhere
