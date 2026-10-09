---
name: inchworm
description: Coordinator-first daily create-window runner for inchworm finds (scouts → curator → pick → plan → implement → draft PR → ping). Use when running inchworm, curating finds.md, or picking the next open find.
disable-model-invocation: true
---

# Inchworm

Coordinator skill for the inchworm daily create-window runner (Phase 5).

## North star

When a find is not an easy change, inchworm's job is to notice that. The destination is Kent Beck's sequence: make the change easy (caution: this may be hard), then make the easy change — one thin, behavior-preserving PR per day until the original find *is* the easy change. Today's runner cannot park the original and pick only the next extract slice (identity would collapse them; tidy drops `too_large`; pick has no "blocked on"), so the stop is `too_large`. This paragraph is not permission to extract and ship policy in one sitting, to keep a seam-move find in the open backlog, or to spend the day on a leftover-write cleanup inside a region the tree already marked provisional.

## Keep the coordinator small

Run `inchworm run` or `inchworm now`; do not reproduce the pipeline in the
current agent session. The shell process owns orchestration and durable state.
Each scout, planner, and implementer starts in a fresh agent context and returns
through files. The coordinator keeps only the selected find, branch, plan
result, and draft PR URL.

After a find is selected:

1. A fresh agent runs a short thin-check prompt and writes `.inchworm/plan.md`
   or `not_thin`. It does not follow `writing-simple-plans`. It does not implement.
2. `not_thin` skips the implementer and marks the find `too_large`: no draft PR.
3. A second fresh agent implements that plan, commits, writes
   `.inchworm/pr/title.txt` and `.inchworm/pr/body.md`, and stops. It does not
   push, open a pull request, review, or fix.
4. The shell commits any leftover edits, pushes, opens the draft with the footer
   already in the body, runs one Standard review, runs one fixer only for a
   verified blocker, pings, and removes the checkout.

## Scope (discover → plan → implement → draft PR → ping → schedule)

LaunchAgent ticks call gated `inchworm run`. `inchworm now` is the same core without the weekday / create-window / same-day / blocking-draft gates.

On an eligible `inchworm run`:

1. Preflight before spending anything: `wt`, `origin`, a successful `git fetch origin --prune`, a resolvable trunk (`origin/<base_branch>`, default `main`). A failure here is a day that never started — no progress, no stamp, no scouts, no find touched, alert the human, and the next tick in the window retries (see [discover-boundary](references/discover-boundary.md))
2. Record progress (`state.progress`, find, date, pid). A later tick skips while that pid is alive. A dead pid or a previous day is cleared. `last_run_date` is set when a draft PR opens, or when discover selects nothing
3. Ensure the finds directory for the repo path hash
4. Run today's scout. Weekdays rotate one source: Monday smell, Tuesday backlog, Wednesday lint, Thursday errors, Friday slow. Skip it when `finds.md` already has an open find from that source, then pick the best open find from any source. A weekend `inchworm now` uses smell. Fixtures (`INCHWORM_SCOUT_FIXTURE_DIR`) still load every source file. The slow scout uses `pup` against Datadog APM.
5. Curator merges candidates into `finds.md`, then tidies (drop `deferred`/`too_large`; cap open at 20)
6. Pick the highest-priority open find (lowest rank)
7. If none: **stop** — no implementer, no worktree, no `gh pr create`
8. If selected: create a **Worktrunk** checkout on branch `<branch_prefix>/<slug>-<YYYYMMDD>` based on the freshly fetched trunk
9. Run a fresh thin-check. The short prompt writes `.inchworm/plan.md` or `not_thin`. It does not follow `writing-simple-plans`. `not_thin` marks the find `too_large` and does not launch the implementer.
10. Run a fresh implementer. It implements the plan, commits, writes the PR title and body files, and stops.
11. The shell pushes, opens the draft (`gh pr create --draft`) with the footer already in the body, sets `state.active_draft_pr`, marks the find `in_pr`, runs one Standard `pr-review`, runs one fixer only for a verified blocker, pings, then `wt remove --no-delete-branch` the checkout (keep the branch).
12. On failure: the same process does not pick a second find. Clear progress, do not stamp the day, alert the human, and clean up the checkout. A later tick may pick again. A `not_thin` plan marks the find `too_large` and also leaves the day unstamped; an implementer failure is `deferred` and opens no PR.

Never pass `--yolo`, `--force`, or `--trust` to any agent. Only the implement branch is ever force-pushed, and only with `--force-with-lease` — never `develop` or `main`. No auto-ready / merge.

## Everything a reviewer sees is the author's own work

Branch names, commit messages, and PR titles carry no trace of the runner. The one allowed PR-body mention is the footer in [authored-output](references/authored-output.md) — that boundary is not optional.

## Schedule (LaunchAgent)

Phase 5 owns the weekday create-window schedule via LaunchAgent `com.inchworm` (hours 8–15, every 30 minutes; no work at or after 16:00). See [launchd-install](references/launchd-install.md).

## Roles

- **Scout** — propose candidates (see [scout-prompts](references/scout-prompts.md))
- **Curator** — merge/dedupe into durable `finds.md` (see [curator-prompt](references/curator-prompt.md))
- **Pick** — choose one open find or report none (see [discover-boundary](references/discover-boundary.md))
- **Planner** — short thin-check prompt; writes `.inchworm/plan.md` or `not_thin`. It does not follow `writing-simple-plans`. `not_thin` skips the implementer and marks `too_large`
- **Implementer** — implements that plan, commits, writes `pr/title.txt` and `pr/body.md`, and stops (see [implementer-prompt](references/implementer-prompt.md))
- **Coordinator** — owns checkout, push, draft PR, Standard review, fixer, ping, and cleanup (see [implement-boundary](references/implement-boundary.md))
- **Human review** — `inchworm review` sits on a Worktrunk checkout of an open draft for discussion after a relic sweep and an adequacy check (did the change go far enough, or is it a nibble in dead code?) (see [human-review](references/human-review.md)); not the daily Standard `pr-review` loop

## References

- [authored-output](references/authored-output.md)
- [candidate-schema](references/candidate-schema.md)
- [finds-format](references/finds-format.md)
- [repo-config](references/repo-config.md)
- [shared-seam](references/shared-seam.md)
- [scout-prompts](references/scout-prompts.md)
- [curator-prompt](references/curator-prompt.md)
- [discover-boundary](references/discover-boundary.md)
- [implement-boundary](references/implement-boundary.md)
- [human-review](references/human-review.md)
- [launchd-install](references/launchd-install.md)
