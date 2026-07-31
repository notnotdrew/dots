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
pr-review --finding F001 42
```

Prerequisites:
- `git`
- `gh`
- `jq`
- `wt` (WorkTrunk)
- `agent` when using the launcher
- GitHub auth configured for the target repo

Use [scripts/gh-pr-parse](scripts/gh-pr-parse) to validate and parse the reference. Resolve the helper relative to this skill directory.

## Inputs

- **PR number**: e.g. `42`
- **PR URL**: e.g. `https://github.com/org/repo/pull/42`
- **Mode**: omitted or `--mode standard` for Standard; `--mode deep` for explicit Deep
- **Update controls**: `--full-rebuild` or `--finding F<positive-integer>`

Both forms must be run from the target repository so WorkTrunk can create or locate the PR checkout.

Standard is the omitted-mode default. Deep must be selected explicitly and never results from automatic escalation.

`--finding` requires an existing review series and one existing ID matching `F0*[1-9][0-9]*`. Display the normalized ID with at least three digits, allow additional digits, and use Standard verification depth. It is incompatible with `--mode deep` and `--full-rebuild`. A full rebuild also requires an existing series.

## Workflow Routing

Resolve PR identity and the canonical series path before choosing a workflow:

1. If the canonical series path is absent, use [standard-review.md](workflows/standard-review.md) for omitted or explicit Standard, or [deep-review.md](workflows/deep-review.md) for explicitly selected Deep.
2. If the series path exists, route to [incremental-review.md](workflows/incremental-review.md) before inspecting its contents so that workflow can recover an interrupted publication or report a precise collision. Inherit unaffected evidence by default; `--full-rebuild` selects its full-rebuild path under the selected mode.
3. Reject `--full-rebuild` or `--finding` when the series path is absent. An empty, partial, invalid, or noncanonical existing path is a collision or recovery blocker, not an initial review.

The selected workflow owns the complete procedure. Do not replace it with an inline single-agent review or duplicate Standard stages in the entry point.

## Shared Workflow Boundaries

Every route reuses the contracts and Standard coordinator stages for readiness, bounded synthesis, ledger-derived PERFECT compilation, exactly-three-file persistence, and ownership-aware cleanup. Deep changes planning, context breadth, justified reviewer overlap, and verification depth. Incremental review adds recovery, epochs, inheritance, amendments, and recoverable replacement while preserving those shared boundaries.

Standard may recommend a later Deep review but must complete under Standard guarantees or return `UNABLE TO REVIEW`. Deep must independently verify every retained actionable finding. Incremental review revalidates changed and dependency-affected scope, preserves unaffected history, and performs a full rebuild only when explicitly requested or when broad invalidation makes inheritance unsafe.

## Required Contracts And Procedures

- [review-contracts.md](references/review-contracts.md) defines mode guarantees, readiness, coverage, finding identity, persistence, and outcome derivation.
- [context-gathering.md](references/context-gathering.md) defines GitHub, Git, repository, test, relationship, history, and Linear evidence.
- [reviewer-orchestration.md](references/reviewer-orchestration.md) defines risk-selected reviewer scopes, cross-boundary ownership, handoffs, returns, and concurrency.
- [finding-synthesis.md](references/finding-synthesis.md) defines candidate ingestion, semantic deduplication, selective verification, disagreement handling, and normalized ledger updates.
- [perfect-principles.md](references/perfect-principles.md) defines ordered PERFECT evaluation and ledger-aware compilation.
- [language-skill-mapping.md](references/language-skill-mapping.md) selects relevant installed stack skills from changed files.

Use the canonical shapes without creating a fourth handoff artifact:

- [context-brief.md](templates/context-brief.md)
- [findings-ledger.md](templates/findings-ledger.md)
- [perfect-review.md](templates/perfect-review.md)

Validate the staged artifact directory with [validate-review-artifacts](scripts/validate-review-artifacts) before publication.

## Ownership And Safety

The coordinator alone owns mode and route selection, readiness, reviewer scope, cross-boundary ownership, stable finding IDs, canonical artifact writes, final compilation, publication, and checkout cleanup. Focused and synthesis reviewers return evidence and normalized proposals; they do not mutate canonical artifacts, derive the recommendation, expand scope, or delegate.

The launcher enters a WorkTrunk checkout before invoking this skill. Treat that checkout, every reused checkout, and every checkout not created by this direct invocation as pre-existing. Preserve it. Remove only a checkout that this invocation created itself, and only after valid artifacts are published.

Keep GitHub, Linear, PR state, Git history, and the reviewed checkout read-only. Do not submit reviews, post comments, change issue state, mutate the pull request, or edit reviewed files.

## Guidelines

- Review code, not the author.
- Do not block on taste.
- Do not invent missing requirements.
- Focus on changed behavior and its immediate callers, models, tests, history, and boundaries.
- Do not expand into unrelated refactoring requests.
- Skip generated files, lockfiles, binary assets, and prose-only files as primary review targets unless changed behavior depends on them.
- Load only stack skills that match changed files; preserve unmatched-language limitations as coverage gaps.
- Prefer specific bug reports to vague discomfort.
- Preserve unexecuted, unavailable, pending, skipped, and failing checks as explicit evidence or coverage gaps.
