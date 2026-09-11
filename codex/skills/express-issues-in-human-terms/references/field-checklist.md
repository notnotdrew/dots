# Field Checklist

Run after drafting each finding. Fix failures before returning.

## Shape

- [ ] Shape matches the issue. Request comment and six-field are defaults, not a closed set — a timeline, UI path, mini table, or short paragraph is fine when clearer
- [ ] Not a fake HTTP POST for a race; not six fields stuffed onto a one-request hole
- [ ] Query vs body vs session vs record id is literally true (no inverted payload vs auth context)
- [ ] A novel layout still has setup, expected vs actual, and leftover state — novelty is not an excuse to drop them

## Request comment (when used)

- [ ] Named setup (`A` / `B` or equivalent) with the flags that matter
- [ ] Concrete request: method, path, query, body
- [ ] Expected outcome and why (the invariant)
- [ ] What the code actually checked
- [ ] Leftover bad state (status + created/updated/deleted)
- [ ] Fix / Case against omitted unless they help decide

## Six-field brief (when used)

- [ ] **Title** names the failure mode a human cares about (not the code path or race name)
- [ ] **Anchor** is a real `file:line` useful for a PR comment
- [ ] **Scenario** has concrete actors and steps
- [ ] **Scenario** states the **end state** — what is wrong or left behind when it finishes
- [ ] **Why** is ≤2 sentences and explains mechanism, not restating the scenario
- [ ] **Fix** is brief; spectrum present when minimal vs stronger options both make sense
- [ ] **Case against** separates severity-if-true from likelihood
- [ ] **Case against** is honest (rare + recoverable can still have been marked “blocking” by automation — say so when relevant)
- [ ] Finding ID appears only in the header when provided

## All findings

- [ ] No ledger jargon in the body unless the user asked for IDs
- [ ] End state is explicit — see below

## Set-level

- [ ] No invented findings
- [ ] Blocking/advisory labels unchanged unless the user asked to re-derive them
- [ ] A non-author engineer can decide in <30 seconds per finding
- [ ] Writing-for-humans pass done: filler cut, point front-loaded, ~30%+ shorter if bloated
- [ ] Output is only the briefs — no preamble, no “I chose request comment,” unless asked

## Scenario end-state test

Ask: “When this story finishes, what is still wrong?”

If the answer is vague (“a race occurs”, “dates are inverted”, “check is missing”), rewrite until the leftover bad state is explicit (missing spend, wrong attribution, 201 on the disabled space, unenforced invariant, etc.).
