---
name: pr-review
description: "Reviews and updates GitHub pull requests using PERFECT: Purpose, Edge Cases, Reliability, Form, Evidence, Clarity, Taste. Use for Standard reviews by default, explicitly requested Deep reviews, or follow-up review updates."
---

# PR Review

Review or update a GitHub pull request with the artifact-backed PERFECT workflow. Standard is the default; Deep is available by explicit selection. Apply PERFECT in priority order: Purpose, Edge Cases, Reliability, Form, Evidence, Clarity, then Taste.

## Quick Start

When this skill is selected or receives a `/pr-review` request, execute the
selected workflow in the current agent session. Never invoke the `pr-review`
shell command from inside the agent: that command is the outer launcher and
would recursively start another agent.

For a human starting a review from a shell, run the launcher from the
repository containing the pull request:

```bash
pr-review 42
pr-review https://github.com/org/repo/pull/42
pr-review --mode deep 42
pr-review --finding F01 42
```

Prerequisites:
- `git`
- `gh`
- `jq`
- `curl` when `CURSOR_AGENT_SOCKET` is set, to read the runtime
- `wt` (WorkTrunk) for a local review and for the launcher
- `agent` when using the launcher
- GitHub auth configured for the target repo

Use [scripts/gh-pr-parse](scripts/gh-pr-parse) to validate and parse the reference. Use [scripts/resolve-review-checkout](scripts/resolve-review-checkout) to select the series root, detect same-head no-ops, and resolve the checkout. On a local review it chooses the disposable epoch checkout (`pr-<number>-R<epoch>`) and can create the WorkTrunk worktree. On a cloud review it uses the project clone at the observed head and does not call WorkTrunk. Resolve helpers relative to this skill directory.

## Inputs

- **PR number**: e.g. `42`
- **PR URL**: e.g. `https://github.com/org/repo/pull/42`
- **Mode**: omitted or `--mode standard` for Standard; `--mode deep` for explicit Deep
- **Update controls**: `--full-rebuild` or `--finding F<positive-integer>`

Run both forms from the repository that contains the pull request. A local review does that so WorkTrunk can create or locate a disposable epoch checkout without mutating the user's PR branch worktree. A cloud review uses that clone as the review checkout.

Standard is the omitted-mode default. Deep must be selected explicitly and never results from automatic escalation.

A review is a cloud review only when `CURSOR_AGENT_SOCKET` is set and this command succeeds and prints exactly `managed`:

```bash
curl -fsS --unix-socket "$CURSOR_AGENT_SOCKET" http://cursor-agent/v1/meta-data/agent/runtime
```

If `CURSOR_AGENT_SOCKET` is set but the command fails or prints anything else, stop. Do not fall back to the local series root. `self_hosted` is not a cloud review. A local review does not set `CURSOR_AGENT_SOCKET`.

On a cloud review, `CURSOR_AGENT_STORE_FILES_DIR` must be an absolute path of an existing directory. If it is missing, relative, or not a directory, stop. Do not write a cloud series under `~/.cdx-artifacts`.

Series roots, with the same `<owner>--<repo>/pr-<number>/` layout under either one:

```text
Local SERIES_ROOT = ~/.cdx-artifacts/pr-reviews
Cloud SERIES_ROOT = $CURSOR_AGENT_STORE_FILES_DIR/pr-reviews
```

Read same-head no-op, epoch, and readiness from the selected root only. A ready series under the other root is not this review's series. Series writes, staging, and work directories stay under that root's `SERIES_PARENT`.

A local review checkout is disposable and epoch-scoped: `pr-<number>-R<epochOrdinal>` (for example `pr-7166-R1`). It is created at that epoch's `ObservedHead` and must never mutate the user's PR branch worktree. A cloud review does not create that branch or a WorkTrunk worktree. It reviews the project clone at the observed head, ignores the epoch branch-name requirement, and never removes that clone. `CHECKOUT_BRANCH` remains the epoch label for identity only. Checkouts are evidence; the series under the selected root is the review identity.

When the current GitHub head equals the selected series' current `ObservedHead` and readiness is already `ready`, a default re-review is a no-op. Use `--full-rebuild` or `--finding` to force more work on an unchanged head. A prior `UNABLE TO REVIEW` on the same head may be retried under the same `CurrentEpoch`.

`--finding` requires an existing review series and one existing ID matching `F0*[1-9][0-9]*`. Match by integer so `F1`, `F01`, and `F001` select the same stored record. New IDs display with at least two digits (`F01`); additional digits are allowed, and existing three-digit IDs stay as stored. Use Standard verification depth. It is incompatible with `--mode deep` and `--full-rebuild`. A full rebuild also requires an existing series.

## Workflow Routing

Resolve PR identity and the canonical series path under the selected `SERIES_ROOT` before choosing a workflow. The other root is not this series:

1. If the canonical series path is absent, use [standard-review.md](workflows/standard-review.md) for omitted or explicit Standard, or [deep-review.md](workflows/deep-review.md) for explicitly selected Deep.
2. If the series path exists, route to [incremental-review.md](workflows/incremental-review.md) before inspecting its contents so that workflow can recover an interrupted publication or report a precise collision. Inherit unaffected evidence by default; `--full-rebuild` selects its full-rebuild path under the selected mode.
3. Reject `--full-rebuild` or `--finding` when the series path is absent. An empty, partial, invalid, or noncanonical existing path is a collision or recovery blocker, not an initial review.

The selected workflow owns the complete procedure. Do not replace it with an inline single-agent review or duplicate Standard stages in the entry point.

## Shared Workflow Boundaries

Every route reuses the contracts and Standard coordinator stages for isolated gathering, readiness, bounded synthesis, ledger-derived PERFECT compilation, exactly-three-file persistence, pending GitHub review drafting, and ownership-aware cleanup. Deep changes planning, context breadth, justified reviewer overlap, and verification depth. Incremental review adds recovery, inheritance, and recoverable replacement while preserving those shared boundaries.

Standard may recommend a later Deep review but must complete under Standard guarantees or return `UNABLE TO REVIEW`. Deep must independently verify every retained actionable finding. Incremental review revalidates changed and dependency-affected scope, preserves unaffected history, and performs a full rebuild only when explicitly requested or when broad invalidation makes inheritance unsafe.

## Role Loading

The coordinator executes the selected workflow in this session. Isolated jobs run in fresh agents and return through files. Follow [isolated-jobs.md](references/isolated-jobs.md). Do not open gatherer-only files or stack skill bodies in the coordinator session.

Coordinator loads:

- [review-contracts.md](references/review-contracts.md)
- [isolated-jobs.md](references/isolated-jobs.md)
- [reviewer-orchestration.md](references/reviewer-orchestration.md)
- [finding-synthesis.md](references/finding-synthesis.md)
- [perfect-principles.md](references/perfect-principles.md) when compiling
- [pending-github-review.md](references/pending-github-review.md) after successful artifact publication
- [context-brief.md](templates/context-brief.md), [findings-ledger.md](templates/findings-ledger.md), and [perfect-review.md](templates/perfect-review.md) when writing staging

Gatherer loads [context-gathering.md](references/context-gathering.md) and [language-skill-mapping.md](references/language-skill-mapping.md) for path matching only. Focused reviewers load only the stack skills named in their handoff. Pending-review readability agents load `use-conversational-language` for reviewer-comment wording only.

Validate the staged artifact directory with [validate-review-artifacts](scripts/validate-review-artifacts) before publication.

## Ownership And Safety

The coordinator alone owns mode and route selection, readiness, reviewer scope, cross-boundary ownership, stable finding IDs, canonical artifact writes, final compilation, publication, pending GitHub review drafting, and checkout cleanup. The gatherer, Deep planner, focused reviewers, synthesis reviewer, comment verifier, and comment readability agent return evidence and bounded proposals; they do not mutate canonical artifacts, derive the recommendation, expand scope, or delegate.

The hand-started launcher is local. It requires `wt`, resolves a disposable epoch checkout (`pr-<number>-R<epochOrdinal>`) before invoking this skill, and exports `PR_REVIEW_EPOCH`, `PR_REVIEW_CHECKOUT_BRANCH`, `PR_REVIEW_CHECKOUT_CREATED`, and `PR_REVIEW_OBSERVED_HEAD`. It passes `~/.cdx-artifacts/pr-reviews/<owner>--<repo>` as the artifact directory. It does not take the cloud path.

On a local review, prefer that checkout. Never switch to or mutate the user's PR branch worktree. Treat any non-epoch checkout and every reused checkout not created by this invocation as pre-existing and preserve it. Remove only a disposable epoch checkout this invocation created (`PR_REVIEW_CHECKOUT_CREATED=yes` or a checkout this workflow itself created), and only after valid artifacts are published and the pending GitHub review step has finished or been skipped.

On a cloud review, ignore the epoch branch-name requirement. Never call WorkTrunk. Never create a `pr-<number>-R<epoch>` worktree or branch. Never `git reset --hard` the project clone. `CHECKOUT_CREATED` stays `no`, and cleanup must not remove the clone.

Keep Linear, PR metadata, Git history, and the reviewed checkout read-only. Do not change issue state, edit reviewed files, reply on existing threads, or post issue comments. After successful artifact publication, the coordinator may create or extend an unpublished (`PENDING`) GitHub pull-request review per [pending-github-review.md](references/pending-github-review.md). Never submit or otherwise publish that review unless Drew explicitly asks in a later turn.

## Guidelines

- Review code, not the author.
- Do not block on taste.
- Do not invent missing requirements.
- Focus on changed behavior and its immediate callers, models, tests, history, and boundaries.
- Do not expand into unrelated refactoring requests.
- Skip generated files, lockfiles, binary assets, and prose-only files as primary review targets unless changed behavior depends on them.
- Focused reviewers load only stack skills named in their handoff; preserve unmatched-language limitations as coverage gaps.
- Prefer specific bug reports to vague discomfort.
- Preserve unexecuted, unavailable, pending, skipped, and failing checks as explicit evidence or coverage gaps.
