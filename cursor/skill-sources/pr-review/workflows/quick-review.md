# Quick Review Workflow

Use this workflow for an explicitly selected Quick review, whether or not a canonical series already exists. It owns both the initial Quick review and the Quick delta rereview. Do not route Quick through [standard-review.md](standard-review.md), [deep-review.md](deep-review.md), or [incremental-review.md](incremental-review.md). Reuse the named sections below; do not copy them.

Apply [review-contracts.md](../references/review-contracts.md). Compile verdicts with [perfect-principles.md](../references/perfect-principles.md) and the outcome table in the contracts. Write [context-brief.md](../templates/context-brief.md), [findings-ledger.md](../templates/findings-ledger.md), and [perfect-review.md](../templates/perfect-review.md). Do not open `isolated-jobs.md`, `reviewer-orchestration.md`, `finding-synthesis.md`, `context-gathering.md`, or `language-skill-mapping.md`.

The coordinator does this work in one session. Do not launch the context gatherer, the Deep planner, focused reviewers, the synthesis reviewer, or any other isolated job. The comment-verifier and readability jobs belong only to the pending-review step named below. Do not trace callers, open Linear, or load stack skills.

Keep Linear, PR metadata, Git history, and the review checkout read-only, except for the pending unpublished GitHub review that the reused publication step drafts. Never change issue state, edit reviewed files, switch or mutate the user's PR branch worktree, reply on existing threads, or post issue comments. Never submit or publish that review unless Drew explicitly asks in a later turn.

## 1. Reject Incompatible Flags And A Defaulted Selection

Before resolving a checkout, writing staging, or writing artifacts, reject `--finding` and `--full-rebuild`. Quick has no single-finding revision and no full rebuild.

Require an explicit `--mode quick` selection:

```text
Mode: Quick
ModeSelection: explicit
```

If mode was omitted, defaulted, or selected as Standard or Deep, stop and report the routing mismatch. Quick is never the default and never an automatic escalation.

## 2. Resolve Identity And The Series Path

Retain `INVOCATION_DIR`. Resolve skill helpers from the skill directory, not from the reviewed repository.

Resolve owner, repository, PR number, `SERIES_ROOT`, `SERIES_PARENT`, and `SERIES_DIR` with the same identity, series-root, cloud, and local rules as [standard-review.md](standard-review.md) section 1. Use `scripts/gh-pr-parse`. Do not apply Standard's mode gate or its initial-only series rejection. Do not call `scripts/resolve-review-checkout` in this section.

If identity cannot be resolved, stop. Report the identity blocker. Do not publish artifacts under a guessed path.

## 3. Recover, Then Choose The Run

If `SERIES_DIR` exists, perform [incremental-review.md](incremental-review.md) section 1 recovery before reading any canonical artifact as review input. Do not copy that procedure. If recovery stops, stop. Do not turn a collision, partial series, or invalid series into an initial review.

If `SERIES_DIR` does not exist, skip recovery. This is an initial review at `R1`.

After recovery, compare the current GitHub `headRefOid` with the series' `ObservedHead` and readiness:

- Same head, readiness already `ready`: stop as a no-op. Do not create a checkout or rewrite artifacts. Report that the current head is already reviewed. Skip the pending GitHub review.
- Same head, prior readiness `UNABLE TO REVIEW`: retry under the same `CurrentEpoch`. Replace the published artifacts. Do not take the next ordinal.
- New head: take the next ordinal. Review only what changed since the prior `ObservedHead`.
- Absent series: initial review at `R1`.

A series written before `CurrentEpoch` existed has none. Treat that published run as R1. A new head takes the next ordinal, and the replacement artifacts write `CurrentEpoch`. This is the same classification `scripts/resolve-review-checkout` already implements. After recovery, invoke that helper without `--ensure`, and without `--full-rebuild` or `--finding`. If its `ACTION` or `EPOCH` disagrees with this classification, stop without writing. `ACTION=noop` is the same-head ready stop above. Do not pass `--ensure` on that result.

A ready same-head review stays a no-op. Do not treat a later mode change as a reason to review this head again from this workflow.

## 4. Resolve The Checkout

When a checkout is needed, reuse [standard-review.md](standard-review.md) section 2 for the epoch selected above. Substitute that epoch where section 2 names `R1`. On a local review the checkout is the disposable epoch checkout `pr-<PR_NUMBER>-R<epoch>`. On a cloud review the checkout is the project clone at the observed head. Use `scripts/resolve-review-checkout --ensure` when a checkout must be created or reused. Prefer launcher exports when they match the selected epoch and head.

Never mutate the user's PR branch worktree. Never call WorkTrunk on a cloud review. Never remove a checkout this invocation does not own. Record `CHECKOUT_CREATED_BY_THIS_INVOCATION` the way Standard section 2 does.

Re-query `headRefOid` before staging. Do not combine revisions. If the head moved after the run was chosen, stop without publishing.

## 5. Read The Diff In This Session

Read only in this session.

On an initial review or a same-head `UNABLE TO REVIEW` retry, read the pull request diff, the changed files, and the title and body needed for identity and intent. The diff is the merge-base comparison of the observed base and the observed head.

On a new-head delta, read only the diff from the prior `ObservedHead` to the current head, and the files that diff changes. Do not read unchanged files and do not trace callers.

Quick's narrower scope is the mode, not a material coverage gap. Do not record "no caller tracing", "no Linear", or "no isolated reviewers" as gaps that force `UNABLE TO REVIEW`. `UNABLE TO REVIEW` remains for a real blocker: an unreadable diff, unresolved identity, and the other cases in [review-contracts.md](../references/review-contracts.md).

The coverage owner for what this session read is `coordinator`.

## 6. Judge Findings

Assign stable IDs and dispositions in this session. There is no synthesis job. `SourceReviewers` for a finding Quick creates or rejudges is `coordinator`. When Quick verifies, dismisses, or updates a finding, append `DispositionHistory` and name Quick in that entry, together with the run, the disposition change, the reason, and the evidence. Do not rewrite an earlier entry. Use the form `R<n>: <prior> -> <disposition>; Quick; <reason and evidence>`. A new finding's first entry uses the same form, including `candidate -> verified` or `candidate -> dismissed`.

A finding came from Quick when its latest `DispositionHistory` entry names Quick, or when the published series `Mode` is Quick and that finding's history does not name a Standard or Deep verification.

On an initial review, every behavioral claim is new. Start at `F01`.

On a delta:

- Rejudge a finding only when its `Scope` intersects the delta. Intersection means the recorded scope overlaps a file or behavior the delta diff changes.
- Carry every finding outside the delta with its existing disposition and `DispositionHistory`. Do not append a history entry, and do not change `SourceReviewers`.
- A rejudged claim that is the same behavioral claim keeps its ID. Append `DispositionHistory` and name Quick in that entry.
- A materially different claim gets a new ID after the highest ID ever used in the series. Never recycle an ID. Link `Supersedes` and `DuplicateOf` under the contracts.
- An empty tree delta on a new head still publishes the updated `ObservedHead` and carries the findings. A SHA change is not by itself a behavioral change.

On a same-head `UNABLE TO REVIEW` retry, rejudge the head from the full diff and changed files under the same `CurrentEpoch`. Keep the ID of the same claim. Append `DispositionHistory` and name Quick when the retry verifies, dismisses, or updates that finding.

Do not leave `candidate` when the final outcome is a definitive recommendation. The existing contract still allows `candidate` only when failed verification and a qualifying coverage or readiness escalation are recorded and the outcome is `UnableToReview`.

## 7. Compile The Three Artifacts

Write all three templates from the evidence this session read. Do not reconstruct them from an isolated job. All three record:

```text
Mode: Quick
ModeSelection: explicit
```

They agree on `CurrentEpoch`, `ObservedHead`, readiness, coverage, and stable IDs. Set `SincePriorHead` to `none` on an initial review. On a delta, record the prior head and the paths changed since it, and keep published identity and intent fields the delta did not change. Record `LinearEvidence: none` and `Callers: none` unless the text actually read states them. On an initial review or a same-head retry, judge Purpose from the title, body, diff, and changed files. On a delta, judge Purpose from the published intent plus the delta diff and the files that diff changes.

Derive readiness, `UnresolvedMaterialDecisions`, verdicts, and exactly one outcome from [review-contracts.md](../references/review-contracts.md) and [perfect-principles.md](../references/perfect-principles.md). Drop any older `## Review Epochs` or `## Amendments` sections. The replacement files follow the three templates only.

## 8. Publish, Draft The Pending Review, And Clean Up

Do not create `WORK_DIR`. Quick launches no isolated job that uses it.

On an initial review, create the uniquely named same-filesystem staging directory under `SERIES_PARENT` named in [standard-review.md](standard-review.md) section 9, and write the three compiled files there. Do not copy them from `WORK_DIR`. Then follow section 9 from validation onward: validate, require `SERIES_DIR` to be absent, rename that staging directory to `SERIES_DIR`, and revalidate. Then follow sections 10 and 11 once. Section 10 is the pending unpublished GitHub review. Section 11 is ownership-aware cleanup.

On a delta or a same-head `UNABLE TO REVIEW` retry, follow [incremental-review.md](incremental-review.md) sections 9 and 10, using the three files this session compiled as the staged replacements. Do not rerun discovery, gathering, or synthesis. Section 10 already drafts the pending review and cleans up after a successful publication. Do not also run Standard sections 10 and 11. Section 1 recovery already ran before reading.

Never remove a checkout this invocation does not own. Never remove the user's PR branch worktree. Never remove the cloud project clone. Never call WorkTrunk on a cloud review.

## 9. Return

Return:

- `CurrentEpoch` and whether the run was an initial review, a delta rereview, a same-head unable retry, or a no-op;
- the recommendation or the concrete `UNABLE TO REVIEW` details;
- the absolute series directory and the three canonical filenames, or the no-op series left unchanged;
- the observed head, and on a delta the prior observed head;
- finding IDs rejudged, carried, or added;
- pending GitHub review status (skipped, drafted unpublished with review id and comments, or failed), noting that it was not published; and
- checkout cleanup status.
