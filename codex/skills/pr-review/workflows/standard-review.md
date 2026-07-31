# Initial Standard Review Workflow

Use this workflow for an initial Standard review only. The coordinator owns checkout decisions, scope, readiness, reviewer handoffs, the candidate ledger, canonical artifact content, publication, and owned-checkout cleanup.

Apply [review-contracts.md](../references/review-contracts.md), gather evidence with [context-gathering.md](../references/context-gathering.md), select reviewers with [reviewer-orchestration.md](../references/reviewer-orchestration.md), synthesize findings with [finding-synthesis.md](../references/finding-synthesis.md), and compile verdicts with [perfect-principles.md](../references/perfect-principles.md). Compile the exact shapes in [context-brief.md](../templates/context-brief.md), [findings-ledger.md](../templates/findings-ledger.md), and [perfect-review.md](../templates/perfect-review.md).

This file is the initial Standard route and the shared coordinator-stage definition. For an initial Deep review, apply the substitutions in [deep-review.md](deep-review.md). For an existing series, full rebuild, or single-finding revision, use [incremental-review.md](incremental-review.md), which reuses these stages while owning epochs, inheritance, amendments, recovery, and replacement publication. Do not introduce those update mechanics into this initial route. A Standard review may recommend a later Deep review, but it must not switch modes.

## Coordinator Invariants

- Keep GitHub, Linear, Git, repository inspection, and all reviewers read-only.
- Never post a GitHub review or comment, update Linear, mutate the PR, or edit the reviewed checkout.
- Only the coordinator assigns stable finding IDs, changes ledger dispositions, derives PERFECT verdicts, writes canonical artifacts, publishes them, or removes an owned checkout.
- Focused and synthesis reviewers must not delegate, mutate artifacts, or return a final recommendation.
- Use the same resolved PR identity, `ObservedHead`, mode, mode-selection provenance, readiness, and coverage records in all three artifacts.
- Preserve every unmatched-language limitation and every unexecuted, unavailable, pending, skipped, or failing check. Never convert any of them into passing or reviewed evidence.
- Do not overwrite, merge with, or partially repair an existing review series in this route. Hand it to the incremental workflow.

## 1. Resolve Invocation, Identity, And Initial Artifact Path

Retain the absolute directory in which the workflow was invoked as `INVOCATION_DIR`. Resolve all skill helpers from the skill directory, not from the reviewed repository.

Accept one GitHub PR number or URL and Standard mode only. Omitted mode means:

```text
Mode: Standard
ModeSelection: default
```

An explicit Standard request means `ModeSelection: explicit`. The entry point routes explicit Deep, existing-series, full-rebuild, and single-finding requests before this workflow begins. If one reaches this route, stop and report the routing mismatch; do not silently run Standard instead.

Run `scripts/gh-pr-parse` against the original reference:

```bash
"<skill-directory>/scripts/gh-pr-parse" "$PR_REF"
```

Keep parsed data as data, never as shell code.

- For a URL, use the parsed owner, repository, and PR number.
- For a numeric reference, run `gh repo view --json nameWithOwner --jq '.nameWithOwner'` from `INVOCATION_DIR`. Require exactly one non-empty `owner/repository` result before continuing.
- Do not infer identity from a checkout path, remote name, branch name, or PR head SHA.

Derive:

```text
SERIES_PARENT = ~/.cdx-artifacts/pr-reviews/<OWNER>--<REPOSITORY>
SERIES_DIR    = <SERIES_PARENT>/pr-<PR_NUMBER>
```

Expand `~` to an absolute home-directory path before invoking tools. The series identity is owner, repository, and PR number; revisions are evidence only.

This workflow is initial-review-only. Before creating a checkout or staging directory:

1. If `SERIES_DIR` contains any canonical artifact, stop without changing it and route the request through the incremental workflow.
2. If `SERIES_DIR` exists in any other form, including an empty directory or partial/noncanonical content, stop without changing it. Report the collision and require the user to resolve it.
3. Do not create `SERIES_DIR` yet. It must remain absent until publication.

If identity cannot be resolved, no stable artifact path exists. Report the identity blocker and stop; do not publish artifacts under a guessed path.

## 2. Resolve Checkout Ownership

Query the PR explicitly as `OWNER/REPOSITORY` and obtain its full `headRefOid` before deciding whether a checkout is needed.

First inspect `INVOCATION_DIR`. It is a usable pre-existing checkout only when all of these are true:

- it is a Git worktree for `OWNER/REPOSITORY`;
- its current `HEAD` is exactly the observed GitHub `headRefOid`;
- it is clean enough for read-only review; and
- it contains the PR files needed for the comparison.

When those conditions hold:

```text
REVIEW_DIR = INVOCATION_DIR
CHECKOUT_CREATED_BY_THIS_INVOCATION = no
```

This includes a checkout created by the launcher before the skill started. Its origin outside this workflow makes it pre-existing and it must be preserved.

Otherwise this is a direct invocation that needs a checkout. Validate the reference, convert a numeric reference to `pr:<number>` for WorkTrunk, and run:

```bash
wt switch --no-cd --format json "$WORKTRUNK_REF"
```

Require one absolute `.path` and one `.action` from the JSON. Set `REVIEW_DIR` to that path. Set `CHECKOUT_CREATED_BY_THIS_INVOCATION=yes` only when this workflow itself ran `wt switch` and its returned action is exactly `created`. Every other action means `no`.

After selection, require `git -C "$REVIEW_DIR" rev-parse HEAD` to equal the observed full head SHA. A mismatch is a readiness blocker; never switch or mutate a pre-existing checkout to make it match.

Record checkout ownership separately from readiness. Setup failure does not grant permission to remove a checkout. Never remove a launcher-created, selected, reused, or otherwise pre-existing checkout.

## 3. Gather The Context Brief

From `REVIEW_DIR`, follow `context-gathering.md` completely:

1. Gather the expanded GitHub metadata, full GitHub patch, check output and exit status, and changed paths.
2. Resolve the observed base object and actual merge-base. Compare the merge-base-to-observed-head local diff with the GitHub patch.
3. Read every changed source file in full, subject to the documented exclusions.
4. Trace changed behavior only through immediate callers, entry points, models, schemas, persistence state, interfaces, one-hop dependencies, and changed or neighboring tests.
5. Use bounded repository search and relevant recent Git history to answer concrete review questions.
6. Detect and consult identifiable associated Linear issues through an available authenticated integration, read-only. Record ambiguity or inaccessibility rather than guessing.
7. Re-query the PR head after gathering and do not combine evidence from different heads.
8. Record concrete size, security, data, boundary, failure, evidence-quality, reviewability, and release-state signals.

Load every matching installed stack skill identified by `language-skill-mapping.md`. For changed languages with no mapping, record the files or language, available general capability, evidence examined, affected coverage, and materiality. Continue with general engineering judgment only when the technology remains reviewable.

Record checks observed on GitHub separately from tests or checks executed during this run. For each relevant check not executed, record its name, observed state, why it was not run, affected behavior or coverage, and materiality. Preserve failing conclusions exactly.

Populate a complete in-memory context brief before reviewer selection. It must already include identity, intent, current and desired state, observed revisions, relationships, tests and execution status, Linear evidence, risk signals, initial coverage targets, and known gaps.

## 4. Assess Initial Readiness

Apply the readiness gate in `review-contracts.md` after context gathering and before finding discovery. Append the initial decision and reasons to `ReadinessHistory`.

Readiness is `ready` only when Standard can defensibly review changed behavior and its immediate boundaries with the available intent, required evidence, stable scope, supported technology, and reviewer capability.

For `UNABLE TO REVIEW`, record all of:

- `Blocker`;
- `GatheredEvidence`;
- `AffectedCoverage`; and
- concrete `Remediation`.

Missing optional evidence is a named gap, not automatically a failure. Unsupported technology, unstable revisions, inaccessible required evidence, unreasonable Standard scope, or purpose that cannot otherwise be established is a failure.

### Failed-Readiness Path

When initial readiness fails:

1. Launch no focused or synthesis reviewer.
2. Build a partial but truthful context brief from gathered evidence.
3. Build an empty terminal findings ledger containing `No findings.`, readiness metadata, `UnresolvedMaterialDecisions`, and coverage.
4. Build a final PERFECT artifact with `UnableToReview`, not `Recommendation`.
5. If no review occurred, add coverage affecting all six evaluable principles with `State: unable-to-review` and `Material: yes`; derive all six verdicts as `UNREVIEWED` and Taste as `N/A`.
6. Continue to staging, validation, and initial publication. A readiness failure is a review outcome, not a publication failure.

Do not clean up an owned checkout until these three artifacts have been published successfully.

## 5. Select And Launch Focused Reviewers

Proceed only while readiness is `ready`.

Apply every matching selection rule in `reviewer-orchestration.md`: security, data integrity, boundary integration, test evidence, and correctness and edge cases. If none applies, select one general changed-behavior reviewer. Combine coherent overlapping scopes; do not add a fixed roster or one reviewer per PERFECT principle.

Before launch:

- create a coverage target for every selected or known concern;
- enumerate each changed or relationship-affected cross-subsystem behavior;
- assign each boundary one primary owner and name both sides and the invariant;
- ensure unmatched-language and check-execution gaps remain represented; and
- create the complete bounded handoff required by `reviewer-orchestration.md`.

Launch independent focused reviewers concurrently in one batch only when their assignments are self-contained, their scopes and boundary ownership are explicit, they read the same immutable observed head, and no assignment depends on another's output. Sequence dependent assignments. Concurrency does not justify duplicate reviewers or Deep-style intentional overlap.

Use Bugbot or Security Review only when it fits a selected bounded assignment. Follow its strict target, branch-diff, and one-retry contract. Tool absence is not a gap when another capable reviewer covers the concern.

Wait for every launched discovery reviewer to return before synthesis. Convert a repeated tool failure, incomplete promised scope, head mismatch, or unavailable capability into an explicit coverage gap. A no-finding result must still name evidence examined and completed coverage.

## 6. Build The Candidate Ledger And Renew Readiness

Validate each reviewer result against its assignment and observed head. Preserve all concrete candidates, completed coverage, gaps, evidence, source-reviewer identity, and retained raw-output references.

Build the candidate ledger as follows:

1. Ingest every returned candidate; do not discard weak, duplicated, disputed, or apparently misclassified reports.
2. Normalize each into one falsifiable behavioral claim without inventing evidence.
3. Collect the complete batch before assigning IDs.
4. Sort by proposed PERFECT priority, affected behavior, normalized claim, scope, and reviewer identifier.
5. Assign stable PR-scoped IDs `F001`, `F002`, and so on.
6. Give every record an initial `candidate` disposition and provenance-rich history.
7. Convert completed promised scope to `reviewed` only after checking the return against the handoff. Preserve all incomplete scope as coverage gaps.

If any reviewer reports a material limitation or `EscalateReadiness: yes`, return to the readiness gate before synthesis. Append the renewed decision and reason to `ReadinessHistory`.

- Narrow only a genuinely non-material gap, retain it explicitly in coverage and verification gaps, and continue while readiness remains `ready`.
- If the limitation prevents a defensible Standard recommendation, set final readiness to `UNABLE TO REVIEW`. Do not manufacture, dismiss, or weaken a finding to avoid that result, and do not switch to Deep.

For renewed `UNABLE TO REVIEW`, retain all gathered evidence and provenance, ensure every candidate that can be adjudicated has an evidence-supported terminal disposition, and represent evidence that cannot support a finding as coverage rather than a fabricated claim. A candidate blocked from adjudication by the same material evidence gap may remain `candidate` only when its failed verification and qualifying coverage or readiness escalation are recorded and the final outcome is `UnableToReview`.

## 7. Run Bounded Synthesis

When candidates exist and readiness permits synthesis, launch exactly one synthesis reviewer after discovery completes. Give it only the bounded packet defined in `finding-synthesis.md`: compact relevant context, complete candidate records, verification reasons, directly available scope, permitted evidence, exclusions, and known gaps.

The synthesis reviewer must:

- compare semantic behavior and claims rather than wording or line anchors;
- merge provenance into one representative while preserving duplicate records;
- select the earliest applicable PERFECT principle;
- record and resolve disagreements from evidence, not votes;
- perform additional Standard verification for every blocking, disputed, or weakly evidenced candidate;
- personally reopen decisive evidence before retaining a material claim; and
- return one normalized update for every candidate plus coverage, verification, unresolved-decision, and readiness updates.

It must not mutate artifacts, derive the recommendation, broaden into Deep context, or delegate.

If there are no candidates, do not launch synthesis merely to confirm an empty ledger. The coordinator still finalizes coverage and outcome.

Validate the synthesis response before applying it:

- every input ID has exactly one update;
- representatives, duplicates, and supersession links resolve;
- merged provenance is not lost;
- Purpose findings are blocking;
- Clarity and Taste findings are advisory;
- required verification is evidenced; and
- no `candidate` remains when the final outcome can be a definitive recommendation.

Apply normalized updates and append, never replace, disposition history. Keep dismissed, duplicate, and superseded records in the ledger. Only verified records are retained in the final review.

If synthesis escalates a new material limitation, renew readiness again using the rules above. Append the decision, preserve the limitation as coverage, and produce `UNABLE TO REVIEW` when it remains material. Do not convert inability to verify into an advisory concern or an automatic Deep run.

## 8. Compile The Three Artifacts

Derive final coverage first. Preserve the same complete coverage records in all three artifacts, including unmatched-language and unexecuted-check gaps.

Then derive, in order:

1. final readiness;
2. `UnresolvedMaterialDecisions`;
3. retained verified blocking and advisory findings;
4. ordered PERFECT verdicts under `review-contracts.md`; and
5. exactly one outcome.

Use `UNABLE TO REVIEW` when readiness failed, a material scoped gap could change the recommendation, or Purpose coverage is unresolved. Otherwise use `REQUEST CHANGES` for any retained verified blocker, `NEEDS DISCUSSION` for an unresolved material decision without a blocker, and `APPROVE` in all other cases.

Place every retained verified finding exactly once under its earliest applicable principle. Omit empty finding sections. Keep all non-retained records in the ledger. Put explicit missing evidence and unexecuted checks in verification gaps even when they are non-material.

Create `SERIES_PARENT`, but keep `SERIES_DIR` absent. Create a uniquely named temporary staging directory as a sibling of `SERIES_DIR` on the same filesystem, for example:

```text
<SERIES_PARENT>/.pr-<PR_NUMBER>.standard-review-staging.<unique-suffix>
```

Write exactly these files into staging:

```text
context-brief.md
findings-ledger.md
perfect-review.md
```

Do not write raw output, logs, markers, backups, epochs, or temporary fragments into the staging directory. Before validation, require that the staging directory contains exactly those three regular files and no other entry.

## 9. Validate And Publish The Initial Review

Run the validator against staging:

```bash
"<skill-directory>/scripts/validate-review-artifacts" "$STAGING_DIR"
```

If validation fails, correct the staged artifacts and rerun validation. Do not publish an invalid set. If the defects cannot be corrected without inventing evidence or violating a contract, report the blocker, leave `SERIES_DIR` untouched, and do not clean up an owned checkout.

Immediately before publication, require again that `SERIES_DIR` does not exist and staging contains exactly the three validated canonical files. If the destination appeared, stop without overwriting or merging it.

Publish the initial review by renaming the entire same-filesystem staging directory to `SERIES_DIR` in one operation. Do not copy or move the three canonical files one at a time. This initial-only publication relies on an absent destination and directory rename; do not add Phase 3 backup, amendment, or `.publish-in-progress` marker behavior.

After the rename:

1. require that `SERIES_DIR` contains exactly the three canonical files and no other entry;
2. rerun `validate-review-artifacts` against `SERIES_DIR`; and
3. treat publication as successful only if both checks pass.

Never replace an existing canonical file. A publication collision or post-publication validation failure is a blocker requiring manual inspection; do not improvise an update or cleanup protocol.

## 10. Cleanup And Return

Only after successful publication, remove the checkout when:

```text
CHECKOUT_CREATED_BY_THIS_INVOCATION = yes
```

Use:

```bash
wt remove --yes --foreground "$REVIEW_DIR"
```

Never remove a launcher-created or other pre-existing checkout. Never remove any checkout after failed identity resolution, failed readiness publication, staging failure, validation failure, or publication failure. Failed readiness with successfully published artifacts is successful publication and therefore permits cleanup of a directly owned checkout.

Return:

- the final recommendation or concrete `UNABLE TO REVIEW` details;
- the absolute canonical artifact directory and the three filenames;
- the observed head and Standard mode-selection provenance;
- material coverage and verification gaps, including unmatched languages and unexecuted checks;
- whether a later Deep review is recommended, without claiming it ran; and
- checkout cleanup status, distinguishing removed direct-invocation checkout from preserved pre-existing checkout.
