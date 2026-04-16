# PERFECT Principles

Source: Daniil Bastrich's PERFECT code review methodology.

Apply each principle in strict priority order. Earlier principles dominate later ones.

## 1. Purpose

Highest priority. If the code does not solve the task, the review has little value.

How to evaluate:
1. Understand the task from the PR description, linked ticket, or diff context.
2. Form a rough baseline for how you would solve it.
3. Compare the implementation against the task.

Look for:
- missing requirements
- partial implementation
- scope creep that changes behavior outside the task
- solving a different problem than the PR claims

Report:
- requirement gaps
- risky assumptions affecting correctness
- task ambiguity that blocks meaningful review

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
