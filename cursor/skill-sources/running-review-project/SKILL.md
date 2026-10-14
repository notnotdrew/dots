---
name: running-review-project
description: "Runs a Cursor Project that Standard-reviews pull requests for the one repository that project is attached to. Use when starting that project, or when its weekday timer wakes."
---

# Running a review project

This project reviews pull requests for its own workspace repository. It calls the `pr-review` skill for each Standard review. It does not contain a second review procedure.

## Quick Start

On the first run, arm one weekday timer for the one repository this project is attached to. On each tick, search GitHub for `review-requested:@me` in that repository, then follow `pr-review` in Standard mode for each match whose head is not already reviewed. Keep one action-items document in this project's Context.

## Repository

List the repositories in this project's workspace, one per line, and pass them to [scripts/require-one-repo](scripts/require-one-repo). Use the `owner/repo` it prints. If it exits non-zero, stop. Do not watch any other repository, and do not substitute a repository named only in chat.

## Listen

Repo-scoped GitHub subscriptions are not enabled.

Do not call `subscribe_github_pr` with `scope: repo`.

Arm one `subscribe_timer` named `review-requested`.

Pass cron `0 7-16 * * 1-5` and timezone `America/Denver` when the tool accepts a timezone.

When it does not, pass cron `0 13-22 * * 1-5`.

That schedule is hourly from 07:00 through 16:00 America/Denver on weekdays, so East Coast requests are reviewed before the afternoon there. The fallback cron is those same hours during daylight saving time, when Denver is UTC−6. Do not arm a second timer. Re-subscribing the same timer name does not change it; unsubscribe first.

When a tick starts a fresh conversation, the timer prompt is this skill's repository, search, and review procedure. Otherwise the same conversation wakes and follows this skill.

## On a tick

1. Search with GitHub MCP for `is:open review-requested:@me repo:OWNER/REPO`, using the repository from above. An empty result ends the tick.
2. For each returned pull request number, print the full list one number per line and pipe it to [scripts/confirm-review-request](scripts/confirm-review-request) with that number. If the script exits non-zero, skip that pull request.
3. Follow the `pr-review` skill for a Standard review of that pull request. Do not invoke the `pr-review` shell command. Do not select Deep.
4. Do not push commits.
5. Do not submit or publish the GitHub review.
6. The pending review `pr-review` drafts stays unpublished.
7. If `pr-review` reports that this head is already reviewed, leave it. Do not record another action item. Continue with the next pull request from this tick.
8. If `pr-review` drafted or extended an unpublished pending review, pass this project's Context directory and the pull request URL to [scripts/record-pending-review](scripts/record-pending-review). The Context directory is `$CURSOR_AGENT_STORE_FILES_DIR` when that variable is set.

Resolve the scripts from this skill directory.

## Action items

`record-pending-review` keeps a single `action-items.md` in the Project Context directory. Each unpublished pending review is one line, and that line is the pull request URL. The review series stays under `pr-reviews/` in the layout `pr-review` uses. The action-items file is not part of that series.

## Examples

Workspace repositories:

```text
github.com/acme/widgets
```

`require-one-repo` prints `acme/widgets`. The project arms `review-requested` for that repository only.

A tick's search returns pull requests 7 and 9. `confirm-review-request` exits 0 for each, and the project runs `pr-review` for both. After the review of `https://github.com/acme/widgets/pull/7` drafts a pending review, `action-items.md` contains that URL once.

A later tick still lists pull request 7, and `pr-review` reports that head is already reviewed. The project does not record another action item. Pull request 9 is still reviewed when its head is new.

## Guidelines

- One project watches one repository.
- Confirm the review request with GitHub MCP before calling `pr-review`.
- Leave the GitHub review unpublished.
- Do not push commits to the pull request.
