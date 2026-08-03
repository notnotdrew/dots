# Initial Deep Review Workflow

Use this workflow only for an explicitly selected initial Deep review. Deep is an overlay on [standard-review.md](standard-review.md), not a parallel implementation. Apply the shared contracts, references, templates, coordinator ownership, and read-only boundaries linked by Standard.

Keep GitHub, Linear, Git history, PR state, and the review checkout read-only. Reviewers must not delegate, edit canonical artifacts, or derive the final recommendation. Only the coordinator may write review artifacts and remove a checkout created by this invocation.

## Reuse The Standard Stages

Run the ten Standard stages in order with only the substitutions below:

1. **Resolve invocation, identity, and initial artifact path:** require `Mode: Deep` and `ModeSelection: explicit`. Retain Standard's PR identity, absent-series, collision, and canonical-path rules. Reject an omitted or defaulted Deep selection.
2. **Resolve checkout ownership:** use Standard's disposable epoch-checkout selection (`pr-<PR_NUMBER>-R1` for an initial Deep review), observed-head check, ownership recording, and preservation rules unchanged. Never mutate the user's PR branch worktree.
3. **Gather the context brief:** complete Standard's context-gathering procedure first, then run the Deep planning and broader-context pass below.
4. **Assess initial readiness:** apply the shared readiness gate against the Deep guarantee, including the planned broader context and independent verification capability.
5. **Select and launch focused reviewers:** begin with Standard's risk-selected assignments, then add only the justified overlap defined below.
6. **Build the candidate ledger and renew readiness:** use Standard's ingestion, deterministic ID assignment, coverage accounting, and renewed-readiness rules unchanged.
7. **Run bounded synthesis:** use the same synthesis boundary and normalized return, with independent verification of every finding that could be retained.
8. **Compile the three artifacts:** use Standard's coverage, verdict, outcome, and exact-three-file compilation rules, recording Deep mode and planning evidence.
9. **Validate and publish:** use Standard's initial-review staging, validation, absent-destination check, and same-filesystem directory rename unchanged.
10. **Cleanup and return:** use Standard's ownership-aware cleanup and return contract unchanged, adding Deep planning and independent-verification gaps to the reported gaps.

When a Standard instruction excludes Deep-only behavior, this file's explicit substitution controls only that behavior. All other Standard requirements remain binding. Do not create a second gathering, ledger, synthesis, compilation, publication, or cleanup path.

## Deep Planning And Broader Context

After the complete Standard context brief exists, perform a planning pass before reviewer selection. The coordinator records a concrete coverage plan that identifies:

- changed and relationship-affected subsystems, their responsibilities, and relevant architectural boundaries;
- broader caller, consumer, model, schema, persistence, event, queue, API, and external-service relationships needed to judge the change;
- architecture decisions, conventions, and historical invariants relevant to the changed behavior;
- deeper path, symbol, blame, and commit history questions that could confirm or invalidate those invariants;
- security, data-integrity, rollout, compatibility, migration, failure-mode, and test-evidence risks;
- cross-boundary ownership, planned reviewer scopes, planned overlap, and the reason each overlap reduces a concrete risk;
- decisive evidence expected for independent verification; and
- known context, technology, evidence, or capability gaps and their materiality.

Use the Standard evidence as the starting point. Broaden repository search and history only along named subsystem, architecture, relationship, or risk questions from the plan. Record the evidence and stopping point for each question. Do not perform unbounded repository archaeology or treat volume of context as coverage.

Re-query the PR head after broader gathering. Do not combine evidence from different heads. If the head cannot be stabilized, or required broader context is inaccessible, apply the readiness contract rather than falling back silently to Standard depth.

## Deep Readiness

`Readiness: ready` means the coordinator can execute the planned broader coverage and can arrange independent verification for every finding that might be retained. Standard-level evidence alone is insufficient when the Deep plan identifies material architecture, relationship, history, or verification work.

Record an unavailable non-material area as explicit `unreviewed` coverage. Record a material broader-context or independent-verification limitation as `unable-to-review`, renew readiness when discovered after launch, and emit overall `UNABLE TO REVIEW` when the gap could materially change the recommendation. Never downgrade the run to Standard or weaken a finding merely to produce a recommendation.

The failed-readiness path remains Standard's three-artifact terminal path: launch no reviewers when readiness fails initially, preserve partial planning and gathered evidence, validate the empty terminal ledger, publish `UnableToReview`, and clean up an owned checkout only after successful publication.

## Intentional Reviewer Overlap

Apply every matching Standard selection rule and preserve coherent subsystem and cross-boundary ownership. Deep may assign multiple reviewers to the same behavior only when independent perspectives address a named risk that one assignment may miss, such as:

- independent security and data-integrity analysis of one trust and persistence boundary;
- producer-side and consumer-side analysis of a changed public contract;
- migration mechanics and runtime compatibility analysis of one rollout;
- implementation correctness and test-oracle analysis of a complex failure path; or
- separate architectural and historical checks of an unfamiliar invariant.

For every overlap, record the shared behavior, distinct perspective, decisive evidence, primary boundary owner, and why combining the assignments would reduce independence or obscure coverage. Adjacent reviewers may corroborate one another, but votes and repeated prose are not verification.

Do not create a fixed roster, one reviewer per PERFECT principle, or duplicate general review. Remove overlap whose scopes, evidence, and questions are materially identical. Launch independent assignments concurrently only under Standard's concurrency rules; sequence work when one result is needed to bound another.

Every handoff uses the Standard bounded shape, the same immutable observed head, explicit broader relationship scope, explicit exclusions, no delegation, no artifact mutation, and no recommendation. Each return must account for promised coverage even when it reports no candidate.

## Independent Verification Of Every Retained Finding

After all discovery returns, build the candidate ledger exactly as Standard does. Send the complete bounded candidate set through the shared synthesis stage. Deep changes the verification requirement, not the ledger or synthesis ownership:

- every candidate proposed for retention, blocking or advisory, requires an independent verification;
- the verifier must not be the reviewer that originated the candidate and must not rely on agreement between discovery reviewers;
- the verifier must reopen the decisive diff and full source context and inspect the callers, models, tests, history, external evidence, or command results needed to test the normalized behavioral claim;
- supplied reviewer prose, copied line anchors, and an origin reviewer's own recheck do not satisfy independence;
- static evidence is sufficient when it decisively proves the behavior; runtime reproduction is not mandatory;
- the normalized synthesis return must identify the independent verifier, evidence personally examined, result, confidence limits, and any coverage or readiness escalation.

The synthesis reviewer may serve as the independent verifier when it did not originate the candidate and personally performs the required investigation. If one synthesis reviewer lacks the expertise, independence, or bounded evidence for a candidate, the coordinator assigns a separate bounded verifier and returns its evidence to the same synthesis boundary. Verification reviewers inherit all focused-reviewer prohibitions.

Retain a finding in `perfect-review.md` only when its ledger record is `verified` and its history contains successful independent verification for the current observed head and affected behavior. Dismiss a claim only when decisive evidence refutes or fails to support it. When decisive verification is unavailable and the uncertainty is material, preserve the candidate and gap and produce `UNABLE TO REVIEW`; do not dismiss it because verification could not run.

Before compilation, the coordinator audits every retained actionable finding against this requirement. Any missing, stale, same-origin, or behavior-mismatched verification must be completed or represented as coverage and readiness failure. Compile verdicts and the outcome only after that audit.

## Deep Artifact Evidence

Keep exactly the three canonical artifacts and their shared identity and coverage:

- the context brief records the Deep plan, broader subsystem and architecture context, history and relationship questions, justified overlap, and gaps;
- the findings ledger preserves all candidates, provenance, disagreements, dispositions, and independent-verification evidence;
- the final review references only retained verified IDs and summarizes any broader-context or verification gaps.

Do not create a planning artifact, verifier artifact, or alternate final review. Raw reviewer output may be retained only under the shared noncanonical-output rules.
