---
name: annotate-diff
description: >-
  Opens Plannotator code review for a named diff (this branch, unstaged,
  staged, uncommitted, last commit, vs a base, or a PR URL). Use when the user
  says annotate this branch, annotate unstaged, annotate staged, annotate the
  diff, review this branch in plannotator, or similarly names a VCS diff to
  mark up.
---

# Annotate a diff

When the user says **annotate \<diff\>**, launch Plannotator yourself. Do not
paste a command for them to run. Diffs go through `plannotator review`, never
`plannotator annotate` (that is files/URLs/pages). Never run bare `plannotator`.

Run from the repo they mean (workspace root unless they named another checkout).

## Map the identifier

Default when they say "annotate", "this branch", "the branch", "this PR-shaped
diff", or "the diff" with no narrower scope:

```bash
plannotator review
```

That is merge-base of trunk vs the working tree, including untracked files.

| They say | Run |
| --- | --- |
| unstaged | `plannotator review --diff-type unstaged` |
| staged | `plannotator review --diff-type staged` |
| uncommitted, working tree, local changes | `plannotator review --diff-type uncommitted` |
| last commit, HEAD | `plannotator review --diff-type last-commit` |
| since base | `plannotator review --diff-type since-base` |
| merge-base | `plannotator review --diff-type merge-base` |
| vs remote, local vs remote | `plannotator review --diff-type local-vs-remote` |
| all | `plannotator review --diff-type all` |
| vs \<ref\>, compared to \<ref\>, stacked on \<ref\> | `plannotator review --base <ref>` |
| a GitHub/GitLab PR/MR URL | `plannotator review <URL>` |
| a `.diff` / `.patch` file | `plannotator review --patch-file <path>` |

Combine `--base` and `--diff-type` when they name both. Pass `--git` only if VCS
detection is wrong. Add `--json` only if you need a structured `decision`.

`--base` and `--diff-type` are git-only and session-only (the UI can still
change them). They error on jj, GitButler, Perforce, multi-repo workspace
reviews, and PR URLs.

If a review session for this repo is already live (`plannotator sessions`),
reopen it (`plannotator sessions --open`) instead of starting a second one.

## Launch and wait

The command opens a browser and **blocks until they approve, annotate, or
close**. Use a long (or no) timeout, or background it and wait on stdout. Do
not kill the process to finish. A session that ends without a decision is no
feedback.

If the tab does not appear, tell them the URL from `plannotator sessions`.

## After it exits

Classify by outcome, not by guessing from UI HTML:

- Feedback or annotations → address them in this conversation.
- Approval / LGTM, including approval with notes → notes are guidance, not a
  blocking change request. Acknowledge and continue.
- Empty / dismissed → say the session closed and stop.

For `--json`, trust `decision` (`approved` \| `annotated` \| `dismissed`), not
the `message` text.
