---
name: triaging-honeybadger-low-hanging-fruit
description: Triages recent unresolved production Honeybadger faults into a short list of small, approachable fixes, then records the findings in a markdown triage doc inside an isolated Worktrunk worktree. Use when the user wants low-hanging fruit, quick wins, easy or beginner-friendly production bug fixes, Honeybadger error cleanup, or a warm-up task from real production errors.
---

# Triaging Honeybadger Low-Hanging Fruit

## Quick Start

Find a handful of production errors that are real, small, and safe to fix, and hand them off as a written shortlist:

1. Resolve the Honeybadger account and project.
2. Pull recent and frequent unresolved production faults.
3. Spot-check notices for the promising candidates.
4. Check each candidate against the codebase and bucket it.
5. Create a Worktrunk worktree for the findings.
6. Write `hb-low-hanging-fruit.md` in that worktree and leave it uncommitted.

Use [using-honeybadger-cli](../using-honeybadger-cli/SKILL.md) for `hb` mechanics, auth, and flag syntax. This skill covers the triage judgment, not the CLI surface.

Aim for three to five recommendations. This is a curated shortlist, not an exhaustive audit.

## Instructions

### Step 1: Resolve the project

```bash
hb accounts list --output json
hb projects list --account-id <account-id> --output json
```

Never guess a project ID. If more than one project could match, ask which one.

### Step 2: Pull the candidate set

Query twice — recency and frequency surface different candidates:

```bash
hb faults list --project-id <project-id> --query "is:unresolved environment:production" \
  --order recent --limit 25 --output json
hb faults list --project-id <project-id> --query "is:unresolved environment:production" \
  --order frequent --limit 25 --output json
```

Keep the environment filter on. Staging and development faults are not the target.

For each fault, the useful triage fields are `klass`, `message`, `notices_count`, `created_at`, `last_notice_at`, and `tags`. A fault whose `last_notice_at` is weeks old is either already fixed or no longer live traffic — note it but do not recommend coding work for it.

`hb projects reports --id <project-id> --type notices_by_class` helps when you want the error-class distribution before drilling in.

### Step 3: Spot-check notices

For each fault that looks plausible, read one or two representative occurrences:

```bash
hb faults get --project-id <project-id> --id <fault-id> --output json
hb faults notices --project-id <project-id> --id <fault-id> --limit 5 --output json
```

You are looking for the backtrace line in first-party code, the request path or job name, and the params or context that triggered it. A fault whose backtrace never enters application code is usually infrastructure or a gem, not low-hanging fruit.

### Step 4: Check against the codebase and bucket

This is the step that makes the output trustworthy. Open the file and line from the backtrace before recommending anything. Then sort each candidate into exactly one bucket:

**Worth fixing.** Fault reaches first-party code, the failure mode is obvious from the notice, and the fix is localized — a nil guard, a missing-param path, a narrowed rescue, a corrected lookup. No schema change, no new dependency, no cross-cutting refactor. One or two files.

**Already fixed.** The current code already handles this case. Confirm with `git log`/`git blame` on the guarding line and compare the fix date with `last_notice_at`. If the last notice predates the fix, the recommendation is to resolve the fault in Honeybadger, not to write code.

**Skip for now.** Infrastructure and platform errors (timeouts, connectivity, deploy-window noise), customer configuration problems, third-party delivery rejections, niche one-offs with a couple of occurrences and no pattern, and known noise or mis-tagged faults.

Record the reason for every skip. The reasons are as valuable to the reader as the recommendations.

### Step 5: Create the worktree

From the repository, create an isolated branch and worktree named `hb-<yymmdd>`:

```bash
wt switch --create hb-260803
```

Use Worktrunk, not `git worktree add` — raw worktrees bypass the project's hooks and worktree layout. Worktrunk places the worktree beside the repo as `<repo-path>.<branch>`. Confirm with `wt list` and use the absolute worktree path when writing files.

The point of the worktree is that findings never land on `develop` and the reader can pick the work up in place.

### Step 6: Write the triage doc

Write `hb-low-hanging-fruit.md` at the root of the worktree, following [references/triage-doc-template.md](references/triage-doc-template.md). If that filename already exists, use `hb-low-hanging-fruit-<yymmdd>.md`.

Leave it untracked and uncommitted unless the user asks otherwise. It is a handoff note, not a deliverable.

### Step 7: Report

Lead with the shortlist: error class, one-line description, and why it is small. Name the branch, worktree path, and artifact path. Mention the housekeeping items — already-fixed faults and noisy or mis-tagged ones — separately from the fix recommendations.

## Optional Follow-Ups

Stop at the triage doc by default. Offer these, and act only on an explicit go-ahead:

- **Resolve already-fixed faults.** Resolving or ignoring is a mutation. List the fault IDs and let the user confirm before touching them or doing it in the UI themselves.
- **Create Linear issues** for the recommended fixes, using the `linear-cli` skill or the Linear MCP conventions in the repo's rules.
- **Implement one fix** in the worktree, taking the triage doc as the input.

## Guidelines

- Honeybadger access stays read-only during triage. No resolve, ignore, comment, or bulk action without explicit approval.
- Every recommendation cites a concrete `file:line` from current code, not just the fault backtrace.
- Do not begin fixing while triaging. The output of this skill is a decision document.
- Prefer faults with recent notices and a repeating pattern over high-count faults that stopped weeks ago.
- Do not paste raw notice JSON into the doc or the response. Quote the message, the relevant param, and the backtrace line.
- If nothing qualifies, say so plainly and explain what the current fault list is dominated by instead of padding the list.

## Example

**Input:** "I'm new here — find me a few easy Honeybadger fixes to warm up on."

**Output:**

> Three candidates from ScreenSteps (project 51700), unresolved production faults over the last 30 days:
>
> - `NoMethodError` on nil `space` in `app/presenters/lesson_presenter.rb:42` — 41 notices, all from deleted-space permalinks. One guard clause.
> - `ActionController::ParameterMissing` in `app/controllers/api/v2/comments_controller.rb:18` — 12 notices, empty POST bodies from an integration. Needs a 422 instead of a 500.
> - `ArgumentError` in the CSV export job for blank date ranges — 8 notices, one validation.
>
> Housekeeping: two `ScreenSteps::HttpError` faults are already guarded as of the June 12 deploy and only need resolving in the UI; the Postmark inactive-recipient fault is customer data, not a bug.
>
> Branch and worktree `hb-260803` at `~/Documents/dev/screensteps/screensteps-live.hb-260803`, with the full triage in `hb-low-hanging-fruit.md` (untracked). Skipped items and reasons are in the doc.
