---
name: inchworm
description: Coordinator-first daily create-window runner for inchworm finds (scouts → curator → pick → implementer → draft PR → reviewer → fixer → ping). Use when running inchworm, curating finds.md, or picking the next open find.
---

# Inchworm

Coordinator skill for the inchworm daily create-window runner (Phase 5).

## North star

When a find is not an easy change, inchworm's job is to notice that. The destination is Kent Beck's sequence: make the change easy (caution: this may be hard), then make the easy change — one thin, behavior-preserving PR per day until the original find *is* the easy change. Today's runner cannot park the original and pick only the next extract slice (identity would collapse them; tidy drops `too_large`; pick has no "blocked on"), so the stop is `too_large`. This paragraph is not permission to extract and ship policy in one sitting, or to keep a seam-move find in the open backlog.

## Phase 5 scope (discover → implement → draft PR → review → fix → ping → schedule)

On an eligible `inchworm run`:

1. Stamp `last_run_date` (burns the day; no second pick same day)
2. Ensure the finds directory for the repo path hash
3. Run scouts (smell, lint, errors, backlog — fixtures when `INCHWORM_SCOUT_FIXTURE_DIR` is set; otherwise live `INCHWORM_AGENT` per source)
4. Curator merges candidates into `finds.md`, then tidies (drop `deferred`/`too_large`; cap open at 20)
5. Pick the highest-priority open find (lowest rank)
6. If none: **stop** — no implementer, no worktree, no `gh pr create`
7. If selected: run the **implementer** in a **Worktrunk** checkout on branch `<branch_prefix>/<slug>-<YYYYMMDD>` based on freshly fetched `origin/develop`
8. On success: **push** the branch — the first push, `git push -u origin HEAD`, never forced — then coordinator `gh pr create --draft --base develop`, set `state.active_draft_pr` to the PR URL, mark find `in_pr`
9. On implement failure: mark find `deferred` or `too_large`, no PR, **no second pick** (stamp already burned); skip review / fixer / ping
10. After successful draft PR: run full **Standard `pr-review`** once (not lite) → map verified blockers → optional one **fixer** pass → squash implement + fix into one authored commit and update the draft branch with `git push --force-with-lease` → **ping** immediately; then `wt remove --no-delete-branch` the implement checkout (keep the branch)

Never pass `--yolo`, `--force`, or `--trust` to any agent. Only the implement branch is ever force-pushed, and only with `--force-with-lease` — never `develop` or `main`. No review↔fix loop. No auto-ready / merge.

## Everything a reviewer sees is the author's own work

Branch names, commit messages, and PR copy carry no trace of the runner. See [authored-output](references/authored-output.md) — that boundary is not optional.

## Schedule (LaunchAgent)

Phase 5 owns the weekday create-window schedule via LaunchAgent `com.inchworm` (hours 8–14). See [launchd-install](references/launchd-install.md).

## Roles

- **Scout** — propose candidates (see [scout-prompts](references/scout-prompts.md))
- **Curator** — merge/dedupe into durable `finds.md` (see [curator-prompt](references/curator-prompt.md))
- **Pick** — choose one open find or report none (see [discover-boundary](references/discover-boundary.md))
- **Implementer** — code the selected find in a Worktrunk checkout (see [implementer-prompt](references/implementer-prompt.md)); smallest change preserves other callers' semantics, so unbounded shared retry/report/fail-loud policy is `too_large` (see [shared-seam](references/shared-seam.md))
- **Coordinator** — push branch, draft PR, state updates, then review → fix → ping (see [implement-boundary](references/implement-boundary.md), [review-fix-boundary](references/review-fix-boundary.md))
- **Reviewer** — full Standard `pr-review` (see [reviewer-prompt](references/reviewer-prompt.md))
- **Fixer** — one pass on verified blockers only (see [fixer-prompt](references/fixer-prompt.md))
- **Human review** — `inchworm review` sits on a Worktrunk checkout of an open draft for discussion after a relic sweep (see [human-review](references/human-review.md)); not the daily Standard `pr-review` loop

## References

- [authored-output](references/authored-output.md)
- [candidate-schema](references/candidate-schema.md)
- [finds-format](references/finds-format.md)
- [repo-config](references/repo-config.md)
- [shared-seam](references/shared-seam.md)
- [scout-prompts](references/scout-prompts.md)
- [curator-prompt](references/curator-prompt.md)
- [discover-boundary](references/discover-boundary.md)
- [implementer-prompt](references/implementer-prompt.md)
- [implement-boundary](references/implement-boundary.md)
- [reviewer-prompt](references/reviewer-prompt.md)
- [fixer-prompt](references/fixer-prompt.md)
- [review-fix-boundary](references/review-fix-boundary.md)
- [human-review](references/human-review.md)
- [launchd-install](references/launchd-install.md)
