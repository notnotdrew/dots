---
name: pr-review
description: "Reviews GitHub pull requests using the PERFECT code review methodology: Purpose, Edge Cases, Reliability, Form, Evidence, Clarity, Taste. Use when reviewing a PR by number or URL, or when the user asks for a structured pull request review."
---

# PR Review

Review a GitHub pull request with full-file context, applying PERFECT in priority order: Purpose, Edge Cases, Reliability, Form, Evidence, Clarity, then Taste.

## Quick Start

Run the launcher from the repository containing the pull request:

```bash
pr-review 42
pr-review https://github.com/org/repo/pull/42
```

Prerequisites:
- `git`
- `gh`
- `jq`
- `wt` (WorkTrunk)
- `agent` when using the launcher
- GitHub auth configured for the target repo

Use [scripts/gh-pr-parse](scripts/gh-pr-parse) to validate and parse the reference. Resolve the helper relative to this skill directory.

## Inputs

- **PR number**: e.g. `42`
- **PR URL**: e.g. `https://github.com/org/repo/pull/42`

Both forms must be run from the target repository so WorkTrunk can create or locate the PR checkout.

## Workflow

### 1. Prepare The Checkout

Validate the input and create or select an isolated checkout of the PR head:

```bash
PR_PARSE="<absolute path to scripts/gh-pr-parse resolved from this skill>"
PR_REF="<PR-ID-or-URL>"
"$PR_PARSE" "$PR_REF" >/dev/null

case "$PR_REF" in
  *[!0-9]*) WORKTRUNK_REF="$PR_REF" ;;
  *) WORKTRUNK_REF="pr:${PR_REF}" ;;
esac

SWITCH_RESULT=$(wt switch --no-cd --format json "$WORKTRUNK_REF")
REVIEW_DIR=$(printf '%s\n' "$SWITCH_RESULT" | jq -er '.path')
WORKTRUNK_ACTION=$(printf '%s\n' "$SWITCH_RESULT" | jq -er '.action')
```

If setup fails because the environment blocks network or GitHub access, report the failure and stop.

### 2. Gather Evidence

Get the PR metadata, diff, checks, and changed paths:

```bash
gh pr view "$PR_REF" \
  --json title,body,files,additions,deletions,baseRefName,headRefName,url,state,reviewDecision,author

gh pr diff "$PR_REF"
gh pr checks "$PR_REF"
gh pr view "$PR_REF" --json files --jq '.files[].path'
```

Read each changed source file in full from `$REVIEW_DIR/<path>`. Use the diff to locate the change and the full file to understand its context and local conventions.

Skip by default:
- generated files
- lockfiles
- binary assets
- prose-only files

If the PR contains no source code files, state that no code review is applicable and stop.

### 3. Load Relevant Stack Skills

Use [language-skill-mapping.md](references/language-skill-mapping.md) to identify relevant installed skills. Load only skills that match the changed files.

If no local skill exists for a language in the PR, continue with general engineering judgment and note that limitation in the review.

### 4. Apply PERFECT In Order

Load [perfect-principles.md](references/perfect-principles.md), then evaluate all seven principles in order. Earlier failures outweigh later strengths.

```markdown
# PERFECT Review: PR #<ID> — <title>

<PR URL, author, base/head, size, and CI status>

## Findings

### 1. Purpose — PASS | FAIL | NEEDS DISCUSSION
### 2. Edge Cases — PASS | CONCERN | FAIL
### 3. Reliability — PASS | CONCERN | FAIL
### 4. Form — PASS | CONCERN | FAIL
### 5. Evidence — PASS | CONCERN | FAIL
### 6. Clarity — PASS | CONCERN
### 7. Taste — N/A

For each finding:
- **[file:line] [blocking|advisory]** — <problem, impact, and fix direction>

## Summary

**Recommendation**: APPROVE | REQUEST CHANGES | NEEDS DISCUSSION
<One short paragraph covering overall risk and any verification gaps.>
```

Omit empty finding lists, but include a verdict for every principle. Findings must be concrete, line-specific when possible, and clearly blocking or advisory. Do not invent findings to fill the structure.

### 5. Clean Up

Remove the checkout only if this skill created it. Leave pre-existing WorkTrunk checkouts alone.

```bash
if [ "$WORKTRUNK_ACTION" = "created" ]; then
  wt remove --yes --foreground "$REVIEW_DIR"
fi
```

## Guidelines

- Review code, not the author.
- Do not block on taste.
- Do not invent missing requirements.
- Focus on code changed by the PR.
- Read surrounding code when needed to evaluate correctness.
- Do not expand into unrelated refactoring requests.
- Skip documentation review unless the user asks for it.
- Prefer specific bug reports to vague discomfort.
- If CI or local execution cannot be checked, say so explicitly.
