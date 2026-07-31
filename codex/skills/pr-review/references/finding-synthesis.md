# Finding Synthesis

Use this procedure for the initial Standard review after focused reviewers return. It converts candidate findings into normalized ledger updates for the coordinator. Apply the finding, coverage, readiness, and outcome vocabulary from [review-contracts.md](review-contracts.md) and the record shape from [findings-ledger.md](../templates/findings-ledger.md).

## Ownership Boundary

The coordinator is the only actor that:

- assigns canonical finding IDs;
- creates or mutates `findings-ledger.md`;
- applies synthesis results to readiness, coverage, and `UnresolvedMaterialDecisions`;
- compiles `perfect-review.md`; and
- derives the final outcome.

The synthesis reviewer reads a bounded handoff and returns proposed normalized updates. It must not edit canonical artifacts, publish files, derive the final recommendation, expand its assigned scope, or delegate further.

## Candidate Ingestion And Stable IDs

The coordinator ingests every reviewer-returned candidate before synthesis. Do not discard a candidate because it appears weak, duplicated, misclassified, or inconsistent with another reviewer.

For each candidate:

1. Preserve its source reviewer, raw-output reference when retained, reported claim, impact, affected behavior, scope, evidence, proposed class, and proposed principle.
2. Normalize the claim to one falsifiable statement about observable behavior or a concrete maintenance effect. Split a report that asserts independent failures; combine only details that support the same behavioral claim.
3. Record missing fields as evidence or coverage gaps. Do not invent evidence or silently strengthen the claim.
4. Assign an ID only after all concurrently returned candidates for the synthesis batch have been collected. Order them deterministically by proposed PERFECT priority, affected behavior, normalized claim, scope, then source reviewer identifier, and assign the next ledger IDs in that order.
5. Keep the assigned ID for the life of this initial-review ledger record. Never derive it from a commit SHA, line number, prose spelling, reviewer, or temporary candidate order.

IDs identify ledger records, while behavioral identity determines which record represents a semantic claim. When duplicate candidates have separate IDs, exactly one becomes the representative record and the others remain inspectable as dismissed duplicate records.

## Semantic Comparison

Compare candidates by both:

- **Affected behavior**: the same externally visible result, invariant, state transition, failure mode, data effect, security boundary, or concrete maintenance pressure.
- **Claim**: the same asserted defect or risk, including the condition that triggers it and the consequence.

Matching wording, file, line, suggested fix, or principle is neither necessary nor sufficient. Nearby reports are not duplicates when they describe different triggering conditions, consequences, or independently fixable failures.

For semantic duplicates:

1. Choose the representative record by the deterministic ingestion order, unless another record states the claim more accurately. If accuracy requires a different representative, return the reason.
2. Merge all source reviewers, distinct evidence, affected scope, and raw-output references into the representative.
3. Normalize its claim and impact to the strongest statement supported by the merged evidence, not the most severe report.
4. Return every other duplicate as `dismissed` with `DuplicateOf` set to the representative ID and a disposition-history reason.

Do not use `Supersedes` for same-batch duplicates. Supersession means one ledger finding replaces another finding, not that two reviewers reported the same claim.

## PERFECT Principle And Class

Assign each represented claim to the earliest applicable PERFECT principle:

1. Purpose
2. Edge Cases
3. Reliability
4. Form
5. Evidence
6. Clarity
7. Taste

Use the meanings in [perfect-principles.md](perfect-principles.md). Choose the first principle that fully describes why the claim matters, even when later principles also apply. For example, missing a required behavior is Purpose rather than Evidence merely because a test is absent; an exploitable validation failure is Reliability rather than Clarity; and an untested behavior with no demonstrated production defect is Evidence.

Purpose findings are blocking. Clarity and Taste findings are advisory, and Taste never blocks. Normalize class from demonstrated impact rather than reviewer vote or wording.

Purpose and Evidence also require PR-global context. If the bounded handoff cannot support that global judgment, return a coverage gap or readiness escalation instead of inferring it from one file or reviewer.

## Disagreement And Provenance

Corroboration is not disagreement: compatible reports about the same behavior and claim merge provenance even when they use different severity, principle, line, or fix wording.

Record disagreement when candidates or evidence make incompatible assertions about the behavior, trigger, impact, class, principle, or appropriate disposition. Preserve:

- every participating candidate ID and source reviewer;
- the competing assertions;
- evidence supporting and contradicting each assertion;
- the synthesis conclusion and reason; and
- any unresolved question and the evidence needed to resolve it.

Resolve classification disagreements from the earliest-principle and class rules after resolving the underlying behavior. If a material disagreement cannot be resolved under Standard verification, return it for `UnresolvedMaterialDecisions`; do not choose by majority vote. If the inability to resolve it reflects a material evidence, scope, technology, or capability limit, escalate readiness instead.

## Selective Standard Verification

Standard requires additional verification for every candidate that is:

- proposed as blocking;
- disputed in a way that could affect its claim, class, principle, or disposition; or
- weakly evidenced, including claims based only on reviewer assertion, a line anchor without the relevant state or caller path, an unexecuted assumption, or evidence that does not demonstrate the stated impact.

Also verify any candidate whose deduplication would otherwise hide a materially different trigger or consequence. Well-supported advisory candidates do not require an independent second investigation, but they still need enough decisive evidence to reach `verified`.

Verification must test the normalized claim, not merely confirm that the cited code exists. Use the smallest decisive evidence set: reopen the relevant diff and full source context, then inspect directly related callers, models, tests, history, or command results when the claim depends on them. Before retaining any material claim, the synthesis reviewer must personally reopen its decisive evidence. Reviewer prose, agreement between reviewers, or a copied line anchor alone is not decisive evidence.

Do not require a reproduced runtime failure when static evidence proves the behavior. Do not claim a command was run when only its prior output was supplied. Record unexecuted checks and inaccessible evidence as verification or coverage gaps.

## Bounded Synthesis Handoff

The coordinator gives one synthesis reviewer:

- PR identity, selected Standard mode, and observed head;
- the compact intent, readiness, risk, relationship, coverage, and known-gap sections needed to judge the candidates;
- the complete candidate-ledger records, including IDs, provenance, evidence references, and retained raw-output references;
- explicit changed and relationship-affected scope available for verification;
- the candidates requiring additional Standard verification and why;
- permitted evidence sources and any commands already executed;
- explicit exclusions and known inaccessible evidence; and
- a requirement to return only the normalized response below.

Keep the packet bounded to evidence relevant to candidate comparison and verification. Provide references that let the reviewer reopen decisive evidence; do not substitute an unbounded repository dump or all raw reviewer transcripts. The synthesis reviewer may inspect only the supplied scope and directly necessary evidence paths. It must return a gap or escalation when verification would require broader investigation.

## Normalized Return

Return one update for every candidate ID:

```text
Candidate: F001
Representative: F001
Claim: <normalized behavioral claim>
Impact: <evidence-supported impact>
Principle: <earliest applicable PERFECT principle>
Class: <blocking|advisory>
AffectedBehavior: <normalized behavior or state transition>
Scope: <affected files, symbols, subsystem, or boundary>
SourceReviewers: <merged reviewer identifiers>
Evidence: <decisive supporting and contradicting evidence>
Verification: <additional-verification-performed|supplied-evidence-confirmed|not-verified>
Disposition: <candidate|verified|dismissed|superseded>
DispositionReason: <reason tied to evidence>
DuplicateOf: <none|Fnnn>
Supersedes: <none|Fnnn>
RawOutput: <none|merged retained-output references>
Disagreement: <none|participants, competing assertions, resolution or unresolved question>
CoverageUpdate: <none|normalized coverage record update>
ReadinessEscalation: <none|blocker, gathered evidence, affected coverage, remediation>
```

For a duplicate record, `Representative` and `DuplicateOf` name the retained record. Do not omit dismissed or duplicate candidates. Return separate top-level values for:

- `UnresolvedMaterialDecisionsUpdate: none|<concise unresolved material dispute or Purpose decision>`
- `VerificationGaps: none|<explicit gaps>`
- `CoverageUpdates: none|<records not attributable to one candidate>`
- `ReadinessEscalation: none|<blocker, gathered evidence, affected coverage, remediation>`

The coordinator validates IDs and links, merges rather than overwrites provenance, and appends the proposed disposition and its reason to `DispositionHistory` when applying the response.

## Disposition Transitions

During initial Standard synthesis:

- `candidate -> verified` when decisive evidence supports retaining the normalized claim;
- `candidate -> dismissed` when decisive evidence refutes the claim, the claim is unsupported after required verification, or another record represents the semantic duplicate;
- `candidate -> superseded` only when another finding replaces it with a materially corrected or changed behavioral claim, with reciprocal `Supersedes` linkage; and
- `candidate -> candidate` when required verification remains incomplete and the gap is non-terminal while synthesis is still in progress.

A terminal artifact with a definitive recommendation must not leave a candidate disposition. When decisive evidence is inaccessible and the resulting uncertainty requires `UnableToReview`, preserve the unresolved record as `candidate`, record the failed verification in `DispositionHistory`, and return the qualifying coverage update or readiness escalation. Never dismiss a claim merely because decisive evidence is inaccessible when that inability leaves material coverage uncertain. Each applied transition appends the prior disposition, new disposition, reason, and evidence to `DispositionHistory`; it never erases provenance.

Only `verified` findings are retained in the final PERFECT review. Dismissed and superseded records remain in the ledger for traceability.

## Readiness Reopening

Synthesis must escalate when it discovers a new material limitation involving intent, required evidence, scope stability or reasonableness, supported technology, or reviewer capability. The escalation names the blocker, gathered evidence, affected coverage, and concrete remediation.

The coordinator then returns to readiness, appends a renewed decision to `ReadinessHistory`, and either:

- narrows only genuinely non-material coverage and records the explicit gap; or
- sets final readiness to `UNABLE TO REVIEW` and compiles the three terminal artifacts accordingly.

Do not convert a material limitation into a dismissed finding, an advisory concern, or an automatic Deep review. Standard may recommend a later Deep review but must finish under Standard guarantees or return `UNABLE TO REVIEW`.

## Coordinator Application And Compilation

After validating the synthesis response, the coordinator alone:

1. applies normalized claims, merged provenance, evidence, links, coverage updates, and disposition history to the canonical ledger;
2. applies any renewed readiness decision and unresolved material decision;
3. confirms every retained material finding has the required decisive-evidence reopening;
4. derives ordered PERFECT verdicts and the outcome from the final readiness, coverage, unresolved decisions, and verified findings; and
5. compiles each verified finding exactly once under its earliest applicable principle.

The synthesis reviewer proposes ledger updates but never mutates the canonical ledger or compiles the final review.

## Phase Boundary

This procedure covers initial Standard synthesis only. Do not add Deep-mode independent verification of every actionable finding, review epochs, inherited or invalidated evidence, cross-epoch identity, amendments, re-review, full rebuild, or single-finding revision here. Those extensions belong to Phase 3 and must reuse this Standard synthesis boundary rather than create a parallel implementation.
