---
name: pr-review
description: "Reviews GitHub pull requests using the PERFECT code review methodology: Purpose, Edge Cases, Reliability, Form, Evidence, Clarity, Taste. Use when reviewing a PR by number or URL, or when the user asks for a structured pull request review."
---

# PR Review

Review GitHub pull requests with full-file context and the PERFECT methodology.

## Use

```text
$pr-review 42
$pr-review https://github.com/org/repo/pull/42
```

Requires `git`, `gh`, and GitHub auth.

Resolve these paths relative to this skill:
- `scripts/gh-pr-parse`
- `scripts/pr-review-worktree`
- `references/language-skill-mapping.md`
- `references/perfect-principles.md`

Use the parser script instead of heuristically parsing PR URLs.

## Workflow

1. Gather PR data in an isolated worktree.

```bash
PR_REVIEW_WORKTREE="<absolute path to scripts/pr-review-worktree>"

eval "$("$PR_REVIEW_WORKTREE" setup "<PR-ID-or-URL>")"

REPO_FLAG=""
if [ -n "${OWNER:-}" ] && [ -n "${REPO:-}" ]; then
  REPO_FLAG="--repo ${OWNER}/${REPO}"
fi

gh pr view "$PR_NUMBER" $REPO_FLAG \
  --json title,body,files,additions,deletions,baseRefName,headRefName,url,state,reviewDecision,author
gh pr diff "$PR_NUMBER" $REPO_FLAG
gh pr checks "$PR_NUMBER" $REPO_FLAG
gh pr view "$PR_NUMBER" $REPO_FLAG --json files --jq '.files[].path'
```

Stop immediately if setup, network access, or `gh` access fails.

2. Read every changed source file from `$REVIEW_DIR/<path>` in full.
- Use the diff to focus attention, not as the only context.
- Skip generated files, lockfiles, binaries, and prose-only files unless asked.
- If no source files changed, say no code review applies and stop.

3. Load only the relevant local stack skills from `references/language-skill-mapping.md`.
- If no local skill matches a changed language, continue and note the limitation.

4. Apply PERFECT in strict order using `references/perfect-principles.md`.
- Purpose
- Edge Cases
- Reliability
- Form
- Evidence
- Clarity
- Taste

Earlier failures outweigh later ones.

5. Report concrete findings only.
- Explain what is wrong, why it matters, and the fix direction.
- Use line references whenever possible.
- Do not block on taste.
- If CI or local verification cannot be checked, say so.

Use this structure:

```markdown
# PERFECT Review: PR #<ID> - <title>

**PR**: <url>
**Author**: <author>
**Base**: <base> <- <head>
**Files changed**: <count> (+<additions> -<deletions>)

## 1. Purpose
**Verdict**: PASS | FAIL | NEEDS DISCUSSION

### Findings
- **[file:line]**: <problem, impact, fix direction>

## 2-6. Edge Cases / Reliability / Form / Evidence / Clarity
**Verdict**: PASS | CONCERN | FAIL

### Findings
- **[file:line]**: <scenario or risk, impact, fix direction>

## 7. Taste
**Verdict**: N/A

### Suggestions
- **[file:line]**: <non-blocking preference with reasoning>

## Summary

**Recommendation**: APPROVE | REQUEST CHANGES | NEEDS DISCUSSION
```

6. Clean up the worktree.

```bash
"$PR_REVIEW_WORKTREE" cleanup "$REVIEW_DIR"
```

## Boundaries

- Review code, not the author.
- Focus on the changed code and the context needed to judge it.
- Do not invent requirements or expand into unrelated refactors.
- Skip documentation review unless the user asks for it.
