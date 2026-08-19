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
- Honor optional **Repo guidance** from `.inchworm.yml` when the coordinator injects it
- Never pass `--yolo`, `--force`, or `--trust`

## Fixtures (`INCHWORM_FIX_FIXTURE`)

| Value | Behavior |
| --- | --- |
| `success` | Write `$INCHWORM_DATA_DIR/<path-hash>/fix/fixture-ran` with `success` |
| `fail` | Write `fixture-ran` with `fail`; surface residual/blocking in output; still ping |
| unset | Live fixer agent in the implement worktree (blocking only) |

## After fix

Ping immediately with the draft PR URL — even when residual blockers remain.
