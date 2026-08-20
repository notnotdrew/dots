# Review → fix → ping boundary

After a successful draft PR (`gh pr create --draft`, `active_draft_pr` set, find `in_pr`), the coordinator continues:

1. **Review** — full Standard `pr-review` once (see [reviewer-prompt](reviewer-prompt.md))
2. **Map blocking** — Class: blocking + Disposition: verified only
3. **Fix** — one fixer pass if blockers exist; otherwise skip (see [fixer-prompt](fixer-prompt.md))
4. **Land the fix** — commit leftovers, rewrite for a clean authored history, force-with-lease onto the draft branch (below)
5. **Ping** — notify immediately with the PR URL (even if fix failed / residual blockers)
6. **Cleanup** — `wt remove --no-delete-branch --force` the implement Worktrunk checkout (keep the implement branch)

## Landing the fix

The human is pinged next, so this is the point where the remote draft branch has to be both current and presentable.

1. `commit_leftover_changes` — fixers routinely edit files and never commit them; the leftover commit uses the find's subject and body
2. If nothing changed since the fixer started, stop: the pushed branch already matches
3. Squash `origin/develop..HEAD` into one authored commit (always — not only when a message is dirty). Message order: clean pre-fix implement commit, else clean find fallback. If squash `reset --soft` fails, or neither message is clean, `reset --hard` to the pre-fix SHA so the checkout matches the already-pushed implement history; do not push. See [authored-output](authored-output.md)
4. `git push --force-with-lease origin HEAD` — updates the branch the draft PR already points at; the lease is what stops a human's commit being dropped

Rules:

- Only the implement branch is ever force-pushed. `develop`, `main`, and `master` are refused outright.
- If neither squash message is clean, or squash itself fails, restore to the pre-fix SHA and do **not** push. The fixer fails and says the fix stayed local and the checkout matches the pre-fix history; a stale remote beats a published leak.
- A failed live push is also a fixer failure. The ping still happens (see below), and the log says the remote still has the pre-fix history.
- Fixture runs (`INCHWORM_IMPLEMENT_FIXTURE` / `INCHWORM_FIX_FIXTURE`) skip the network for both pushes but still rewrite locally, and log the first push and the post-fix push distinguishably.

## Artifacts

- Review dir: `$INCHWORM_DATA_DIR/<path-hash>/review/`
- Required: `findings-ledger.md`
- Coordinator always sets `INCHWORM_REVIEW_ARTIFACT_DIR` when launching the reviewer

## Ping

- Always print `inchworm: ping — draft PR <url>`
- If `INCHWORM_NOTIFY` is set: invoke it with the PR URL (tests mock this)
- Else: try macOS `osascript` display notification
- If notify/osascript fails or is missing: print `inchworm: notify fallback — logged PR URL`
- Ping on the successful draft-PR path only — **not** on implement failure / no-PR paths
- Ping even when the fixer failed, including when its work could not be pushed — but never word it as if the remote were updated

## Hard stops (non-goals)

- No inchworm-lite reviewer
- No infinite review↔fix loops (exactly one Standard review; at most one fix)
- No auto-ready / merge
- No second pick after implement failure (stamp already burned)

## Agent safety

Never pass `--yolo`, `--force`, or `--trust` to implementer, reviewer, or fixer agents.
