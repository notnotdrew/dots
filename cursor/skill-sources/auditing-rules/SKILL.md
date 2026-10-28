---
name: auditing-rules
description: "Audits the invoked repository's agent rules against recent pull request reviews and reports gaps, stale rules, inconsistencies, redundancies, and unenforced rules. Use when the user asks for a rule audit, to check rules against reviews, or invokes auditing-rules. Do not use to write or edit rules."
disable-model-invocation: true
---

# Auditing rules

Read recent human pull request reviews in the repository where this skill is invoked. Compare them with that repo's agent instructions. Report findings. Stop.

Do not create or edit rules, `AGENTS.md`, skills, or pull requests. Do not post comments. Do not start `pr-review`, `refactoring-agent-instructions`, or `context-checkup`.

## Quick Start

Run when the user asks for a rule audit or names this skill. An ordinary code review does not trigger it.

1. Resolve the git root and the GitHub repo.
2. Read the repo's agent instructions.
3. Collect human review comments from the last 30 merged pull requests, unless the user names a window.
4. Judge which comments would still matter on a later pull request.
5. Report findings in the conversation.

## Instructions

### Corpus

Read these files in the invoked repo before classifying anything:

- `.cursor/rules/**/*.mdc`
- `AGENTS.md`, `CLAUDE.md`, `COPILOT.md`, and `.cursorrules`, at the root and nested
- `.github/copilot-instructions.md` when it exists

Search those files for a claim before calling it a gap. If the repo has none of these files, say so. Durable comments are then gaps.

A preference only one person keeps stating can be a personal-rule candidate. Label it that way. Do not suggest it as a repo rule unless the comment states a constraint the team would want enforced.

Leave `~/.cursor/skills` and user rules out of the corpus unless the user asks. When a comment is already the job of a skill you have loaded, name that skill on the finding.

### Window

Default window: the 30 most recently merged pull requests.

```bash
gh repo view --json nameWithOwner,url
gh pr list --state merged --limit 30 --json number,title,url,mergedAt,author
```

Use `gh pr list` for recency. Search order is a poor substitute.

If the user gives a count, a date range, or an author, use that instead.

If that window holds fewer than about 10 human review comments, say the sample is thin and add open pull requests that already have human reviews (`gh pr list --state open --limit 30`).

### Collect

For each pull request in the window, load review bodies, issue comments, and inline threads. Paginate every connection whose `pageInfo.hasNextPage` is true. Keep the comment URL, author, body, and whether the thread is resolved or outdated.

```bash
gh api graphql -f owner='OWNER' -f name='REPO' -F number=NUM -f query='
query($owner: String!, $name: String!, $number: Int!, $threadCursor: String, $reviewCursor: String, $commentCursor: String) {
  repository(owner: $owner, name: $name) {
    pullRequest(number: $number) {
      number
      url
      reviews(first: 20, after: $reviewCursor) {
        pageInfo { hasNextPage endCursor }
        nodes { author { __typename login } body state url }
      }
      comments(first: 50, after: $commentCursor) {
        pageInfo { hasNextPage endCursor }
        nodes { author { __typename login } body url createdAt }
      }
      reviewThreads(first: 50, after: $threadCursor) {
        pageInfo { hasNextPage endCursor }
        nodes {
          isResolved
          isOutdated
          comments(first: 30) {
            nodes { author { __typename login } body url createdAt }
          }
        }
      }
    }
  }
}'
```

Batch several pull requests in one query with aliases when that stays readable. When a connection has `hasNextPage`, run it again with that `endCursor`. Omit the cursors on the first page.

Skip `Bot` authors. Keep a bot point only when a human restates it or agrees in a sentence. A reaction is not agreement.

Skip empty review bodies and deployment or CI chatter.

If `gh` cannot read the repo, stop and say so. Do not invent findings.

### Judge

A comment can be a rule. It depends on the context. It usually is not. Do not drop a comment only because it appears once.

Keep it when a later pull request could violate the same constraint. That includes an invariant, a boundary, a structure or naming rule, and a standing "we do not do this." Recurrence makes this more certain. One comment is enough when the comment itself states that kind of constraint.

Leave it out when you are confident it is local to this diff: a typo, a wrong value, a missed case on these lines. If you are unsure, keep it as `possible`. Unsure stays in the report.

Read the whole thread. Author pushback is context. When the thread settles against the general claim, the suggestion is `leave`, and the finding says why. A dispute about the local fix can leave the general claim standing.

Match each kept comment to the corpus:

| Type | When | Suggestion |
| --- | --- | --- |
| `gap` | Nothing in the corpus covers it | `add` |
| `unenforced` | A rule covers it, and reviews still catch violations | `update` or `narrow` |
| `stale` | The rule and the reviews disagree, or the rule names code that is gone | `update` or `drop` |
| `inconsistent` | Two instructions conflict, and reviews show which one people enforce | `update` the one reviews do not follow |
| `redundant` | Two instructions say the same thing, or a linter or test already enforces it and reviews never mention it | `drop` or merge |
| `possible` | One comment, and it is unclear whether it generalizes | Hold. Say what would make it a rule |

Confidence:

- `high`: several pull requests, or one comment that plainly states a durable rule and the thread accepted that claim
- `medium`: one plain durable comment, and acceptance is unclear
- `low`: `possible` only

Rank `high`, then `medium`, then `possible`. A clear single-comment rule outranks a repeated nit a linter already owns.

When the suggestion is `add`, say whether the rule should be always-on or limited to a path. Prefer a path limit when the constraint is about one area. Prefer always-on when reviews show it across the repo. One clause. Do not measure tokens.

The suggestion is one sentence of intent. Do not draft rule text, frontmatter, or a file.

The claim is your sentence. The quote is theirs. Keep the quote to a sentence or two.

### Report

Reply in the conversation. Do not write a file unless the user asks.

Header: repo, pull-request count, date span, instruction-file count, human comments read, and how many you judged local to one diff.

Each finding:

- type and confidence
- one-sentence claim
- suggestion, one sentence
- evidence: pull request link, comment URL, author, short quote
- existing rule path, or `none`
- `personal` when it is a personal-rule candidate

Put `possible` after the other findings. Each one still has the quote and one line on why it might be local and why it might not.

After the findings, one line if the sample was thin. Stop.

## Examples

**Input:** "Rule audit."

**Finding:**

```text
gap · high
Presenters keep calling the write alias directly.

Add a path-scoped rule for app/presenters: reads go through the read alias.

Evidence: https://github.com/org/repo/pull/418 and https://github.com/org/repo/pull/441
https://github.com/org/repo/pull/441#discussion_r1 @drew: "Presenters don't write. The write alias is for the sync job."
Existing rule: none
```

**One comment that still counts:**

```text
gap · medium
Import jobs should skip unmapped events at sync time.

Add a path-scoped rule for the CRM import jobs. One comment, and it states the boundary.

Evidence: https://github.com/org/repo/pull/902#discussion_r2 @drew: "Skip unmapped events at sync time. Guarding at enqueue is how the last two jobs got complicated."
Existing rule: none
```

**Unsure:**

```text
possible · low
#880 asks whether Public ID belongs on the user export.

Hold. It might be a standing export rule, and it might be this customer's spreadsheet. The thread never says which.

Evidence: https://github.com/org/repo/pull/880#discussion_r3 @drew: "The current export does not include Public ID. I added it because it's useful if you want to bulk update Email."
Existing rule: none
```

## Guidelines

- Report findings. Writing a rule is a separate request.
- Quote the review.
- Keep a single comment when its context says a later pull request could violate the same constraint.
- Leave a comment out only when you are confident it is local to that diff.
