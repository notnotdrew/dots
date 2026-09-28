# Pending GitHub Review

Final coordinator step after canonical artifacts publish successfully and before
owned-checkout cleanup. Drafts an unpublished GitHub pull-request review for
comments that are worth leaving. This is the only GitHub write the skill may
perform.

## Hard Bounds

- Create or extend a review that stays `PENDING`. Never submit, approve, request
  changes, comment-publish, or dismiss it.
- Never pass an `event` field when creating the review. Never call the review
  submit/events endpoint unless Drew explicitly asks to publish in a later turn.
- Leave the review body empty unless a one-line closer is truly needed. If a
  closer is needed, do not rehash the inline comments; close simply (for example
  `LGTM` or `A couple of notes below.`). Prefer empty.
- Do not post issue comments, reply on existing threads, edit other users'
  comments, change PR state, or touch Linear.
- Do not create an empty pending review when no comments survive selection.
- Skip this entire step on same-head no-ops, failed artifact publication, and
  `UNABLE TO REVIEW` outcomes with no verified comment candidates.
- Keep the disposable review checkout until this step finishes when verification
  may need to run code. Cleanup remains the next step.

## When A Comment Is Worth Making

Start from retained, current-epoch findings in the published ledger and
`perfect-review.md`. A comment is worth making only when it is:

- actionable for the author of this PR;
- grounded in changed behavior or a clear risk introduced or touched by the PR;
- specific enough to place on a diff line; and
- not pure taste, restatement of the PR description, or a coverage note Drew
  cannot defend.

Drop candidates that duplicate an existing open review comment on the same
anchor with the same claim. Prefer fewer comments.

## Per-Comment Pipeline

For each selected candidate, run two independent subagents in order. Do not
draft or post from the coordinator alone.

### 1. Comment verifier

Launch a fresh agent with [isolated-jobs.md](isolated-jobs.md). Give it the
checkout, observed head, finding record, and proposed anchor. It must:

- re-read the relevant code at `ObservedHead`;
- decide whether the claim is true on this PR, false, or uncertain;
- decide whether the issue is introduced by this PR or pre-existing;
- when the claim is a regression, broken behavior, failing contract, or similar
  code issue, run the smallest appropriate command or test in the review
  checkout and record what ran plus the result; and
- return a structured result only:

```text
CommentVerifyResult:
  FindingId: <Fnn or none>
  Anchor: <path:line or path>
  Verdict: confirmed | rejected | uncertain
  PreExisting: yes | no | unknown
  Evidence: <one or two short factual lines, including command output summary when code was run>
  DraftClaim: <one plain sentence of the verified claim, or empty when rejected>
```

Reject `rejected` and `uncertain` candidates. Keep only `confirmed`.

Pre-existing confirmed issues may still be posted when they are worth making,
but they must be flagged as pre-existing in the final comment body. Prefer
wording such as `Pre-existing:` as the lead. Do not imply the PR introduced
them.

### 2. Comment readability

For each confirmed candidate, launch a second fresh agent that did not see the
verifier's chain of thought beyond `DraftClaim`, `PreExisting`, `Anchor`, and
`Evidence`. It loads `use-conversational-language` (reviewer-comment rules) and
rewrites for humans:

- plain, simple, clear;
- factual statements with minimal color;
- short; often a question when asking for a change;
- code identifiers in backticks;
- no process narration, no finding IDs, no PERFECT labels, no "AI noted".

It returns only:

```text
CommentReadabilityResult:
  Body: <final comment markdown>
  Anchor: <path and line/side for the diff comment>
```

If readability cannot produce a clear short comment without inventing facts,
drop the candidate.

## Assemble And Post

After all candidates finish the pipeline:

1. Resolve the authenticated GitHub login with `gh api user --jq .login`.
2. List existing reviews on the PR. If that user already has a `PENDING` review
   whose `commit_id` equals `ObservedHead`, reuse it. Otherwise create a new
   pending review on `ObservedHead` with an empty body and no `event`.
3. Post only the surviving inline comments. Use the create-review `comments`
   array for a new pending review, or the pending-review comment endpoint when
   extending an existing one.
4. Confirm each posted comment via API readback that the parent review `state`
   is still `PENDING`.
5. Record in the coordinator return: review id, whether body was empty, each
   path/line/body, and that the review was left unpublished.

If posting fails after artifacts already published, report the GitHub failure
and leave the canonical series intact. Do not roll back artifacts. Do not
submit the review as a recovery tactic.

## Coordinator Ownership

Only the coordinator selects candidates, launches the two subagent roles per
comment, posts the pending review, and reports the result. Verifier and
readability agents must not call GitHub write APIs, mutate the checkout, or
edit canonical artifacts.
