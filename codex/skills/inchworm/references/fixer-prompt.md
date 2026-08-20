# Fixer prompt (Phase 4)

One fixer pass when the findings ledger has verified blockers. Blocking-only; then stop.

## Blocking mapping (locked)

A finding drives the fixer only when:

- `Class: blocking`
- **and** `Disposition: verified`

Advisory findings and non-verified dispositions stay for the human. `none` / advisory-only ledgers → **skip fixer**.

## Contract

- At most **one** fix pass per run
- **No** second review after fix (no review↔fix loop)
- **No** second pick (day already stamped)
- Work in the existing implement worktree
- Do not resolve a blocker by widening shared retry, discard, notify, or error classification; leave it residual (see [shared-seam](shared-seam.md))
- Commit with the **writing-git-commits** skill, naming no tooling (see [authored-output](authored-output.md))
- The agent does **not** push and does **not** open a PR — the coordinator owns the history and the remote
- Honor optional **Repo guidance** from `.inchworm.yml` when the coordinator injects it
- Never pass `--yolo`, `--force`, or `--trust`

## Fixtures (`INCHWORM_FIX_FIXTURE`)

| Value | Behavior |
| --- | --- |
| `success` | Write `$INCHWORM_DATA_DIR/<path-hash>/fix/fixture-ran` with `success`, and leave tracked fix content in the worktree so the leftover-commit → rewrite → push path has something to land |
| `fail` | Write `fixture-ran` with `fail`; surface residual/blocking in output; nothing is landed; still ping |
| unset | Live fixer agent in the implement worktree (blocking only) |

## After fix

A pass that only edited the worktree has fixed nothing anyone can see, so the coordinator lands it: commit leftovers, squash implement + fix into one authored commit, then `git push --force-with-lease` onto the existing draft branch. Fixture mode skips the network but still rewrites locally. Full contract in [review-fix-boundary](review-fix-boundary.md).

Then ping with the draft PR URL — even when residual blockers remain, and even when the fix could not be pushed (a fix that stayed local is a fixer failure and says so).
