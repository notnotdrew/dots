# Implementer prompt

Live runs: a planner following `writing-simple-plans` writes `.inchworm/plan.md`
or `not_thin`. `not_thin` is `too_large` with no implementer and no draft PR.
The implementer then implements that plan, commits, writes the PR title and
body files, and stops. The shell appends the footer, pushes, and opens the
draft. It runs one Standard review, runs one fixer only for a verified blocker,
pings, and removes the checkout. See
[implement-boundary](implement-boundary.md).

The **implementer** works only on the selected plan, inside the coordinator-created **Worktrunk** checkout.

## Inputs

- The plan at `.inchworm/plan.md`
- The find's title, summary, and evidence (the coordinator passes the text, not the find id), including a `Work item:` line
- Working directory: the Worktrunk checkout on branch `<branch_prefix>/<slug>-<YYYYMMDD>`
- Optional **Repo guidance** from `.inchworm.yml` `guidance` (injected by the coordinator)

## Do

- Implement the plan at `.inchworm/plan.md`. Make the smallest change that addresses it **and preserves every other caller's semantics** — smallest means smallest blast radius, not smallest diff
- If retry, discard, notify, or error classification already lives in a shared module, report `too_large` unless the patch stays next to the code that already owns that policy. If you cannot tell who else would inherit a different retry, fail, or report meaning, that is `too_large` (see [shared-seam](shared-seam.md))
- If the selected find is a defect, lint, or leftover inside unused or otherwise dead code, delete that code instead of patching it when the deletion is still a thin PR. If deletion is too large, or the find is a leftover write inside a block comments already mark undocumented, temporary, or "maybe remove," report `too_large`. A nibble does not make the real deletion easier.
- Commit on this branch with the **writing-git-commits** skill; stop when done or clearly too large for one day
- Write `.inchworm/pr/title.txt` and `.inchworm/pr/body.md` for the coordinator (gitignored, so they stay out of the commit)
- Review that copy with the **writing-for-humans** skill, and follow the repo's PR template when it has one

## Do not

- Do not treat a unit spec that the client no longer notifies as proof the noise is gone
- Do not push a retry, discard, or classification predicate into a shared client as a stand-in for moving the seam
- Do not implement a micro-cleanup nested under an unresolved removal or product question
- Do not patch unused or dead code as a stand-in for deleting it
- Do not name the tooling, the prompt, automation, or agents in the commit, title, or body — see [authored-output](authored-output.md)
- Do not pass or request `--yolo`, `--force`, or `--trust`
- Do not run `gh pr create` or treat PR creation as your job
- Do not start review, fixer, or ping workflows
- Do not pick or implement a second find

## Outcomes the coordinator expects

- Success → the shell pushes, opens the draft from the title and body (footer already in the body), sets `active_draft_pr`, marks the find `in_pr`, reviews once, optionally fixes, pings, and removes the checkout
- Implementer non-zero, or a plan with no commits → find marked `deferred`; stamp burned; no second pick; no PR
- Planner `not_thin` → find marked `too_large`; no implementer; no PR
