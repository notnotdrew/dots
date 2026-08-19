# Reviewer prompt (Phase 4)

Run a full **Standard `pr-review`** against the draft PR URL. Do **not** use an inchworm-lite reviewer.

## Contract

- Launcher: `INCHWORM_PR_REVIEW` (default sibling `bin/pr-review` or PATH)
- Mode: Standard (not lite, not deep-only shortcuts)
- Artifacts dir: set `INCHWORM_REVIEW_ARTIFACT_DIR` to `$INCHWORM_DATA_DIR/<path-hash>/review/`
- Required artifact: `findings-ledger.md` (also write `context-brief.md` / `perfect-review.md` when available)
- Invoke review **exactly once** per successful draft PR

## Fixtures (`INCHWORM_REVIEW_FIXTURE`)

| Value | Ledger shape |
| --- | --- |
| `none` | No findings |
| `advisory` | Verified Class: advisory only |
| `blocking` | ≥1 Class: blocking + Disposition: verified (plus non-driving candidates/advisories OK) |
| unset | Live Standard `pr-review` against the draft PR URL |

## Forbidden

- No inchworm-lite reviewer path
- No second review after fixer
- Never `--yolo` / `--force` / `--trust`
