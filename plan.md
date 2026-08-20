# Inchworm follow-on: three sequential agents

Unstaged authored-output / fixer-push work is already on `main` in `/Users/drewprice/dots`. Do not commit unless asked.

Run **one agent after another**. Do not overlap files. Later agents assume earlier ones actually landed.

| Order | Prompt | Depends on |
| --- | --- | --- |
| 1 | Fixer squash authorship + restore + path mentions | Current unstaged Wave 1/2 work |
| 2 | Worktrunk for implement worktrees | Prompt 1 |
| 3 | `inchworm review` | Prompt 2 (stop if Worktrunk is not landed) |

Ignore `cursor/cli-config.json`. Never pass `--yolo`, `--force`, or `--trust` to agents. Never force-push `develop` / `main`. `--force-with-lease` is only for the implement branch.

Shared harness: `./bin/test-inchworm`. `run_inchworm` unsets `INCHWORM_BRANCH_PREFIX` unless a test exported it.

---

# Prompt 1 — Fixer squash authorship + restore + path mentions

You are implementing in `/Users/drewprice/dots`. Work is unstaged inchworm changes on `main`. Do not commit unless asked.

## Purpose

Three leftover holes after the authored-output / fixer-push work. Close them so a reviewer still sees one small clean history, without throwing away a good implementer message, without leaving a dirty squash as local HEAD, and without treating `bin/inchworm` as the runner naming itself.

## Context (do not rediscover)

Current behavior (confirmed):

- `TOOL_NAME_RE='(^|[^[:alnum:]_.])inchworm([^[:alnum:]_]|$)` — leading `.` is exempt (`.inchworm/pr` is fine). `/` is **not**, so `bin/inchworm` and `~/dots/bin/inchworm` still trip rewrite/defer.
- After a fixer pass, `land_fixer_work` leftover-commits then **always** `squash_onto_authored_commit` under the **find** subject/body (`commit_subject` / `commit_body` from the find), then `git push --force-with-lease`. A good implementer message is discarded whenever a fix lands.
- If that replacement message still matches `mentions_tool_name`, squash has already reset+committed. Local HEAD is the dirty authored commit; remote stays pre-fix. Fixer fails, ping still runs. Next checkout of that branch can surprise.
- `test_run_dirty_fix_history_is_not_pushed` relies on a **dirty find title** plus a **clean** implementer commit and clean PR copy so implement still opens; squash then uses the dirty find title and refuses to push.

`./bin/test-inchworm` is the harness. Keep Wave 1 sanitizer tests and `run_inchworm` env isolation.

## Instructions

- Match existing bash/test style.
- Reviewer-facing copy still must not contain the tool name **as a word**. Operator logs may say `inchworm:`.
- Path-shaped mentions must not count: `.inchworm/…`, `.inchworm.yml`, `bin/inchworm`, `…/inchworm` as a path component. Bare `inchworm`, `inchworm:`, `by inchworm` still count. `inchworm/…` at the start of a **branch name** must still count (that is a leak). Exclude `/` the same way `.` is excluded on the **preceding** character; do not switch to plain `grep -w`.
- Squash after a successful fixer pass stays **unconditional** (implement + fix → one commit). The **message** for that commit is:
  1. The pre-fix implement commit’s subject/body, if it is present and does not mention the tool as a word.
  2. Else the find fallback (title / summary / evidence), if that is clean.
  3. Else **do not** leave a dirty replacement commit: restore the branch to the SHA from **before** the squash (restore to `head_before` the fixer started at so local matches the already-pushed implement history). Do not push. Fail the fixer; ping still runs.
- Restoring on dirty/failed squash is required. `reset --hard` to `head_before` is acceptable; the fix stays off the branch and off the remote. Mention in the operator log that the fix stayed local and the checkout matches the pre-fix history.
- If squash `reset --soft` itself fails, also restore if HEAD moved; never push.
- Rewrite `test_run_dirty_fix_history_is_not_pushed` (and any assertion that the squashed subject **must** be the find title after a fix). After this change, a dirty find title + clean implementer message should **keep** the implementer message and **may push**. Cover dirty refuse-push with a case where **no** clean message exists (both implementer message and find fallback dirty, or implementer message missing and fallback dirty) **without** breaking Wave 1: dirty find title still defers at implement unless agent PR copy + agent commit are clean. If that combo cannot produce “no clean squash message”, add a live fixer that would force a dirty-only replacement and assert restore-to-`head_before` + no remote `fix-work.txt`.
- New/adjusted tests must fail for a real bug: (1) fixer lands, implementer subject survives on the single squashed commit; (2) dirty squash does not leave that dirty commit as HEAD; remote still pre-fix; ping happens; (3) a commit body that only mentions `bin/inchworm` or `.inchworm/pr` is **not** rewritten at implement and is **not** treated as dirty at fix.
- Update `codex/skills/inchworm/references/authored-output.md` and `review-fix-boundary.md` so they match (preserve clean implementer message; restore on dirty squash; path components with `/` or `.` do not count). Fix the stale line that says tests use `INCHWORM_BRANCH_PREFIX` if it is still there — harness unsets it unless exported.
- Do not add `inchworm review` or Worktrunk work in this pass.

## Relevant files

- `bin/inchworm` — `TOOL_NAME_RE`, `mentions_tool_name`, `read_agent_pr_body`, `squash_onto_authored_commit`, `sanitize_branch_commits`, `land_fixer_work`, `run_blocking_fixer`
- `bin/test-inchworm` — `TOOL_NAME_WORD_RE`, `assert_no_tool_name_in_branch_commits`, `test_run_keeps_commit_that_only_names_the_draft_path`, `test_run_fixer_work_lands_on_the_implement_branch`, `test_run_fixer_rewrite_pushes_authored_history`, `test_run_dirty_fix_history_is_not_pushed`
- `codex/skills/inchworm/references/authored-output.md`
- `codex/skills/inchworm/references/review-fix-boundary.md`

## Workflow

1. Change the regex (production + test helper) and add/adjust a test for `bin/inchworm` in a commit body (must not squash at implement).
2. Change `land_fixer_work` to pick the squash message as specified, and restore `head_before` whenever squash cannot publish a clean commit.
3. Fix tests and the two skill refs.
4. Run `./bin/test-inchworm` to green.

### Execution Status

Status: completed
Updated: 2026-08-20
ExecutionMode: single-agent

Strict tester/engineer subagents were skipped: the phase is one bash CLI plus sociable `./bin/test-inchworm` cases, so splitting RED/GREEN across process boundaries would be artificial. TDD still applied (failing tests first, then production).

### Automated Verification

- `./bin/test-inchworm`
- Passed (53 tests)

### Review And Simplification

- Collapsed duplicated squash-subject/body helpers into `pre_fix_commit_is_clean` / `find_fallback_is_clean`.
- Re-ran `./bin/test-inchworm` after that refactor.

### Manual Verification Result

- None required beyond the harness.

### Blockers Or Follow-Up Notes

- Wave 1 still defers when both the implementer message and the find fallback name the runner, so “no clean squash message” cannot reach the fixer. Refuse-push + restore is covered by a failed `reset --soft` during squash (leftover fix commit must not remain as HEAD).
- Prompt 2 (Worktrunk) and Prompt 3 (`inchworm review`) were not started.

## Report

- **Message-selection order:** clean pre-fix implement commit (subject + body from that SHA), else clean find fallback (`commit_subject` / `commit_body`), else restore and fail.
- **Restore:** `git reset --hard` to `head_before` when there is no clean message or when `squash_onto_authored_commit` fails (including failed `reset --soft`). Operator log: fix stayed local; checkout matches pre-fix history. No push. Ping still runs.
- **Exact regex:** `TOOL_NAME_RE='(^|[^[:alnum:]_./])inchworm([^[:alnum:]_]|$)'` (same in `TOOL_NAME_WORD_RE`).
- **Tests:** path mentions include `bin/inchworm`; new keep-implementer and path-through-fix cases; `test_run_dirty_fix_history_is_not_pushed` now asserts restore-to-pre-fix on failed squash.
- **Still dirty:** leftover fixer commits still use the find subject/body before squash (bookkeeping; unpublished if restore runs). No Worktrunk / `inchworm review` in this pass.

---

# Prompt 2 — Worktrunk for implement worktrees

You are implementing in `/Users/drewprice/dots`. Do not commit unless asked.

## Purpose

Stop creating implement checkouts with raw `git worktree add` under `.inchworm/worktrees/`. Use Worktrunk (`wt`) so implement/fixer agents get the same layout, hooks, and includes as every other Worktrunk checkout on this machine.

## Why this exists

Today `create_implement_worktree` does `git worktree add` at:

`<repo>/.inchworm/worktrees/<branch_prefix>-<slug>-<YYYYMMDD>`

Cleanup is `git worktree remove --force` plus `rm -rf`. After ping, the daily run removes that registration and keeps the branch.

Raw worktrees skip Worktrunk’s layout. Elsewhere in this dots tree the rule is already: use Worktrunk, not `git worktree add`. Honeybadger triage: `wt switch --create <branch>` → checkout beside the repo as `<repo-path>.<branch>`. `bin/pr-review` uses `wt switch --no-cd --execute`.

Prompt 1 (squash authorship / path mentions) should already be landed. Do not reopen that work except to keep tests green after path changes.

## Instructions

- Match existing bash/Ruby/test style.
- Do not add an `inchworm review` command. That is Prompt 3.
- Do not keep a migration shim that still `git worktree add`s under `.inchworm/worktrees/` in production.
- Fixture mode may still skip network, but must still create a real checkout the rest of the pipeline can `git -C` into (commits, leftover, sanitize, fixer land).
- After ping, still remove the implement checkout and keep the branch (today’s contract), unless Worktrunk has no remove and you document the equivalent (`wt remove` / `wt rm` — verify with `wt --help`; do not guess).
- `ensure_workspace_trusted` must keep working: the agent CLI refuses untrusted dirs and `--trust` is forbidden. Trust the **actual** Worktrunk path (physical path / slug), not the old `.inchworm/worktrees/…` path.
- Base remains freshly fetched `origin/develop`. Soft-fail (defer, no PR) when origin/`origin/develop` cannot be resolved, same as now.
- If the branch already exists, switch/attach; do not fail because `-b` would collide. If a stale Worktrunk checkout for that branch exists, remove/recreate or reuse — daily `run` must still open the draft (today’s stale-path test).
- Run `wt switch --help` / `wt list --help` and follow that CLI. Do not invent flags. Prefer JSON/`--format json` if it exists for parsing the checkout path.
- Branch names are `<prefix>/<slug>-<YYYYMMDD>` (slash in the name). Confirm how Worktrunk encodes that in the filesystem path; tests must assert the real path, not the old `.inchworm/worktrees/` shape.
- Authored-output rules are unchanged (tool name as a word vs path-shaped mentions from Prompt 1). Operator logs may still say `inchworm:`.

## Relevant files

- `bin/inchworm` — `create_implement_worktree`, `cleanup_implement_worktree`, `ensure_workspace_trusted`, `run_implement_and_pr` (path construction), `run_review_fix_ping` (cleanup after ping)
- `bin/test-inchworm` — `expected_worktree_path_for`, `assert_no_inchworm_worktree_registered`, `assert_implement_worktree_or_branch`, `test_run_pretrusts_implement_worktree`, `test_run_success_removes_worktree_keeps_branch`, `test_run_stale_worktree_path_still_opens_draft_pr`, harness header comments that hard-code `.inchworm/worktrees/`
- Skill refs that say “git worktree under `.inchworm/worktrees/`”: `codex/skills/inchworm/SKILL.md`, `references/implement-boundary.md`, `references/review-fix-boundary.md`, `references/implementer-prompt.md`
- Patterns to copy, not paste blindly: `codex/skills/triaging-honeybadger-low-hanging-fruit/SKILL.md` (Step 5), `bin/pr-review` (`wt switch`)

## Workflow

1. Read the functions and tests above. Read `wt --help` so create/list/remove/switch match the installed CLI.
2. Replace create: from repo cwd, create or attach a Worktrunk checkout of `<branch_prefix>/<slug>-<YYYYMMDD>` based on `origin/develop` (create branch if missing). Capture the absolute checkout path; all later `git -C` / agent `cd` use that path.
3. Replace cleanup: remove the Worktrunk checkout, keep the branch. Never delete `develop`/`main`.
4. Update tests so they can fail if production still uses `.inchworm/worktrees/` or raw `git worktree add` on the success path. Mock `wt` via PATH/`TEST_ROOT/fake-bin` if live Worktrunk is too heavy; the mock must still produce a git checkout the rest of the run can commit in (a real `git worktree` **inside the test fake** is fine; production must not).
5. Rewrite skill refs so coordinator/implementer docs say Worktrunk, not `.inchworm/worktrees/`.
6. Run `./bin/test-inchworm` to green. Fix breakage you caused.

### Execution Status

Status: completed
Updated: 2026-08-20
ExecutionMode: single-agent

Strict tester/engineer subagents were skipped: one bash CLI plus sociable `./bin/test-inchworm` cases, same as Prompt 1.

### Automated Verification

- `./bin/test-inchworm`
- Passed (53 tests)

### Review And Simplification

- Create prints the Worktrunk path from `wt switch --format json` rather than guessing `.inchworm/worktrees/`.
- Cleanup is `wt remove --no-delete-branch --force --foreground`; protected `develop`/`main`/`master` and the primary checkout are refused.

### Manual Verification Result

- None required beyond the harness. Live `wt switch --format json --create` on this machine places `<repo>.<branch with / as ->`.

### Blockers Or Follow-Up Notes

- Prompt 3 (`inchworm review`) was not started.

## Report

- **Create:** `wt -C <repo> -y switch --no-cd --format json --clobber` plus `--create --base=<origin/develop>` when the branch is new; omit `--create` when it already exists. Hooks still run (no `--no-hooks`).
- **Remove:** `wt -C <repo> -y remove --no-delete-branch --force --foreground <branch-or-path>`.
- **Checkout path:** Worktrunk default `<repo>.<branch>` with `/` → `-` (e.g. `…/app.tester-smell-trust-20260818`). Trust markers use that physical path.
- **Tests:** mock `wt` on `TEST_ROOT/fake-bin` still `git worktree add`s at the sibling path; success path asserts `wt switch` + `--no-delete-branch`; expected path is no longer `.inchworm/worktrees/`; skill corpus requires Worktrunk and forbids `.inchworm/worktrees/`.
- **Production `git worktree add`:** none left in `bin/inchworm`. The test mock may still use it internally.

---

# Prompt 3 — `inchworm review`

You are implementing in `/Users/drewprice/dots`. Do not commit unless asked.

## Purpose

Add `inchworm review`: list this machine’s open inchworm drafts, let the human pick one, put the shell on that repo’s Worktrunk checkout for the draft branch, and launch an interactive agent prepared to discuss the PR — after a relic sweep, folded into the existing commits, force-with-lease pushed.

This is **not** the daily-run Standard `pr-review` / fixer / ping pipeline. Do not reuse that loop or auto-ready the draft.

## Prerequisite (Prompt 2 already landed)

Implement/fixer checkouts are Worktrunk, not `.inchworm/worktrees/`. Daily `run` still removes the checkout after ping and keeps the branch. `review` must `wt switch` (create/attach if the daily run already removed it). If Prompt 2 is not actually landed, stop and say so; do not reintroduce `.inchworm/worktrees/`.

## What “open inchworm drafts” means

Same recognition as the create-window draft gate (`find_blocking_draft` / `gh pr list --author @me --state open --json number,url,isDraft,headRefName`):

- `isDraft: true`, and
- URL equals `state.active_draft_pr`, **or**
- `headRefName` matches `<branch_prefix>/.+-\d{8}`

Scan **registered repos** (global config, `INCHWORM_REPO` if set). List all matching drafts across repos, not only cwd.

## Instructions

- Match existing CLI style (`usage`, `cmd_*`, `main` case). Add `review` to usage.
- Never `--yolo` / `--force` / `--trust` on the launched agent. `--force-with-lease` is only for git on the **implement branch**, and only from the launched agent after relics are folded. Never force-push `develop` / `main`.
- Interactive: the `review` **command** lists and switches; the **child agent** does the relic pass and discussion. Do not try to do the code review inside `bin/inchworm`.
- Launch like other live agents (`INCHWORM_AGENT`, cwd = Worktrunk checkout). Prefer an interactive session (`agent` without `-p` if that is how Cursor CLI attaches in a checkout); if the only existing pattern is `agent -p`, use that with the prompt below. Look at `implement_with_agent` / `bin/pr-review` (`wt switch --execute`) and pick the one that actually leaves the human in a discussable session in that checkout.
- Selection: numbered list to a TTY (repo path, branch, PR URL). Optional argv: PR URL or number, or repo path — skip the prompt when unique. Zero drafts: print that and exit 0. Non-TTY with multiple drafts and no argv: error, do not hang.
- After selection: `cd` / `wt switch` so the checkout is the draft `headRefName` (create if missing). Then launch the agent.
- The child prompt must be operator-facing and close to:

  Review the PR for this branch & be prepared to discuss it. Before discussing, check for odd agent-like relics left by the agent that worked on it: unnecessary or overly verbose comments, "tombstone" comments or specs, etc. If spotted, address those issues and fold them into the appropriate commits, push (force with lease), and then briefly summarize those changes.

  Tighten only as needed: fold into existing commits (amend/squash on this branch only, not a stack of “cleanup” commits named after tooling); `git push --force-with-lease`; if no relics, say so and discuss. Do not name the daily runner in commit messages or PR copy (authored-output word rule; path-shaped mentions are fine).
- Do not implement relic cleanup in the coordinator. Tests should assert the prompt text and that `wt`/agent were invoked in the selected checkout — not that relics were found.
- Update skill refs (`SKILL.md` usage/roles, a short boundary or status note). Keep daily-run docs distinct from this human `review` command.
- Tests: `./bin/test-inchworm`. New tests must fail if listing uses the wrong draft rule, if selection does not switch Worktrunk, or if the agent is launched without the relic/force-with-lease instructions. Mock `gh`, `wt`, and `agent`. Honor `run_inchworm` env isolation.

## Relevant files

- `bin/inchworm` — `usage`, `main`, `gh_pr_list_json`, `find_blocking_draft`, `list_registered_repos`, `resolve_branch_prefix`, Worktrunk create/switch/remove helpers from Prompt 2
- `bin/lib/inchworm_yaml.rb` — `find_blocking_draft` (reuse or extract a “list all matching drafts” helper; do not fork a second branch regex)
- `bin/test-inchworm` — mock gh draft list, `TEST_BRANCH_PREFIX`, `run_inchworm`
- `codex/skills/inchworm/SKILL.md` and references
- `bin/pr-review` — `wt switch --execute` pattern (discuss vs copy)

## Workflow

1. Confirm Worktrunk helpers exist in `bin/inchworm`. If create is still `.inchworm/worktrees/`, stop.
2. Add listing (all registered repos, gate-shaped drafts) and tests for zero / one / several, including a hand-cut draft without `-<YYYYMMDD>` that must **not** appear.
3. Add selection + Worktrunk switch + agent launch with the relic prompt. Tests for unique argv skip, non-TTY multi-draft failure, and recorded `wt` + agent invocations.
4. Docs + `./bin/test-inchworm` green.

## Report

- Command UX (list columns, argv)
- How Worktrunk switch and agent launch work
- Tests added
- Whether the session is interactive or `-p` one-shot, and why
