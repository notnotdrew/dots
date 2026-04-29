---
name: pr-review
description: "Reviews GitHub pull requests using the PERFECT code review methodology: Purpose, Edge Cases, Reliability, Form, Evidence, Clarity, Taste. Use when reviewing a PR by number or URL, or when the user asks for a structured pull request review."
---

# PR Review

Structured pull request review applying the PERFECT methodology in strict priority order. This skill is for reviewing GitHub PRs with full-file context, not just diff snippets.

## Quick Start

Use this skill with a PR number or GitHub PR URL:

```text
$pr-review 42
$pr-review https://github.com/org/repo/pull/42
```

Prerequisites:
- `git`
- `gh`
- GitHub auth configured for the target repo

Helper scripts live next to this skill:
- [scripts/gh-pr-parse](scripts/gh-pr-parse)
- [scripts/pr-review-worktree](scripts/pr-review-worktree)

Resolve those paths relative to this skill directory. Do not parse PR URLs heuristically when the parser script can do it deterministically.

## Inputs

- **PR ID**: e.g. `42` when already in the target repository
- **PR URL**: e.g. `https://github.com/org/repo/pull/42`

## Workflow

### 1. Gather PR Data

Use the worktree helper to create an isolated checkout of the PR head:

```bash
PR_REVIEW_WORKTREE="<absolute path to scripts/pr-review-worktree resolved from this skill>"

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

If setup fails because the environment blocks network access or `gh` access, surface that immediately instead of guessing.

### 2. Read Changed Files In Full

For each changed source file, read the full file from `$REVIEW_DIR/<path>`, not just the diff hunk. Use the diff to locate changes, then use the full file to understand context, invariants, and local conventions.

Skip:
- generated files
- lockfiles
- binary assets
- prose-only files unless the user explicitly wants them reviewed

If the PR contains no source code files, state that no code review is applicable and stop.

### 3. Load Relevant Stack Skills

Use [language-skill-mapping.md](references/language-skill-mapping.md) to map changed files to installed skills. Load only the matching local skills that exist in this environment.

These stack skills inform:
- **Form**: language and framework design norms
- **Edge Cases**: ecosystem-specific failure modes
- **Reliability**: security and performance expectations
- **Evidence**: testing tools and conventions
- **Clarity**: idiomatic naming and organization

If no local skill exists for a language in the PR, continue with general engineering judgment and note that limitation in the review.

### 4. Apply PERFECT In Order

Review the PR in this strict priority order:

1. **Purpose**
2. **Edge Cases**
3. **Reliability**
4. **Form**
5. **Evidence**
6. **Clarity**
7. **Taste**

Load [perfect-principles.md](references/perfect-principles.md) for the detailed checks and reporting expectations per principle.

Earlier failures matter more than later ones. A PR that misses the task or has correctness bugs should not be softened by style praise.

### 5. Produce The Review

Use this structure:

```markdown
# PERFECT Review: PR #<ID> — <title>

**PR**: <url>
**Author**: <author>
**Base**: <base> <- <head>
**Files changed**: <count> (+<additions> -<deletions>)

## 1. Purpose
**Verdict**: PASS | FAIL | NEEDS DISCUSSION
<task understanding, implementation summary, and requirement gaps>

### Findings
- **[file:line]**: <problem, why it matters, fix direction>

## 2. Edge Cases
**Verdict**: PASS | CONCERN | FAIL

### Findings
- **[file:line]**: <scenario, impact, handling>

## 3. Reliability
**Verdict**: PASS | CONCERN | FAIL

### Findings
- **[file:line]**: <performance or security concern>

## 4. Form
**Verdict**: PASS | CONCERN | FAIL

### Findings
- **[file:line]**: <design concern with argument and alternative>

## 5. Evidence
**Verdict**: PASS | CONCERN | FAIL
<CI status and test coverage assessment>

### Findings
- **[file:line]**: <test gap or low-value test concern>

## 6. Clarity
**Verdict**: PASS | CONCERN

### Findings
- **[file:line]**: <clarity issue and improvement>

## 7. Taste
**Verdict**: N/A

### Suggestions
- **[file:line]**: <non-blocking preference with reasoning>

## Summary

| Principle | Verdict |
|-----------|---------|
| Purpose | PASS/FAIL |
| Edge Cases | PASS/CONCERN/FAIL |
| Reliability | PASS/CONCERN/FAIL |
| Form | PASS/CONCERN/FAIL |
| Evidence | PASS/CONCERN/FAIL |
| Clarity | PASS/CONCERN |
| Taste | N/A |

**Recommendation**: APPROVE | REQUEST CHANGES | NEEDS DISCUSSION
```

Findings must be concrete. Every issue should explain:
- what is wrong
- why it matters
- what direction would fix it

### 6. Clean Up

When the review is complete, remove the worktree:

```bash
"$PR_REVIEW_WORKTREE" cleanup "$REVIEW_DIR"
```

## Guidelines

### Review Ethos

- Review code, not the author.
- Do not block on taste.
- Do not invent missing requirements.
- Do not give empty approvals such as `LGTM` without demonstrating understanding.

### Scope Boundaries

- Focus on code changed by the PR.
- Read surrounding code when needed to evaluate correctness.
- Do not expand into unrelated refactoring requests.
- Skip documentation review unless the user asks for it.

### Evidence Standards

- Prefer specific bug reports to vague discomfort.
- Use line references whenever possible.
- Distinguish blocking failures from advisory concerns.
- If CI or local execution cannot be checked, say so explicitly.

## Specialized Lenses

Combine this skill with existing local stack skills where relevant:
- `developing-typescript`
- `testing-react-with-vitest`
- `developing-bash`
- `review-code`

Use `review-code` when you need extra depth on test quality, maintainability, or severity framing inside the changed code.
