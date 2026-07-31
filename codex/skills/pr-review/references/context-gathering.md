# Standard Review Context Gathering

Use this procedure only for an initial Standard review. Gather enough evidence to review changed behavior and its immediate boundaries without performing Deep planning, broad architecture discovery, or incremental-review inheritance.

The coordinator owns this stage and writes its results into `context-brief.md`. Keep external systems read-only: do not post GitHub or Linear comments, submit a review, change issue state, or mutate the PR. A targeted Git fetch is allowed only when required to resolve observed revisions locally.

## Resolve PR Identity Before Gathering Evidence

Run `scripts/gh-pr-parse` against the original PR reference and keep the parsed values separate from shell code.

- For a GitHub URL, use the parser's `OWNER`, `REPO`, and `PR_NUMBER` values. The URL identifies the target repository even when the current checkout has a different remote.
- For a numeric reference, the parser returns only `PR_NUMBER`. From the repository in which the command was invoked, run:

  ```bash
  gh repo view --json nameWithOwner --jq '.nameWithOwner'
  ```

  Require exactly one non-empty `owner/repository` value, split it into `OWNER` and `REPO`, and fail readiness if the current repository cannot be resolved unambiguously. Do this before deriving the artifact path; do not infer owner or repository from a checkout directory, remote-name convention, PR branch, or numeric PR alone.

The stable review-series directory is:

```text
~/.cdx-artifacts/pr-reviews/<OWNER>--<REPO>/pr-<PR_NUMBER>/
```

Treat owner, repository, and PR number as identity. Commit IDs are observed evidence, not review-series identity.

## Gather GitHub Evidence

Query the PR explicitly in the resolved repository so URL and numeric inputs behave consistently:

```bash
gh pr view "$PR_NUMBER" --repo "$OWNER/$REPO" \
  --json title,body,url,author,state,isDraft,reviewDecision,mergeable,mergeStateStatus,baseRefName,baseRefOid,headRefName,headRefOid,files,changedFiles,additions,deletions,commits,labels,reviews,comments,closingIssuesReferences,statusCheckRollup

gh pr diff "$PR_NUMBER" --repo "$OWNER/$REPO"
gh pr checks "$PR_NUMBER" --repo "$OWNER/$REPO"
gh pr view "$PR_NUMBER" --repo "$OWNER/$REPO" \
  --json files --jq '.files[].path'
```

Retain all four evidence classes: metadata, the full GitHub patch, check results, and changed paths. If an optional metadata field is unavailable in the installed GitHub CLI or repository schema, rerun without only that unavailable field and record the omission as a gap. Do not silently drop required identity, base/head object IDs, the patch, or changed paths.

Capture both output and exit status from `gh pr checks`. A nonzero status caused by failing or pending checks is check evidence, not by itself a context-gathering command failure.

Record at least:

- title, body, URL, author, labels, state, draft state, review decision, mergeability, and merge-state status;
- base and head branch names plus full `baseRefOid` and `headRefOid`;
- additions, deletions, changed-file count and paths, and PR commit subjects and object IDs;
- check names and conclusions, including pending, skipped, failing, unavailable, or absent checks;
- review decisions and materially relevant review or discussion comments;
- linked-closing-issue data and issue keys or URLs present in the title, body, comments, branches, or commits.

Treat reviews and comments as evidence, not conclusions. Reopen the cited code or command result before relying on a technical claim from discussion.

After repository context is gathered, query `headRefOid` again. If it differs from the initially observed head, do not combine evidence from the two revisions. Repeat gathering against one stable head when practical; otherwise record unstable scope and fail readiness with concrete remediation.

## Establish the Actual Comparison

Run Git commands from the PR-head checkout. Confirm that the observed GitHub head object exists locally and that the checkout represents it. Resolve the GitHub base object locally. If it is absent, identify the authenticated Git remote whose repository matches `OWNER/REPO`, fetch only `refs/heads/$BASE_REF_NAME`, and then require the observed `baseRefOid` to exist. Do not assume a remote named `origin`, and do not substitute the fetched branch tip when it differs from the observed object ID.

Compute and record the actual merge-base:

```bash
MERGE_BASE=$(git merge-base "$HEAD_REF_OID" "$BASE_REF_OID")
git diff --stat "$MERGE_BASE...$HEAD_REF_OID"
git diff --name-status "$MERGE_BASE...$HEAD_REF_OID"
git diff "$MERGE_BASE...$HEAD_REF_OID"
git log --oneline --decorate "$MERGE_BASE..$HEAD_REF_OID"
```

Require a single full merge-base object ID. Use the merge-base-to-head diff as the local comparison and retain `gh pr diff` as independent GitHub evidence. Investigate material disagreement between the two rather than choosing whichever patch is more convenient.

In the context brief:

- set `ObservedHead` to the full `headRefOid` actually reviewed;
- set `ObservedBase` to the full merge-base used for the comparison;
- preserve the GitHub `baseRefOid`, base/head names, and merge-base command as supporting evidence in `RelevantHistory` or `GatheredEvidence`.

Do not use the current base branch tip as a substitute for the merge-base.

## Read Changed Source and Immediate Boundaries

Read every changed source file in full from the PR-head checkout. Use the patch to locate changed behavior and the full file to understand local invariants, imports, error handling, and conventions.

Skip these as primary review targets by default:

- generated files;
- dependency lockfiles;
- binary assets;
- prose-only files.

Do not classify migrations, schemas, executable configuration, fixtures, or interface definitions as prose merely because they are declarative. Inspect an excluded file when changed source behavior depends on it, but record why it was needed. Do not claim excluded content was reviewed when it was not. If the PR has no reviewable source behavior, record that fact and let readiness and the Standard workflow determine whether a code-review outcome is applicable.

Trace only immediate boundaries needed to understand the change:

- direct callers and entry points of changed symbols;
- directly read or written domain models, schemas, persistence records, and state;
- interfaces crossed by changed APIs, events, queues, shared packages, or external calls;
- changed tests and the nearest existing tests that assert the changed behavior or its failure modes;
- one-hop dependencies whose contract is changed or assumed by the patch.

Read each directly related file far enough to establish the relevant contract. Stop when another hop would provide general architecture context rather than evidence for changed behavior. Record a broader unresolved dependency as a coverage gap or a recommendation for a later Deep review; never switch the current run to Deep.

## Use Git, History, and Search Selectively

Use repository search and history to answer a concrete review question, not to map the whole repository.

- `git diff`: inspect the complete merge-base-to-head patch, then narrow by path or hunk when tracing one behavior.
- `git log`: inspect PR commits and bounded recent history for a changed path or symbol. Use path history, `-S`, or `-G` only when it can explain an invariant, regression risk, or prior fix.
- `git blame`: inspect changed or immediately adjacent lines only when ownership of an invariant or the reason for existing behavior is unclear.
- `git show`: open a specific commit, parent version, or historical file identified by the bounded log or blame investigation.
- Repository search: search exact changed symbols, imports, route/event names, schema or model names, configuration keys, and test descriptions to locate direct callers, consumers, models, and neighboring tests.

Prefer a small, explicit result set. Record the query or command and the evidence used. Stop history expansion after the relevant invariant or immediate relationship is established. Standard mode does not include broad subsystem archaeology, architecture-wide call graphs, intentionally overlapping exploration, or deeper historical planning.

## Consult Associated Linear Evidence

Detect a Linear association from, in descending confidence:

1. an explicit Linear issue URL or unambiguous issue key in the PR title, body, linked issue data, or discussion;
2. an unambiguous issue key in the head branch name;
3. an unambiguous issue key in PR commit subjects or relevant commit context.

Do not treat an arbitrary key-shaped token as associated when repository or PR context does not support the link. When multiple plausible issues exist, record the ambiguity and use only clearly associated evidence.

For each identifiable associated issue, use an available authenticated Linear integration in read-only mode. Gather the issue key and title, description, acceptance criteria, rationale, materially relevant discussion, and linked work needed to establish intent or boundaries. Record which Linear evidence was actually consulted.

Linear is intent evidence, not an authority that overrides the PR description, executable behavior, tests, or code. Preserve conflicts between sources as an unresolved Purpose decision or other explicit gap. Never update Linear state or comment on the issue.

If the issue is identifiable but Linear is unavailable, unauthorized, or missing, record `LinearEvidence: inaccessible` with the issue identity and failure. This is normally a verification gap. It becomes a readiness blocker only when available PR, code, test, and discussion evidence cannot otherwise establish purpose well enough for a defensible review. If no association is found, record `none identified`; do not search Linear by guessed title or author.

## Record Standard Risk Signals

Record concrete signals, not a single opaque risk score. Use them later to select and bound Standard reviewers:

- size and spread: additions, deletions, changed-file count, commit count, many directories, or mixed implementation and migration work;
- security and trust: authentication, authorization, permissions, cryptography, secrets, untrusted input, deserialization, or trust-boundary changes;
- data integrity: schema or data migrations, persistence, transactions, destructive operations, backfills, or changed model invariants;
- boundary integration: public APIs, shared packages, events, queues, external services, protocols, or cross-subsystem changes;
- failure behavior: retries, timeouts, concurrency, partial failure, idempotency, rollback, state transitions, or high branching;
- evidence quality: missing, weak, skipped, pending, or failing tests and checks; behavior changes without neighboring tests;
- reviewability: generated or opaque behavior, unmatched languages, merge conflicts, an unstable head, unclear intent, or scope that exceeds immediate-boundary review;
- social and release state: draft status, unresolved review discussion, merge-state restrictions, or labels that identify risk or rollout constraints.

Draft, merge, label, review, or size signals do not automatically determine readiness or a finding. Explain their concrete effect on reviewer selection, evidence confidence, or scope.

Risk signals may justify a recommendation to rerun later in Deep mode. They must never trigger automatic escalation, Deep-only planning, intentionally overlapping review, or Deep verification guarantees during this Standard run.

## Assess and Record Readiness Inputs

Before finding discovery, assess the inputs defined by `review-contracts.md`:

- intent is specific enough to distinguish current from desired behavior;
- required GitHub, patch, revision, and repository evidence is accessible and internally consistent;
- the observed head and scope are stable;
- changed behavior plus immediate boundaries are reasonable for Standard review;
- the changed technologies can be reviewed with available skills and general engineering capability;
- no other material capability limit prevents a defensible recommendation.

Populate `ReadinessHistory` with the initial decision and reasons. For `UNABLE TO REVIEW`, populate `Blocker`, `GatheredEvidence`, `AffectedCoverage`, and concrete `Remediation`. Missing optional evidence remains a named gap unless it materially prevents judgment.

Preserve these limitations explicitly:

- **Unmatched language:** when no mapped stack skill exists, continue with general engineering judgment only if the technology remains reviewable. Record the unmatched files or language, affected coverage, evidence used, and whether the gap is material. Unsupported technology is not silently considered reviewed.
- **Unexecuted checks:** distinguish checks observed through GitHub from checks actually executed during the review. Name each relevant check or test that was not run, why it was not run, and which behavior or coverage it affects. Never translate “not run,” unavailable, pending, or skipped into passing evidence.
- **Failed checks:** retain the exact failing check and conclusion as evidence and a risk signal. Do not assume the failure is caused by the PR or ignore it because other checks passed.
- **Excluded sources or inaccessible evidence:** name the excluded or inaccessible material and assess its effect on coverage instead of omitting it from the brief.

Represent non-material limitations in `Known Gaps` and the relevant coverage records. A material limitation that prevents a defensible recommendation produces aggregate `UNABLE TO REVIEW` under the review contracts.

## Immediate Phase Boundaries

This procedure does not:

- select or orchestrate focused reviewers;
- synthesize, verify, deduplicate, or disposition findings;
- compile the final PERFECT outcome;
- perform Deep planning or broaden Standard into Deep;
- detect, inherit, invalidate, or amend an existing review series;
- create epochs, preserve cross-epoch identity, perform a full rebuild, or revise one prior finding.

Those responsibilities belong to later Standard workflow stages or the deferred Deep and incremental phase. This file produces only bounded Standard context, readiness inputs, risk signals, and explicit gaps.
