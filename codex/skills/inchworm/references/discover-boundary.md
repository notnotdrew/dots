# Discover boundary

After scouts → curator → pick, either a find is selected or none remains.

## Preflight (before the stamp)

Scouts cost agent calls and the stamp burns the day, so the conditions the day
depends on are checked while nothing has been spent yet: `wt` on `PATH`, an
`origin` remote, a successful `git fetch origin`, and a resolvable
`origin/develop`.

A preflight failure is an unattempted day, not a failed one:

- Do **not** stamp `last_run_date` — the next tick inside the create window retries
- Do **not** run scouts, write `finds.md`, or touch any find's status
- Print the reason and alert the human (same notify channel as the ping)

`INCHWORM_IMPLEMENT_FIXTURE` relaxes the base checks exactly as it does at
implement time, so fixture repos without a remote still run.

## Allowed

- Ensure finds dir / write `finds.md`
- Run scouts (fixtures via `INCHWORM_SCOUT_FIXTURE_DIR`, or live agent for smell / lint / errors / backlog)
- Curator merge, dedupe, and tidy (drop deferred/too_large; cap open at 20; keep in_pr)
- Pick lowest-rank `status: open` find
- Print selected id + title, or a clear none signal

## After pick

- If **none**: stop — no implementer, no worktree, no `gh pr create`
- If **selected**: hand off to the implementer path (see [implement-boundary](implement-boundary.md))

## Forbidden at discover time

- Do not pass `--yolo`, `--force`, or `--trust` to the agent
- Do not open a draft PR before implement succeeds
- Do not pick a second find if implement later fails (stamp already burned)

If no open finds remain after merge, print a clear none / no eligible find message and exit successfully.
