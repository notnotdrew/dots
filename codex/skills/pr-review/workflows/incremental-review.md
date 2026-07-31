# Incremental Review Workflow

Use this workflow when the resolved GitHub PR already has a canonical review series, when `--full-rebuild` is explicitly selected, or when `--finding F<positive-integer>` requests one finding revision. Incremental review updates the same three canonical files; it never creates per-epoch or per-finding canonical artifacts.

Apply [review-contracts.md](../references/review-contracts.md) and reuse the coordinator stages in [standard-review.md](standard-review.md). Standard's initial-only series rejection and directory-rename publication do not apply to this update path. For explicit Deep mode, reuse the planning, broader-context, justified-overlap, readiness, and independent-verification requirements in [deep-review.md](deep-review.md), not its initial-series resolution or publication. This file defines recovery, epochs, inheritance, invalidation, amendments, and update publication.

Keep GitHub, Linear, the PR, Git history, and the review checkout read-only. Never post a review or comment, change issue state, edit reviewed files, switch a pre-existing checkout, or let a reviewer mutate canonical artifacts. Artifact-series writes and removal of a checkout created by this invocation remain coordinator-only operations.

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

## 2. Normalize Epoch History

The stable series identity remains owner, repository, and PR number. Epochs are ordinal review events; observed SHAs are evidence only.

An unnormalized initial-review set has no epoch metadata. On its first successful update:

1. represent the complete prior initial review as `R1` in all three replacement artifacts;
2. preserve its recorded mode, selection provenance, revisions, readiness, coverage, findings, dispositions, verdicts, and outcome as the prior judgment; record the R1 revision, finding states, and inheritance in the shared epoch fields;
3. preserve every existing finding ID exactly; and
4. append `R2` for the update, even when it examines the same head.

Perform this normalization only in staged replacements. The existing files remain untouched until recoverable publication.

After normalization, a normal re-review, targeted update on a new head, rebase review, or full rebuild appends the next gap-free epoch. Each epoch uses the exact shared epoch fields in `review-contracts.md`; current top-level fields and amendments carry the resulting readiness, coverage, ledger, verdict, and outcome changes.

When the series already has epochs, require them to begin at `R1`, increase by one, and agree across all three artifacts. The next epoch is one greater than the current highest epoch. Never derive an epoch number from a SHA or discard an epoch whose recommendation later changed.

## 3. Resolve The Current Observation

Resolve checkout ownership and the current GitHub head through Standard's read-only process. Record the full current head and actual merge-base for the current or new epoch as applicable. Re-query the head after gathering and before staging; do not combine revisions.

Compare the previous epoch's observed head and scope with the current observation. Use the previous artifact evidence as an index, not as proof that current behavior is unchanged. Inspect:

- the previous-head-to-current-head content change when the objects have a usable ancestry relationship;
- the prior and current merge-base-to-head patches when history was rewritten;
- changed symbols, contracts, configuration, schemas, migrations, tests, and generated effects;
- callers, consumers, models, persistence state, and one-hop dependencies affected by those changes; and
- prior evidence whose command result, external state, line anchor, historical assumption, or test conclusion may no longer hold.

Record whether the update is additive, corrective, superseding, a rebase or history rewrite, or broadly invalidating. A SHA change alone neither proves a behavioral change nor invalidates review-series or finding identity.

## 4. Build Changed And Dependency-Affected Scope

Create an affected-scope map before inheritance:

```text
AffectedScope:
  DirectChanges: <files, symbols, contracts, tests, migrations, and behavior changed since the prior epoch>
  DependencyAffected: <callers, consumers, models, schemas, state, boundaries, tests, and historical assumptions affected transitively>
  PriorEvidenceAffected: <prior context and finding evidence made stale or uncertain>
  Unaffected: <prior context and findings with a recorded reason inheritance remains safe>
```

Dependency-affected scope includes unchanged code when a changed contract, state shape, authorization rule, failure behavior, ordering guarantee, configuration value, or test oracle changes the meaning of that code. Do not limit re-review to files in the latest patch. Stop relationship tracing at a defensible boundary and record any unresolved material reach as coverage and readiness evidence.

For every prior context item, coverage record, finding, and decisive evidence item, mark exactly one current treatment:

- `inherited`: the underlying behavior and assumptions are unaffected, with the comparison evidence supporting inheritance;
- `revalidated`: changed or dependency-affected evidence was reopened and remains valid for the current head;
- `invalidated`: the evidence or conclusion no longer supports current judgment, with the invalidating change named; or
- `superseded`: a new context statement or finding represents changed behavior, with a resolvable amendment link.

Inheritance must be explicit and evidence-backed. Never copy the previous final recommendation as the current outcome or treat an unchanged line anchor as proof of unchanged behavior.

## 5. Choose Incremental Or Full Rebuild

Use incremental inheritance by default. Select a full rebuild only when:

- `--full-rebuild` was explicitly requested; or
- broad invalidation makes inherited context unsafe, such as rewritten architecture, widespread contract or schema changes, an untrustworthy prior artifact basis, or an affected dependency graph that cannot be bounded reliably.

If broad invalidation is discovered without an explicit flag, record the reason and perform the required full rebuild rather than pretending inheritance is safe. Do not use full rebuild merely because the head SHA changed or because a narrow update touches a prior finding.

A full rebuild reruns the selected mode's complete context, readiness, discovery, synthesis, and verification stages against the current head. It replaces the current context and ledger view but preserves every earlier epoch, finding record, disposition entry, amendment, prior verdict, and prior outcome in history. Reuse a stable finding ID when the same behavioral claim still exists. Allocate a new ID only for a genuinely new behavioral claim.

For a normal incremental run:

1. retain explicitly inherited context and findings;
2. regather direct and dependency-affected context under the selected mode;
3. invalidate stale evidence before relying on it;
4. revalidate every prior finding affected by the update; if a terminal dismissed or superseded claim becomes actionable again, preserve it and create a new linked ID rather than reviving it;
5. select focused reviewers for newly relevant or changed risks;
6. synthesize new candidates together with affected prior findings through the shared synthesis boundary; and
7. derive current coverage, verdicts, and outcome from the resulting current ledger state.

Explicit Deep mode applies the Deep planning and overlap rules to affected and broadly relevant scope. Before a Deep final compilation, independently verify every finding retained in the current review, including an inherited finding whose prior epoch lacks current, independent evidence.

## 6. Preserve Stable Finding Identity And History

A stable finding ID follows the behavioral claim, not wording, reviewer, line, commit, or epoch.

- Keep the same ID when new evidence confirms, refutes, narrows, broadens without changing identity, or relocates the same claim.
- Append evidence and disposition history; never rewrite a prior transition.
- Keep dismissed and superseded records inspectable.
- Use `DuplicateOf` only for the same semantic claim represented by another record.
- When changed behavior requires a materially different claim, retain the old record, mark it `superseded`, create a new ID whose `Supersedes` names the old ID, and link both in a `targeted-supersession` amendment.
- Assign new IDs monotonically after the highest ID ever used in the series. Never recycle an ID.

Every amendment names its epoch, amendment kind, affected stable IDs or context sections, previous state, new state, evidence, and reason. Links must resolve within the stable artifacts. Amendment kinds include:

- `targeted-update`: a bounded PR change revalidates or changes linked context and findings;
- `rebase`: observed objects or anchors changed while semantic identity was assessed separately;
- `verification`: new evidence confirms or changes a claim;
- `disposition`: a finding changes lifecycle state;
- `targeted-supersession`: changed behavior replaces one claim with another;
- `coverage`: inherited coverage is revalidated, invalidated, or newly scoped;
- `recommendation`: current ledger state changes the PERFECT outcome;
- `full-rebuild`: current context was reconstructed while history was retained; and
- `single-finding`: one requested finding received a bounded revision.

Record every recommendation change as an amendment linked to the ledger and coverage changes that caused it. Its `EvidenceChange` preserves the previous outcome, new outcome, cause, and reason.

## 7. Handle Rebases Without Identity Drift

Treat a rebase or history rewrite as evidence change, not identity change. Append the next epoch with the newly observed head and merge-base. Compare old and new patch behavior using content, symbols, tests, and contracts rather than commit correspondence alone.

Revalidate evidence tied to old object IDs, line anchors, blame, or commit topology. Preserve a finding ID when its behavioral claim still applies; dismiss, revalidate, or supersede it only from current evidence. Record a `rebase` amendment describing changed SHAs, semantic comparison, invalidated anchors, and retained identities.

A pure rebase may inherit semantically unaffected context after that equivalence is evidenced. It must not rename the series, renumber epochs, regenerate finding IDs, or erase prior observed SHAs.

## 8. Revise One Finding

`--finding` requires one existing normalized ID matching `F0*[1-9][0-9]*`. Normalize its display to at least three digits and require that exact stable record to exist. It implies Standard verification depth and is incompatible with Deep mode and full rebuild.

Load only:

- the target finding and its complete disposition and amendment history;
- its duplicate and supersession links;
- context, coverage, source, caller, model, test, history, and external evidence linked to its behavioral claim;
- the current final-review references to that finding; and
- enough PR identity and head evidence to establish whether the linked scope changed.

Do not reopen unrelated findings or claim broader review coverage. Reopen decisive evidence under the shared Standard synthesis rules, then append a `verification`, `disposition`, or `supersession` amendment. Preserve the previous claim, disposition, evidence, and reason. Regenerate the entire current `perfect-review.md` from the current ledger and coverage so stale references or outcomes cannot survive.

When the PR head equals the current epoch's observed head, append a same-epoch amendment only if the disposition is unchanged. Append the next epoch for a disposition change so the prior and current states remain verifiable; the observed head may be repeated. When the head changed, use single-finding revision only if comparison proves the entire direct and dependency-affected delta is bounded to the target finding's linked scope. Append the next epoch and a `targeted-update` amendment, revalidate that scope, and explicitly inherit unaffected records. If any other material scope changed or the delta cannot be bounded, stop and require a normal incremental review; do not publish a final review that implies the new head was reviewed globally.

If the target is superseded, follow links to current evidence but amend the requested record and linked current record explicitly. Never silently substitute another ID.

## 9. Compile Staged Replacements

Compile the current state through the shared Standard or Deep rules. All three artifacts must agree on current epoch, observed head, mode, readiness, coverage, stable IDs, amendments, and current outcome. Historical epochs and prior dispositions remain in the same stable files.

Choose one unique update suffix and create two sibling directories under `SERIES_PARENT` on the same filesystem:

```text
<SERIES_PARENT>/.pr-<PR_NUMBER>.review-backup.<unique-suffix>
<SERIES_PARENT>/.pr-<PR_NUMBER>.review-staging.<unique-suffix>
```

Copy the current three canonical files to the backup directory before writing replacements. Require the backup to contain exactly those three regular files and validate it. Write exactly the three complete replacement files to staging, require no other entry, and validate staging. Do not modify the destination while either set is incomplete or invalid.

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

Do not clean up a checkout created by this invocation until publication succeeds. On any recovery, staging, validation, replacement, restoration, or marker-removal failure, preserve that checkout and report its ownership and path. A sibling-directory cleanup warning after successful marker removal does not invalidate the publication. After successful publication, apply Standard's checkout rule: remove only a checkout that this workflow itself created; preserve launcher-created and all other pre-existing checkouts.

## 11. Return

Return:

- current epoch and review kind;
- current recommendation or concrete `UNABLE TO REVIEW` details;
- absolute series directory and the three canonical filenames;
- previous and current observed heads, noting any rebase;
- inherited, revalidated, invalidated, and dependency-affected scope;
- amendments and stable IDs changed in this run;
- material coverage or verification gaps;
- whether publication or restoration occurred; and
- checkout cleanup status.
