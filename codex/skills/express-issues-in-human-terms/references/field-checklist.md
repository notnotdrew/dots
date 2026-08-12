# Field Checklist

Run after drafting each finding. Fix failures before returning.

## Per finding

- [ ] **Title** names the failure mode a human cares about (not the code path or race name)
- [ ] **Anchor** is a real `file:line` useful for a PR comment
- [ ] **Scenario** has concrete actors and steps
- [ ] **Scenario** states the **end state** — what is wrong or left behind when it finishes
- [ ] **Why** is ≤2 sentences and explains mechanism, not restating the scenario
- [ ] **Fix** is brief; spectrum present when minimal vs stronger options both make sense
- [ ] **Case against** separates severity-if-true from likelihood
- [ ] **Case against** is honest (rare + recoverable can still have been marked “blocking” by automation — say so when relevant)
- [ ] No ledger jargon in the body unless the user asked for IDs
- [ ] Finding ID appears only in the header when provided

## Set-level

- [ ] No invented findings
- [ ] Blocking/advisory labels unchanged unless the user asked to re-derive them
- [ ] A non-author engineer can decide in <30 seconds per finding
- [ ] Writing-for-humans pass done: filler cut, point front-loaded, ~30%+ shorter if bloated
- [ ] Output is only the briefs — no preamble or process commentary unless asked

## Scenario end-state test

Ask: “When this story finishes, what is still wrong?”

If the answer is vague (“a race occurs”, “dates are inverted”, “check is missing”), rewrite until the leftover bad state is explicit (missing spend, wrong attribution, unenforced invariant, etc.).
