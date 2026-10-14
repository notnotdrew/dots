---
name: running-review-project
description: "Runs a Cursor Project that Standard-reviews pull requests for the one repository that project is attached to. Use when starting that project, or when it wakes for a pull request opened or pushed."
---

# Running a review project

This project reviews pull requests for its own workspace repository. It calls the `pr-review` skill for each Standard review. It does not contain a second review procedure.

## Quick Start

On the first run, subscribe to pull request opened and pull request pushed for the one repository this project is attached to. On each of those events, confirm `review-requested:@me` with GitHub MCP, then follow `pr-review` in Standard mode. Keep one action-items document in this project's Context.

## Repository

List the repositories in this project's workspace, one per line, and pass them to [scripts/require-one-repo](scripts/require-one-repo). Use the `owner/repo` it prints. If it exits non-zero, stop. Do not watch any other repository, and do not substitute a repository named only in chat.

## Listen

Subscribe to pull request opened and pull request pushed for that repository.

Do not add a timer, a cron schedule, or a search that runs on its own.

A review request that does not open or update the pull request waits until one of those two events.

## On an event

1. Take the pull request number and URL from the event.
2. Search with GitHub MCP for `is:open review-requested:@me repo:OWNER/REPO`, using the repository from the step above. Print each returned pull request number, one per line, and pipe that list to [scripts/confirm-review-request](scripts/confirm-review-request) with the event's pull request number. If the script exits non-zero, stop. Do not review that pull request.
3. Follow the `pr-review` skill for a Standard review of that pull request. Do not invoke the `pr-review` shell command. Do not select Deep.
4. Do not push commits.
5. Do not submit or publish the GitHub review.
6. The pending review `pr-review` drafts stays unpublished.
7. If `pr-review` reports that this head is already reviewed, stop. Do not record another action item.
8. If `pr-review` drafted or extended an unpublished pending review, pass this project's Context directory and the pull request URL to [scripts/record-pending-review](scripts/record-pending-review). The Context directory is `$CURSOR_AGENT_STORE_FILES_DIR` when that variable is set.

Resolve the scripts from this skill directory.

## Action items

`record-pending-review` keeps a single `action-items.md` in the Project Context directory. Each unpublished pending review is one line, and that line is the pull request URL. The review series stays under `pr-reviews/` in the layout `pr-review` uses. The action-items file is not part of that series.

## Examples

Workspace repositories:

```text
github.com/acme/widgets
```

`require-one-repo` prints `acme/widgets`. The project subscribes to pull request opened and pull request pushed on `acme/widgets` only.

GitHub MCP returns pull requests 7 and 9 for `review-requested:@me` in `acme/widgets`. The event is pull request 7, so `confirm-review-request` exits 0 and the project runs `pr-review` for `https://github.com/acme/widgets/pull/7`. After that review drafts a pending review, `action-items.md` contains that URL once.

The same head is pushed again and `pr-review` reports it is already reviewed. The project stops. The action-items file is unchanged.

## Guidelines

- One project watches one repository.
- Confirm the review request with GitHub MCP before calling `pr-review`.
- Leave the GitHub review unpublished.
- Do not push commits to the pull request.
