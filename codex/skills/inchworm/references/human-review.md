# Human `inchworm review`

Operator command. Not the daily-run Standard `pr-review` → fixer → ping pipeline. It does not auto-ready the draft.

## Command

`inchworm review [pr-url|number|repo-path]`

1. List this machine’s open inchworm drafts across registered repos (`INCHWORM_REPO` if set, else global config).
2. Select one (TTY numbered list, or argv when unique).
3. `wt switch` onto that draft’s `headRefName` (create/attach the Worktrunk checkout if daily `run` already removed it).
4. Launch an **interactive** Cursor `agent` in that checkout (no `-p` / `--print`, never `--yolo` / `--force` / `--trust`).

Zero matching drafts: print that and exit 0. Several drafts, no argv, not a TTY: print the list and error (do not hang).

## What counts as an open draft

Same gate as `find_blocking_draft`:

- `isDraft: true`, and
- URL equals `state.active_draft_pr`, **or**
- `headRefName` matches `<branch_prefix>/.+-\d{8}`

A hand-cut draft on the same prefix without the date suffix is not listed unless its URL is the recorded `active_draft_pr`.

## Relic pass (child agent, not the coordinator)

The launched agent is told to review the PR and be ready to discuss it. Before discussing, it sweeps for agent-like relics (verbose or tombstone comments/specs). If it finds any, it folds them into the **existing** commits on this branch (amend/squash; no tooling-named cleanup stack) and `git push --force-with-lease`. If none, it says so and discusses. Only the implement branch may be force-pushed; never `develop` or `main`. Reviewer-facing copy still follows [authored-output](authored-output.md) (tool name as a word vs path-shaped mentions).

## Distinct from daily run

Daily `inchworm run` still does one Standard `pr-review`, at most one fixer, squash, ping, then `wt remove --no-delete-branch`. `review` is the human sitting down with an already-open draft.
