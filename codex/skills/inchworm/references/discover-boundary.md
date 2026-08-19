# Discover boundary

After scouts → curator → pick, either a find is selected or none remains.

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
