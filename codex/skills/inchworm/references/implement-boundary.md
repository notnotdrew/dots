# Implement boundary

After discover selects a find, the coordinator runs implement then (on success) opens a draft PR.

## Worktree + branch

- Create a git **worktree** under `.inchworm/worktrees/`
- Branch name: `<branch_prefix>/<slug>-<YYYYMMDD>` (see [authored-output](authored-output.md); date from `INCHWORM_NOW` / today)
- Base from freshly fetched `origin/develop` (hardcoded; not local `HEAD` / `origin/HEAD`)
- If the worktree path already exists (stale), remove/recreate it before `worktree add`
- Soft-fail (defer find, no PR, clean up worktree) when `origin` is missing or `origin/develop` cannot be resolved after `git fetch origin`

## Implement fixtures (`INCHWORM_IMPLEMENT_FIXTURE`)

| Value | Behavior |
| --- | --- |
| `success` | Worktree + tiny commit; ready for draft PR |
| `fail` | Mark find `deferred`; no PR; print implement-failed signal |
| `too_large` | Mark find `too_large`; no PR |
| unset | Real implementer agent (`INCHWORM_AGENT` or `agent`) — never `--yolo` / `--force` / `--trust` |

## Success path

1. Implementer finishes in the worktree
2. Read and delete the agent's PR draft under `.inchworm/pr/`, commit any leftover changes, then check no commit message names the runner
3. Push branch: `git push -u origin HEAD` — the first push, never forced (skipped entirely when `INCHWORM_IMPLEMENT_FIXTURE` is set; live soft-fails → deferred)
4. Coordinator: `gh pr create --draft --base develop --title … --body-file …`
5. Set `state.active_draft_pr` to the printed PR URL
6. Mark find `status: in_pr`
7. Print opened-draft signal + URL
8. Continue to review → fix → ping (see [review-fix-boundary](review-fix-boundary.md)); a fixer pass rewrites this branch and pushes it again with `--force-with-lease`, and after ping the implement worktree is removed (keep the branch)

## Failure / no second pick

On implement failure (`fail` / agent non-zero / push fail / draft fail / `too_large` / cannot resolve `origin/develop`):

- Mark the selected find `deferred` or `too_large`
- Do **not** call `gh pr create` (or stop if create already failed)
- Leave `active_draft_pr` null
- Do **not** pick a second find — the day's stamp is already burned
- Skip review / fixer / ping
- If a worktree was created for this attempt, clean it up (keep any branch it created)

## Forbidden

- Never pass `--yolo`, `--force`, or `--trust` to the agent
