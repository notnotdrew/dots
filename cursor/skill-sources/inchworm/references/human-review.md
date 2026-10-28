# Human `inchworm review`

Operator command. It follows the shell's completed draft — plan, implement,
publish, one Standard review, one fixer for a verified blocker — and does not
auto-ready the draft.

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

## Checks before discussion (child agent, not the coordinator)

The launched agent is told to review the PR and be ready to discuss it. Before discussing, it does three checks:

1. **Relics** — agent-like leftovers (verbose or tombstone comments/specs). If it finds any, it addresses them. If none, it says so.
2. **Loading specs** — specs that test Rails loading, including N+1s. Query counts, a small collection versus a large one to prove the count does not grow, and assertions that an association is already loaded. Useful while developing the fix; they do not stay in the long-term suite. For an N+1 fix, a spec stays only when it covers a behavioral gap the suite does not already cover. Query-count assertions in that spec still go. [screensteps-live#7835](https://github.com/screensteps/screensteps-live/pull/7835/changes) is the shape to remove: an article-list example that counts `courses` and `lesson_versions` queries for one row and for five.
3. **Adequacy** — whether the change goes far enough. A patch that only repairs a tiny spot in unused or otherwise dead code should have been a deletion of that code. Lead with that; do not treat the nibble as complete, and do not silently expand into a large deletion.

If relics or loading specs changed the branch, it folds them into the **existing** commits (amend/squash; no tooling-named cleanup stack) and `git push --force-with-lease`.

Then it discusses. Only the implement branch may be force-pushed; never `develop` or `main`. Reviewer-facing copy still follows [authored-output](authored-output.md) (tool name as a word vs path-shaped mentions). The "Picked and implemented by" footer on the PR body is the coordinator's deliberate attribution, not a relic; the review agent leaves it in place.

## Distinct from daily run

Daily `inchworm run` plans, then an implementer commits and stops. The shell
pushes, opens the draft with the footer already in the body, runs one Standard
review, runs one fixer only for a verified blocker, pings, and removes the
checkout. `inchworm review` is the human sitting down with that already-open draft.
