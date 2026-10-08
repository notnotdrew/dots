# Incremental Review Workflow

Use this workflow when the resolved GitHub PR already has a canonical review series, when `--full-rebuild` is explicitly selected, or when `--finding F<positive-integer>` requests one finding revision. Incremental review updates the same three canonical files; it never creates per-run or per-finding canonical artifacts.

Apply [review-contracts.md](../references/review-contracts.md) and reuse the coordinator stages in [standard-review.md](standard-review.md), including isolated gathering from [isolated-jobs.md](../references/isolated-jobs.md). Standard's initial-only series rejection and directory-rename publication do not apply to this update path. For explicit Deep mode, reuse the planning, broader-context, justified-overlap, readiness, and independent-verification requirements in [deep-review.md](deep-review.md), not its initial-series resolution or publication. This file defines recovery, same-head handling, inheritance, and update publication.

Keep Linear, PR metadata, Git history, and the review checkout read-only. Never change issue state, edit reviewed files, switch or mutate the user's PR branch worktree, reply on existing threads, post issue comments, or let a reviewer mutate canonical artifacts. After successful artifact publication, the coordinator may draft an unpublished (`PENDING`) GitHub review per Standard's pending-review step; never submit it unless Drew explicitly asks later. Artifact-series writes, that pending draft, and removal of a disposable epoch checkout created by this invocation remain coordinator-only operations.

## 1. Resolve The Existing Series And Recover First

Resolve owner, repository, PR number, `SERIES_PARENT`, and `SERIES_DIR` exactly as Standard does. Require `SERIES_DIR` to exist and contain the three canonical files. A full rebuild and a single-finding revision both require an existing series; they never create an initial review.

Before reading, validating, inheriting, or writing any canonical artifact, check:

```text
SERIES_DIR/.publish-in-progress
```

If no marker exists, continue. If it exists, perform startup recovery before creating or selecting a review checkout:

1. Require the marker to be a regular, non-symlink file, then read it strictly as data. Require exactly one absolute `BackupDirectory` and one absolute `StagingDirectory`.
2. Require both directories to be uniquely named siblings under `SERIES_PARENT`, to match this PR's update naming convention and the same update suffix, and not to be symlinks. Never evaluate marker content as shell code or follow a path outside `SERIES_PARENT`.
3. Require the backup to contain exactly `context-brief.md`, `findings-ledger.md`, and `perfect-review.md` as regular files. Validate the backup with `scripts/validate-review-artifacts`.
4. Restore all three canonical files from the backup. For each file, copy to a uniquely named same-filesystem temporary file inside `SERIES_DIR`, then `mv` that temporary file over the destination.
5. Remove only same-suffix publication temporary files created by the interrupted update. Require `SERIES_DIR` to contain the three canonical files plus only the recovery marker, and validate the restored destination while the marker remains.
6. Only after successful restoration and destination validation, remove the marker, the named staging directory if present, and the backup directory.

If the marker is malformed, the backup is missing or invalid, any restore fails, or the restored destination does not validate, stop without reading the series as review input. Preserve the marker and usable backup for manual recovery, report the exact blocker, and do not remove any checkout. Never assume a partially replaced destination is current.

After recovery, require the series to contain exactly the three regular canonical files and validate it before use. A partial series, unexpected in-series entry, or invalid artifact set is a blocker; do not repair it by inference. A sibling backup or staging directory without a marker is not recovery authority and must never be applied to the series.

## 2. Decide Whether This Head Needs A Run

The stable series identity remains owner, repository, and PR number. `CurrentEpoch` counts runs; observed SHAs are evidence only. The launcher exports `PR_REVIEW_EPOCH` for this run and names the disposable checkout `pr-<PR_NUMBER>-<epoch>`.

Compare the current GitHub `headRefOid` to the series' `ObservedHead`:

- Same head, readiness already `ready`, and neither `--full-rebuild` nor `--finding`: stop as a no-op. Do not create a checkout or rewrite artifacts. Report that the current head is already reviewed.
- Same head and prior readiness `UNABLE TO REVIEW`, without `--full-rebuild`: retry under the same `CurrentEpoch`. Reuse or recreate its checkout.
- Same head with `--full-rebuild`: take the next ordinal.
- Same head with `--finding`: follow Section 8 under the same `CurrentEpoch`.
- New head: take the next ordinal and a checkout at the new SHA.

A series written before `CurrentEpoch` existed has none. Treat it as R1 and write `CurrentEpoch` on this run's replacement artifacts. Older `## Review Epochs` and `## Amendments` sections are history; do not extend them, and drop them from the replacement files.

## 3. Resolve The Current Observation

Resolve the disposable checkout and the current GitHub head through Standard's read-only epoch-checkout process, targeting `pr-<PR_NUMBER>-<epoch>` for the ordinal selected in Section 2. Prefer launcher exports `PR_REVIEW_EPOCH`, `PR_REVIEW_CHECKOUT_BRANCH`, `PR_REVIEW_CHECKOUT_CREATED`, and `PR_REVIEW_OBSERVED_HEAD` when consistent with the selected ordinal and head. Use `scripts/resolve-review-checkout --ensure` when a checkout must be created or reused. Never select the user's PR branch worktree.

Record the full current head and actual merge-base. Re-query the head after gathering and before staging; do not combine revisions.

If Section 2 selected a same-head no-op, return that result without gathering or publication.

Launch Standard's isolated context gatherer against `REVIEW_DIR` for the current head. Create `WORK_DIR` first as in `isolated-jobs.md`. Pass `PriorReview` with the prior observed head, the canonical `context-brief.md` path, and the comparison the gatherer should run. Do not gather current-head evidence or read changed source files in the coordinator session.

The gatherer records the relationship in the new brief's `SincePriorHead` and nothing more. Inheritance is yours: read the prior brief as an index of what was examined, the new brief for what changed, and judge from both:

- changed symbols, contracts, configuration, schemas, migrations, tests, and generated effects;
- callers, consumers, models, persistence state, and one-hop dependencies affected by those changes; and
- prior evidence whose command result, external state, line anchor, historical assumption, or test conclusion may no longer hold.

Record whether the update is additive, corrective, superseding, a rebase or history rewrite, or broadly invalidating. A SHA change alone neither proves a behavioral change nor invalidates review-series or finding identity. A same-head readiness retry reopens current-head evidence without treating the prior unable outcome as proof.

## 4. Build Changed And Dependency-Affected Scope

Create an affected-scope map from the two briefs and the prior ledger before inheriting anything. Do not re-trace callers in the coordinator session.

```text
AffectedScope:
  DirectChanges: <files, symbols, contracts, tests, migrations, and behavior changed since the prior head>
  DependencyAffected: <callers, consumers, models, schemas, state, boundaries, tests, and historical assumptions affected transitively>
  PriorEvidenceAffected: <prior context and finding evidence made stale or uncertain>
  Unaffected: <prior context and findings with a recorded reason inheritance remains safe>
```

Dependency-affected scope includes unchanged code when a changed contract, state shape, authorization rule, failure behavior, ordering guarantee, configuration value, or test oracle changes the meaning of that code. Do not limit re-review to files in the latest patch. Stop relationship tracing at a defensible boundary and record any unresolved material reach as coverage and readiness evidence.

Inheritance must be explicit and evidence-backed: carry a prior coverage record or finding forward only with the comparison evidence that says its behavior and assumptions are unaffected. Never copy the previous final recommendation as the current outcome or treat an unchanged line anchor as proof of unchanged behavior.

## 5. Choose Incremental Or Full Rebuild

Use incremental inheritance by default. Select a full rebuild only when:

- `--full-rebuild` was explicitly requested; or
- broad invalidation makes inherited context unsafe, such as rewritten architecture, widespread contract or schema changes, an untrustworthy prior artifact basis, or an affected dependency graph that cannot be bounded reliably.

If broad invalidation is discovered without an explicit flag, record the reason and perform the required full rebuild rather than pretending inheritance is safe. Do not use full rebuild merely because the head SHA changed or because a narrow update touches a prior finding.

A full rebuild reruns the selected mode's complete context, readiness, discovery, synthesis, and verification stages against the current head. It rewrites the context and coverage but keeps every finding record and its `DispositionHistory`. Reuse a stable finding ID when the same behavioral claim still exists. Allocate a new ID only for a genuinely new behavioral claim.

For a normal incremental run:

1. retain explicitly inherited context and findings;
2. use the current-head gatherer brief for direct and dependency-affected context under the selected mode;
3. invalidate stale evidence before relying on it;
4. revalidate every prior finding affected by the update; if a terminal dismissed or superseded claim becomes actionable again, preserve it and create a new linked ID rather than reviving it;
5. select focused reviewers for newly relevant or changed risks;
6. synthesize new candidates together with affected prior findings through the shared synthesis boundary; and
7. derive current coverage, verdicts, and outcome from the resulting current ledger state.

Explicit Deep mode applies the Deep planning and overlap rules to affected and broadly relevant scope. Before a Deep final compilation, independently verify every finding retained in the current review, including an inherited finding whose prior run lacks current, independent evidence.

## 6. Preserve Stable Finding Identity And History

A stable finding ID follows the behavioral claim, not wording, reviewer, line, commit, or run.

- Keep the same ID when new evidence confirms, refutes, narrows, broadens without changing identity, or relocates the same claim.
- Append to `DispositionHistory` with the run, reason, and evidence; never rewrite an earlier entry.
- Keep dismissed and superseded records inspectable.
- Use `DuplicateOf` only for the same semantic claim represented by another record.
- When changed behavior requires a materially different claim, retain the old record, mark it `superseded`, and create a new ID whose `Supersedes` names the old ID.
- Assign new IDs monotonically after the highest ID ever used in the series. Never recycle an ID.

When the recommendation changes, note the previous outcome and the cause in the `Readiness Summary` of the regenerated `perfect-review.md`.

## 7. Handle Rebases Without Identity Drift

Treat a rebase or history rewrite as evidence change, not identity change. Record the newly observed head and merge-base. Compare old and new patch behavior using content, symbols, tests, and contracts rather than commit correspondence alone.

Revalidate evidence tied to old object IDs, line anchors, blame, or commit topology. Preserve a finding ID when its behavioral claim still applies; dismiss, revalidate, or supersede it only from current evidence, and say in `DispositionHistory` that anchors were revalidated after a rebase.

A pure rebase may inherit semantically unaffected context after that equivalence is evidenced. It must not rename the series or regenerate finding IDs.

## 8. Revise One Finding

`--finding` requires one existing ID matching `F0*[1-9][0-9]*`. Match it to the stored record with the same integer, regardless of padding (`F1`, `F01`, and `F001` are the same ID). Use that record's stored spelling in artifacts. It implies Standard verification depth and is incompatible with Deep mode and full rebuild.

Load only:

- the target finding and its complete `DispositionHistory`;
- its duplicate and supersession links;
- context, coverage, source, caller, model, test, history, and external evidence linked to its behavioral claim;
- the current final-review references to that finding; and
- enough PR identity and head evidence to establish whether the linked scope changed.

Do not reopen unrelated findings or claim broader review coverage. Reopen decisive evidence under the shared Standard synthesis rules, then append the result to the finding's `DispositionHistory`, preserving the previous claim, disposition, evidence, and reason. Regenerate the entire current `perfect-review.md` from the current ledger and coverage so stale references or outcomes cannot survive.

When the head changed, use single-finding revision only if comparison proves the entire direct and dependency-affected delta is bounded to the target finding's linked scope. Revalidate that scope and explicitly inherit unaffected records. If any other material scope changed or the delta cannot be bounded, stop and require a normal incremental review; do not publish a final review that implies the new head was reviewed globally.

If the target is superseded, follow links to current evidence but amend the requested record and linked current record explicitly. Never silently substitute another ID.

## 9. Compile Staged Replacements

Compile the current state through the shared Standard or Deep rules. All three artifacts must agree on `CurrentEpoch`, observed head, mode, readiness, coverage, and stable IDs. Prior judgments remain in the ledger's `DispositionHistory`.

Choose one unique update suffix and create two sibling directories under `SERIES_PARENT` on the same filesystem:

```text
<SERIES_PARENT>/.pr-<PR_NUMBER>.review-backup.<unique-suffix>
<SERIES_PARENT>/.pr-<PR_NUMBER>.review-staging.<unique-suffix>
```

Copy the current three canonical files to the backup directory before writing replacements. Require the backup to contain exactly those three regular files and validate it. Write exactly the three complete replacement files to staging from the templates, require no other entry, and run `scripts/validate-review-artifacts` on staging. If it fails, fix the field it names from the template and rerun; do not open the script to learn the format. Do not modify the destination while either set is incomplete or invalid.

## 10. Publish With Recoverable Replacement

Publication updates three files and is recoverable, but it is not cross-file atomic. Never describe it as atomic.

After backup and staging validate, require that no marker exists. Create `SERIES_DIR/.publish-in-progress` before the first canonical replacement without overwriting an existing marker: write `<marker>.publish-tmp.<update-suffix>` in `SERIES_DIR`, atomically link it to the marker path with `ln`, then remove the temporary name. If the link fails, leave the destination untouched, remove only this update's temporary and sibling directories, and stop; report a concurrent marker if one appeared, otherwise report the marker-creation failure. Its data is:

```text
BackupDirectory: <absolute-backup-directory>
StagingDirectory: <absolute-staging-directory>
```

Require the marker to name the exact directories created for this update. Then, in the fixed order `context-brief.md`, `findings-ledger.md`, `perfect-review.md`:

1. copy the staged file to `<artifact-name>.publish-tmp.<update-suffix>` inside `SERIES_DIR`;
2. require the temporary file to be a regular file on the destination filesystem; and
3. `mv` it over the canonical destination.

If any copy, check, or replacement fails, immediately restore all three files from the backup through new same-filesystem temporary files and `mv`, then remove only publication temporaries bearing this update's suffix. After all replacements, require the destination to contain exactly the three canonical files plus the marker and validate the destination while the marker remains. If destination validation fails, immediately perform the same complete restoration and temporary cleanup.

After a successful restoration, validate the restored destination before removing the marker, staging, and backup. Report the update as failed even though the previous review was recovered. If restoration or restored validation fails, leave the marker and backup in place for startup recovery and report manual intervention; do not continue or clean up a checkout.

Only when all three replacements and destination validation succeed may the coordinator remove the marker, then the staging and backup directories. Successful marker removal commits the validated publication; retry and report any failure to remove the now-nonauthoritative sibling directories, but never apply them without a marker. An unrelated or unrecognized entry is never deleted.

Do not clean up a disposable epoch checkout created by this invocation until publication succeeds and Standard's pending GitHub review step has finished or been skipped. On any recovery, staging, validation, replacement, restoration, or marker-removal failure, preserve that checkout and `WORK_DIR` and report their ownership and path. A sibling-directory cleanup warning after successful marker removal does not invalidate the publication. After successful publication, run Standard's pending unpublished GitHub review step (skip on same-head no-ops). Then apply Standard's checkout rule: remove only a disposable epoch checkout that this workflow or its launcher marked as created for this invocation; never remove the user's PR branch worktree. Also remove `WORK_DIR`.

## 11. Return

Return:

- `CurrentEpoch` and review kind;
- current recommendation or concrete `UNABLE TO REVIEW` details;
- absolute series directory and the three canonical filenames;
- previous and current observed heads, noting any rebase;
- inherited, revalidated, invalidated, and dependency-affected scope;
- stable IDs whose disposition changed in this run;
- material coverage or verification gaps;
- whether publication or restoration occurred;
- pending GitHub review status (skipped, drafted unpublished with review id and comments, or failed), noting that it was not published; and
- checkout cleanup status.
