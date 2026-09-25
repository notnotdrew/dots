---
name: inchworm
description: Coordinator-first daily create-window runner for inchworm finds (scouts → curator → pick → plan → execute draft PR → ping). Use when running inchworm, curating finds.md, or picking the next open find.
---

# Inchworm

Coordinator skill for the inchworm daily create-window runner (Phase 5).

## North star

When a find is not an easy change, inchworm's job is to notice that. The destination is Kent Beck's sequence: make the change easy (caution: this may be hard), then make the easy change — one thin, behavior-preserving PR per day until the original find *is* the easy change. Today's runner cannot park the original and pick only the next extract slice (identity would collapse them; tidy drops `too_large`; pick has no "blocked on"), so the stop is `too_large`. This paragraph is not permission to extract and ship policy in one sitting, to keep a seam-move find in the open backlog, or to spend the day on a leftover-write cleanup inside a region the tree already marked provisional.

## Keep the coordinator small

Run `inchworm run` or `inchworm now`; do not reproduce the pipeline in the
current agent session. The shell process owns orchestration and durable state.
Each scout, planner, and executor starts in a fresh agent context and returns
through files or GitHub state. The coordinator keeps only the selected find,
branch, plan result, and draft PR URL.

After a find is selected, compose existing generic skills:

1. A fresh agent follows **`writing-simple-plans`** and writes the plan. It does
   not implement.
2. If the result cannot fit one thin, behavior-preserving PR, stop as
   `too_large`.
3. A second fresh agent follows **`executing-draft-pr-plans`**. That skill owns
   implementation, verification, commits, opening the draft PR, Standard
   review, folding fixes, and the final force-with-lease push.
4. The coordinator discovers the draft by its exact branch, records it, pings,
   and removes the checkout.

The reused skills remain generic. Inchworm-specific policy is supplied in each
handoff; it is not added to those skills.

## Scope (discover → plan → execute draft PR → ping → schedule)

LaunchAgent ticks call gated `inchworm run`. `inchworm now` is the same core without the weekday / create-window / same-day / blocking-draft gates.

On an eligible `inchworm run`:

1. Preflight before spending anything: `wt`, `origin`, a successful `git fetch origin --prune`, a resolvable trunk (`origin/<base_branch>`, default `main`). A failure here is a day that never started — no stamp, no scouts, no find touched, alert the human, and the next tick in the window retries (see [discover-boundary](references/discover-boundary.md))
2. Stamp `last_run_date` (burns the day; no second pick same day)
3. Ensure the finds directory for the repo path hash
4. Run scouts (smell, lint, errors, backlog, slow — fixtures when `INCHWORM_SCOUT_FIXTURE_DIR` is set; otherwise live `INCHWORM_AGENT` per source; the slow scout uses `pup` against Datadog APM)
5. Curator merges candidates into `finds.md`, then tidies (drop `deferred`/`too_large`; cap open at 20)
6. Pick the highest-priority open find (lowest rank)
7. If none: **stop** — no implementer, no worktree, no `gh pr create`
8. If selected: create a **Worktrunk** checkout on branch `<branch_prefix>/<slug>-<YYYYMMDD>` based on the freshly fetched trunk
9. Run a fresh planning agent with `writing-simple-plans`. No thin plan means `too_large`; do not launch execution.
10. Run a fresh execution agent with `executing-draft-pr-plans`. It completes the generic workflow through draft PR and Standard review.
11. On success, discover the open draft by exact branch, set `state.active_draft_pr`, mark the find `in_pr`, **ping** immediately, then `wt remove --no-delete-branch` the checkout (keep the branch).
12. On failure: no second pick (stamp already burned), alert the human, and clean up the checkout. A planning verdict can mark the find `too_large`; other attempts are `deferred`.

Never pass `--yolo`, `--force`, or `--trust` to any agent. Only the implement branch is ever force-pushed, and only with `--force-with-lease` — never `develop` or `main`. No auto-ready / merge.

## Everything a reviewer sees is the author's own work

Branch names, commit messages, and PR titles carry no trace of the runner. The one allowed PR-body mention is the footer in [authored-output](references/authored-output.md) — that boundary is not optional.

## Schedule (LaunchAgent)

Phase 5 owns the weekday create-window schedule via LaunchAgent `com.inchworm` (hours 8–15, every 30 minutes; no work at or after 16:00). See [launchd-install](references/launchd-install.md).

## Roles

- **Scout** — propose candidates (see [scout-prompts](references/scout-prompts.md))
- **Curator** — merge/dedupe into durable `finds.md` (see [curator-prompt](references/curator-prompt.md))
- **Pick** — choose one open find or report none (see [discover-boundary](references/discover-boundary.md))
- **Planner** — fresh agent following `writing-simple-plans`; produces only a thin plan or a not-thin result
- **Executor** — fresh agent following `executing-draft-pr-plans`; owns the complete draft PR workflow
- **Coordinator** — owns checkout, state mapping, ping, and cleanup (see [implement-boundary](references/implement-boundary.md))
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
