# Implement boundary

After discover selects a find, the coordinator creates the checkout, delegates
planning and execution to fresh agents, then records the resulting draft.

## Worktrunk + branch

- Create the checkout with Worktrunk (`wt switch --no-cd --format json --clobber -y`), not `git worktree add`. Path is Worktrunk's default: `<repo>.<branch>` with `/` in the branch name replaced by `-`
- Branch name: `<branch_prefix>/<slug>-<YYYYMMDD>` (see [authored-output](authored-output.md); date from `INCHWORM_NOW` / today)
- Base from the freshly fetched trunk, `origin/<base_branch>` (`--create --base=origin/<base_branch>` when the branch is new; attach without `--create` when it already exists)
- If a stale directory already sits at the target path, `--clobber` (or remove/recreate) and still succeed
- `origin` missing, `git fetch origin --prune` failing, or the trunk unresolvable is caught by preflight before the stamp (see [discover-boundary](discover-boundary.md)); reaching implement without a base is a soft-fail that leaves the find `open`

## Deterministic fixtures (`INCHWORM_IMPLEMENT_FIXTURE`)

| Value | Behavior |
| --- | --- |
| `success` | Simulate the completed workflow with a tiny commit and draft PR |
| `fail` | Mark find `deferred`; no PR; print implement-failed signal |
| `too_large` | Mark find `too_large`; no PR |
| unset | Fresh planner agent, then fresh draft-PR executor agent (`INCHWORM_AGENT` or `agent`) |

## Live delegation

1. Launch a fresh agent in the checkout and tell it to follow
   `writing-simple-plans`, writing `.inchworm/plan.md`.
2. The planner does not edit production code. If it reports that the change
   cannot fit one thin PR, mark the find `too_large` and stop.
3. Launch a second fresh agent and tell it to follow
   `executing-draft-pr-plans` using that plan.
4. The execution skill owns implementation, test attack, simplification,
   verification, commits, draft creation, Standard review, fix folding, and the
   final force-with-lease push. It does not ready or merge the PR.
5. The coordinator queries open PRs for the exact branch and requires a draft
   URL. It does not repeat any execution or review stage.
6. Set `state.active_draft_pr`, mark the find `in_pr`, ping, and remove the
   checkout with `wt remove --no-delete-branch`.

`writing-simple-plans` and `executing-draft-pr-plans` remain generic. Their
normal input receives the selected find, repo guidance, base branch, and the
thin-change constraints; neither skill contains runner-specific behavior.

## Failure / no second pick

`too_large` is a correct result, not a fallback: if you cannot bound who inherits the retry, fail, or report policy, or the safe version needs that seam moved first, end the day without a PR (see [shared-seam](shared-seam.md)).

On failure (planner/executor non-zero, missing plan, missing draft, `too_large`,
or inability to resolve the trunk):

- Do **not** call `gh pr create` (or stop if create already failed)
- Leave `active_draft_pr` null
- Do **not** pick a second find — the day's stamp is already burned
- Do not launch any later stage or ping a nonexistent draft
- Alert the human (the same notify channel as the ping, carrying the reason and no PR URL) — a day that ends without a draft is never log-only
- If a worktree was created for this attempt, clean it up (keep any branch it created)

Whether the find keeps its place depends on who failed, because the next tidy drops `deferred`:

| Failure | Find status | Why |
| --- | --- | --- |
| `fail` fixture, agent non-zero, missing plan, or no draft produced | `deferred` | The attempt reached the selected find but did not complete |
| `too_large` | `too_large` | A correct result (see [shared-seam](shared-seam.md)) |
| No base to work from | `open` | The remote failed before the find was judged |

## Forbidden

- Never pass `--yolo`, `--force`, or `--trust` to the agent
