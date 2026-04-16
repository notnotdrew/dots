# Phase 5: Prune Redundant

Remove guidance that does not change behavior.

Use [references/deletion-criteria.md](../references/deletion-criteria.md). Every deletion still needs user approval.

## Procedure

1. Scan for rules that are:
   - agent defaults
   - too vague
   - overly obvious
   - duplicated by tooling or CI
   - outdated
   - aspirational
2. Present candidates with location, reason, and a delete or rewrite recommendation.
3. Apply only approved deletions or rewrites.
4. Re-verify links, root size, self-containment, and contradiction status.

## Output

- Updated files
- List of deleted, rewritten, and retained items
- Before and after line counts
