---
name: inchworm
description: Coordinator-first daily create-window runner for inchworm finds (scouts → curator → pick → implementer → draft PR → reviewer → fixer → ping). Use when running inchworm, curating finds.md, or picking the next open find.
---

# Inchworm

Coordinator skill for the inchworm daily create-window runner (Phase 5).

## Phase 5 scope (discover → implement → draft PR → review → fix → ping → schedule)

On an eligible `inchworm run`:

1. Stamp `last_run_date` (burns the day; no second pick same day)
2. Ensure the finds directory for the repo path hash
3. Run scouts (smell, lint, errors, backlog — fixtures when `INCHWORM_SCOUT_FIXTURE_DIR` is set; otherwise live `INCHWORM_AGENT` per source)
4. Curator merges candidates into `finds.md`, then tidies (drop `deferred`/`too_large`; cap open at 20)
5. Pick the highest-priority open find (lowest rank)
6. If none: **stop** — no implementer, no worktree, no `gh pr create`
7. If selected: run the **implementer** in a git **worktree** on branch `inchworm/<slug>-<YYYYMMDD>` based on freshly fetched `origin/develop`
8. On success: **push** the branch (`git push -u origin HEAD`), then coordinator `gh pr create --draft --base develop`, set `state.active_draft_pr` to the PR URL, mark find `in_pr`
9. On implement failure: mark find `deferred` or `too_large`, no PR, **no second pick** (stamp already burned); skip review / fixer / ping
10. After successful draft PR: run full **Standard `pr-review`** once (not lite) → map verified blockers → optional one **fixer** pass → **ping** immediately; then remove the implement worktree (keep `inchworm/*` branch)

Never pass `--yolo`, `--force`, or `--trust` to any agent. No review↔fix loop. No auto-ready / merge.

## Schedule (LaunchAgent)

Phase 5 owns the weekday create-window schedule via LaunchAgent `com.inchworm` (hours 8–14). See [launchd-install](references/launchd-install.md).

## Roles

- **Scout** — propose candidates (see [scout-prompts](references/scout-prompts.md))
- **Curator** — merge/dedupe into durable `finds.md` (see [curator-prompt](references/curator-prompt.md))
- **Pick** — choose one open find or report none (see [discover-boundary](references/discover-boundary.md))
- **Implementer** — code the selected find in a worktree (see [implementer-prompt](references/implementer-prompt.md))
- **Coordinator** — push branch, draft PR, state updates, then review → fix → ping (see [implement-boundary](references/implement-boundary.md), [review-fix-boundary](references/review-fix-boundary.md))
- **Reviewer** — full Standard `pr-review` (see [reviewer-prompt](references/reviewer-prompt.md))
- **Fixer** — one pass on verified blockers only (see [fixer-prompt](references/fixer-prompt.md))

## References

- [candidate-schema](references/candidate-schema.md)
- [finds-format](references/finds-format.md)
- [repo-config](references/repo-config.md)
- [scout-prompts](references/scout-prompts.md)
- [curator-prompt](references/curator-prompt.md)
- [discover-boundary](references/discover-boundary.md)
- [implementer-prompt](references/implementer-prompt.md)
- [implement-boundary](references/implement-boundary.md)
- [reviewer-prompt](references/reviewer-prompt.md)
- [fixer-prompt](references/fixer-prompt.md)
- [review-fix-boundary](references/review-fix-boundary.md)
- [launchd-install](references/launchd-install.md)
