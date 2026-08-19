# Review → fix → ping boundary

After a successful draft PR (`gh pr create --draft`, `active_draft_pr` set, find `in_pr`), the coordinator continues:

1. **Review** — full Standard `pr-review` once (see [reviewer-prompt](reviewer-prompt.md))
2. **Map blocking** — Class: blocking + Disposition: verified only
3. **Fix** — one fixer pass if blockers exist; otherwise skip (see [fixer-prompt](fixer-prompt.md))
4. **Ping** — notify immediately with the PR URL (even if fix failed / residual blockers)
5. **Cleanup** — remove the implement worktree under `.inchworm/worktrees/` (keep `inchworm/*` branch)

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

## Hard stops (non-goals)

- No inchworm-lite reviewer
- No infinite review↔fix loops (exactly one Standard review; at most one fix)
- No auto-ready / merge
- No second pick after implement failure (stamp already burned)

## Agent safety

Never pass `--yolo`, `--force`, or `--trust` to implementer, reviewer, or fixer agents.
