---
name: executing-draft-pr-plans
description: Executes a simple commit plan as one reviewable draft pull request. Use when the user provides an ordered implementation plan and wants each step implemented, tested, reviewed, simplified, and committed separately before opening a draft PR.
disable-model-invocation: true
---

# Execute a Draft PR Plan

Turn an ordered commit plan into one draft PR whose commit history follows the plan.

## Establish the contract

Before editing:

1. Read the plan, repository instructions, PR template, and relevant code.
2. Confirm that each plan step is one commit in one PR.
3. Identify the acceptance criteria, non-goals, existing issue, branch, and user changes that must remain untouched.
4. Resolve ambiguities that would materially change behavior or commit boundaries.

Do not broaden the work beyond the plan.

## Track the workflow

Track each planned commit through:

1. Implement
2. Attack tests
3. Simplify
4. Verify
5. Commit

After all commits:

6. Open one draft PR
7. Review the complete PR
8. Fold fixes into their originating commits
9. Verify and force-push with lease
10. Wait for user review

## Build each commit

Use a fresh implementation subagent for the current plan step.

Give it:

- the exact plan step
- acceptance criteria and non-goals
- repository conventions
- the intended commit boundary
- relevant decisions from earlier commits

Inspect its work before continuing. The parent agent owns the result and must correct incomplete, misplaced, or unnecessarily broad changes.

Keep every commit coherent and independently understandable. Include the production change and its tests in the same commit.

## Attack the tests

After implementation, launch a fresh subagent and tell it to follow `reviewing-tests-antagonistically` against the current commit’s new and changed examples.

Give it:

- the claimed behaviors for this plan step
- the spec and production files in this commit
- any provenance or shared-caller constraints from the plan

Apply justified fixes. Then apply the same lesson to every newly changed example that used the same pattern, across this commit — not only the example that revealed it.

Do not weaken setup that distinguishes the intended source from a plausible wrong source.

Rerun focused tests before simplifying.

## Simplify without weakening evidence

After the test attack, launch a fresh subagent and tell it to follow `simplify-code` on this commit’s production and spec changes.

Give it:

- the files changed in this commit
- the test-attack findings that must remain load-bearing
- a reminder that comments restating the change are not necessary

Treat “do nothing” as valid. Reject simplifications that change behavior, hide provenance, or undo the test attack.

Rerun focused tests before committing.

## Verify and commit

Run the focused tests and relevant lint checks after each step.

Use a fresh subagent and tell it to follow `writing-git-commits` after the diff is final. The subject should:

- describe the behavior added
- use ordinary human language
- match the commit’s actual scope
- avoid metaphorical or inflated wording
- omit a body unless it adds necessary context

Do not mention agent activity in commits.

## Open one draft PR

After every planned commit is complete:

1. Verify the commit order matches the plan.
2. Run the combined relevant test suite and lint checks.
3. Push the branch.
4. Open one draft PR using the repository template.

Keep the title and description brief and human:

- what behavior changed
- why it matters
- important omission or boundary, if needed
- how it was verified, when the template requests it

Do not narrate the implementation process or add technical detail that reviewers do not need.

## Review the complete PR

Launch a fresh subagent and tell it to follow `pr-review` against the full draft PR (Standard unless the user asked for Deep). Do not invoke the `pr-review` CLI from inside the agent.

The review must check:

- end-to-end acceptance criteria
- interactions between commits
- missed callers or alternate paths
- incorrect value provenance
- shared-method behavior
- over-testing and under-testing
- accidental scope expansion
- commit placement and history quality
- PR wording

Treat findings as evidence, not commands. Reconcile them with earlier test-attack and simplification decisions.

## Fold review fixes into history

Place each accepted fix in the commit that introduced the affected behavior.

Use fixup commits and autosquash, or another safe history-editing method. Do not append an unrelated cleanup commit when the fix belongs to an existing planned commit.

After rewriting history:

1. Re-run focused and combined verification.
2. Confirm the final diff and commit order.
3. Force-push with `--force-with-lease`.
4. Update the draft PR title or description if its meaning changed.
5. Report the PR link, commits, and verification briefly.
6. Wait for user review.

Never discard unrelated working-tree changes or use destructive Git commands without explicit approval.

## Quality bar

Prefer tests that:

- observe behavior through the framework or system’s real recording seam
- assert on what the unit under test returns, rather than routing the value through a collaborator
- prove the value came from the intended source
- use a narrow competing value or mutation when provenance matters
- extend an existing happy-path assertion when that behavior is already covered
- assert the stable contract owned by the current layer

Avoid tests that:

- replace an observable framework mechanism with a homemade collector
- reproduce production logic in the assertion
- inspect more payload than the layer owns
- add several examples where one representative behavior proves the contract
- hide a load-bearing mutation inside generic setup
- force one testing technique across incompatible seams
- copy a neighboring example’s structure when that structure exists for a claim the new example does not make

Apply a review lesson to every newly changed example with the same pattern, not merely the example that revealed it.

Preserve:

- setup that distinguishes the intended source from plausible wrong sources
- behavior required by shared callers
- omission versus explicit-null semantics
- test assertions that catch realistic regressions
- existing repository style
