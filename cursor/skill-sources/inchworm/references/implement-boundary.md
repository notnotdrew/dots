# Implement boundary

After discover selects a find, the coordinator creates the checkout, asks a
planner for a thin plan, asks an implementer to commit that plan and stop, then
publishes the draft itself.

## Worktrunk + branch

- Create the checkout with Worktrunk (`wt switch --no-cd --format json --clobber -y`), not `git worktree add`. Path is Worktrunk's default: `<repo>.<branch>` with `/` in the branch name replaced by `-`
- Branch name: `<branch_prefix>/<slug>-<YYYYMMDD>` (see [authored-output](authored-output.md); date from `INCHWORM_NOW` / today)
- Base from the freshly fetched trunk, `origin/<base_branch>` (`--create --base=origin/<base_branch>` when the branch is new; attach without `--create` when it already exists)
- If a stale directory already sits at the target path, `--clobber` (or remove/recreate) and still succeed
- `origin` missing, `git fetch origin --prune` failing, or the trunk unresolvable is caught by preflight before progress is recorded (see [discover-boundary](discover-boundary.md)); reaching implement without a base is a soft-fail that leaves the find `open`

## Deterministic fixtures (`INCHWORM_IMPLEMENT_FIXTURE`)

| Value | Behavior |
| --- | --- |
| `success` | Tiny commit, then the same publish path as live. Does not call the planner or the implementer |
| `fail` | Mark find `deferred`; no PR; print implement-failed signal |
| `too_large` | Mark find `too_large`; no PR |
| unset | Fresh planner, then a fresh implementer that commits and stops (`INCHWORM_AGENT` or `agent`). The shell publishes |

## Live delegation

1. Launch a fresh agent in the checkout with a short thin-check prompt. It
   writes `.inchworm/plan.md` or `not_thin`. It does not follow
   `writing-simple-plans`.
2. The planner does not edit production code. `not_thin` skips the implementer
   and marks the find `too_large`: no draft PR.
3. Launch a second fresh agent. It implements the plan at `.inchworm/plan.md`,
   commits, writes `.inchworm/pr/title.txt` and `.inchworm/pr/body.md`, and
   stops. It does not push, open a pull request, review, or fix.
4. The shell commits leftover edits (never `.inchworm/`), rewrites a commit
   message that names the runner, and defers when that rewrite cannot produce a
   clean history or the branch has no commits.
5. The shell appends the footer, pushes, and opens the draft with `gh pr create`.
   It sets `state.active_draft_pr`, marks the find `in_pr`, runs one Standard
   review, runs one fixer only for a verified blocker, pings, and removes the
   checkout with `wt remove --no-delete-branch`.

The thin-check does not follow `writing-simple-plans`. An implementer that
exits non-zero is `deferred`, not `too_large`.

## Failure / no second pick

`too_large` is a correct result, not a fallback: if you cannot bound who inherits the retry, fail, or report policy, or the safe version needs that seam moved first, end the day without a PR (see [shared-seam](shared-seam.md)).

On failure (planner or implementer non-zero, missing plan, no commits, a rewrite
that cannot be published, `too_large`, or inability to resolve the trunk):

- Do **not** call `gh pr create` (or stop if create already failed)
- Leave `active_draft_pr` null and do **not** stamp `last_run_date`
- Do **not** pick a second find in this process. Clear progress so a later tick can pick again
- Do not launch any later stage or ping a nonexistent draft
- Alert the human (the same notify channel as the ping, carrying the reason and no PR URL) — a day that ends without a draft is never log-only
- If a worktree was created for this attempt, clean it up (keep any branch it created)

Whether the find keeps its place depends on who failed, because the next tidy drops `deferred`:

| Failure | Find status | Why |
| --- | --- | --- |
| `fail` fixture, agent non-zero, missing plan, no commits, or a publish check that defers | `deferred` | The attempt reached the selected find but did not complete |
| `too_large` | `too_large` | A correct result (see [shared-seam](shared-seam.md)) |
| No base to work from | `open` | The remote failed before the find was judged |

## Forbidden

- Never pass `--yolo`, `--force`, or `--trust` to the agent
