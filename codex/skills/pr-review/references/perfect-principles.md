# PERFECT Principles

Source: Daniil Bastrich's PERFECT code review methodology.

Apply each principle in strict priority order. Earlier principles dominate later ones.

## 1. Purpose

Highest priority. If the code does not solve the task, the review has little value.

How to evaluate:
1. Understand the task from the PR description, linked ticket, or diff context.
2. Form a rough baseline for how you would solve it.
3. Compare the implementation against the task across the whole PR, including changed behavior and its directly related boundaries.

Purpose is a PR-global judgment. Derive it from the consolidated intent, final coverage, and implementation as a whole; never infer a Purpose pass or finding from one file or one focused reviewer's scope.

Look for:
- missing requirements
- partial implementation
- scope creep that changes behavior outside the task
- solving a different problem than the PR claims

Report:
- requirement gaps
- risky assumptions affecting correctness
- task ambiguity that blocks meaningful review

Purpose findings are always blocking. Represent an unresolved Purpose decision with the Purpose `NEEDS DISCUSSION` verdict and outcome, not with an advisory finding record.

## 2. Edge Cases

High priority. Many production defects live in omitted boundaries and unusual states.

Look for:
- null, nil, undefined, or empty values from external inputs
- boundary values and threshold transitions
- empty collections and whitespace-only strings
- Unicode and special characters
- time zone or date handling problems
- retry, timeout, or partial failure paths
- states that seem impossible but would be dangerous if reached

Report:
- the exact scenario
- what breaks
- the handling direction

## 3. Reliability

High priority. Check both performance and security.

Performance:
- accidental quadratic work
- N+1 queries
- full-data loads where streaming would work
- redundant API or database calls
- missing cache invalidation

Security:
- unvalidated input
- injection risks
- auth or authorization gaps
- secret exposure in code or logs
- path traversal
- external calls with weak error handling or no timeout

Report:
- the concrete risk
- expected impact
- the fix or mitigation direction

## 4. Form

Medium priority. Evaluate design quality with an emphasis on cohesion and coupling.

Look for:
- functions or modules doing multiple unrelated jobs
- layering violations
- unnecessary duplication
- premature abstraction
- dependencies that make future changes harder than needed

Form findings need clear arguments:
- what design cost exists now
- what change pressure will make it worse
- what alternative would improve the situation

If the code is acceptable and there is no shared project convention pushing another direction, defer to the author.

## 5. Evidence

Medium priority. Review tests as seriously as production code.

Check:
1. CI status
2. whether new or changed behavior is covered
3. whether tests protect behavior instead of implementation

Evidence is also a PR-global judgment. Assess the combined CI, test, and verification evidence for the PR's changed behavior and immediate boundaries. Do not infer an Evidence pass from one test file or one reviewer's scope. Assign a demonstrated production defect to its earlier applicable principle; use Evidence for an evidence deficiency when no earlier principle fully describes a demonstrated defect.

Test anti-patterns:
- over-mocking
- weak assertions
- tests that only exercise the happy path
- test names that do not match the final expectation
- production-only test hooks

Report:
- missing scenarios
- low-value or brittle tests
- failing checks

## 6. Clarity

Lower priority. Code should communicate intent without forcing line-by-line decoding.

Look for:
- vague naming
- overly long functions
- deep nesting
- mixed abstraction levels
- comments that repeat obvious code
- awkward file organization

Keep clarity feedback proportional. Do not rewrite the PR for stylistic preferences.

## 7. Taste

Lowest priority. These are personal preferences and never blocking by themselves.

Rules:
- always mark them non-blocking
- give reasoning, not raw preference
- limit quantity
- do not smuggle design or correctness issues into Taste

## Severity Guidance

- `FAIL`: likely bug, security problem, or meaningful task miss
- `CONCERN`: issue worth fixing, with real risk or maintenance cost
- `PASS`: no meaningful issue found for that principle
- `N/A`: used for Taste

## Ledger-Aware Verdict Compilation

The coordinator compiles from the final readiness decision, final coverage records, retained verified ledger findings, and the ledger's top-level `UnresolvedMaterialDecisions` value. Candidate, dismissed, and superseded records do not affect verdicts or appear in the final findings.

Before deriving verdicts, assign every retained verified finding to exactly one principle: the earliest principle in the ordered PERFECT list that fully describes why the claim matters. Do not repeat a finding under later principles that it also affects. In particular, missing required behavior belongs to Purpose rather than Evidence merely because a test is absent; a demonstrated validation or failure-handling defect belongs to Reliability or an earlier applicable principle; and an untested behavior without a demonstrated production defect belongs to Evidence. Reconcile this assignment against the ledger before compilation.

Purpose and Evidence verdicts remain PR-global after principle assignment. Derive Purpose from consolidated intent and PR-wide implementation coverage, and Evidence from the aggregate CI, tests, and verification evidence for changed behavior and immediate boundaries. A focused reviewer's local pass cannot establish either global verdict.

Apply coverage before finding-derived verdicts. For each gap, use its required `Principles` set to identify only the affected verdicts:

- Purpose is `UNREVIEWED` for any `unreviewed` or `unable-to-review` Purpose gap, `FAIL` for a retained verified blocking Purpose finding, `NEEDS DISCUSSION` for an unresolved material Purpose decision when no such blocker exists, and otherwise `PASS`.
- Edge Cases, Reliability, Form, and Evidence are `UNREVIEWED` for a material `unreviewed` or `unable-to-review` gap assigned to the principle, `FAIL` for a retained verified blocking finding, `CONCERN` for a retained verified advisory finding or explicit non-material gap assigned to the principle, and otherwise `PASS`.
- Clarity is `UNREVIEWED` for a material `unreviewed` or `unable-to-review` gap assigned to Clarity, `CONCERN` for a retained verified advisory Clarity finding or an explicit non-material Clarity gap, and otherwise `PASS`.
- Taste is always `N/A`. Clarity and Taste findings are advisory.

Purpose findings are always blocking, and Purpose cannot use `CONCERN`. Clarity and Taste findings are always advisory. Taste never blocks, and Taste gaps do not alter its `N/A` verdict or the outcome. Advisory findings do not independently prevent approval.

Derive exactly one final outcome in this order:

1. If final readiness is `UNABLE TO REVIEW`, emit `UnableToReview`, not a recommendation.
2. Otherwise, if any material `unreviewed` or `unable-to-review` coverage affecting Purpose through Clarity remains, emit `UnableToReview`.
3. Otherwise, if any Purpose coverage gap remains, including a non-material gap, emit `UnableToReview`.
4. Otherwise, if any retained verified blocking finding exists, recommend `REQUEST CHANGES`.
5. Otherwise, if `UnresolvedMaterialDecisions` is not `none`, recommend `NEEDS DISCUSSION`.
6. Otherwise, recommend `APPROVE`.

`UnableToReview` must carry the blocker, gathered evidence, affected coverage, and remediation required by the review contract. It never coexists with a recommendation. A definitive recommendation cannot coexist with any `UNREVIEWED` verdict. Aggregate `UNABLE TO REVIEW` does not by itself force unaffected principles to `UNREVIEWED`: failed readiness before review affects all six evaluable principles, while renewed failure after partial review leaves unaffected verdicts normally derived.

The ledger field `UnresolvedMaterialDecisions` is `none` or a concise unresolved material dispute or Purpose decision. A retained verified blocker takes precedence over unresolved decisions. Context `PurposeDecisions` is supporting evidence rather than the deterministic outcome input.

After the ordered verdicts, list retained findings in explicit `### <Principle>` sections. List every retained verified ledger finding exactly once under its assigned principle, list no other ledger records, and omit empty sections.
