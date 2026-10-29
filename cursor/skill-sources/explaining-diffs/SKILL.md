---
name: explaining-diffs
description: >-
  Explains a pull request, commit, branch, working tree, or pasted diff in
  plain language for someone who has only seen the project in small doses.
  Use when the user asks to explain a PR, explain this diff, catch them up
  on a change, or invokes explaining-diffs.
disable-model-invocation: true
---

# Explaining diffs

> explain to me what is going on in this PR in simple terms. Don't invent weird language, but also don't assume I have much context about this project. I've only seen it in small doses.

That standard holds for a commit, a branch, the working tree, or a pasted patch. "This PR" means whatever diff they named.

## Quick Start

Read the diff they named. Define a project word the first time it matters. Stop when they could tell someone what changed.

## What to read

Use the diff they named. If they did not name one, use the PR, branch, or patch already in this conversation.

| They point at | Read |
| --- | --- |
| A GitHub PR URL or number | `gh pr view` for the title and body, `gh pr diff` for the patch |
| This branch | `git diff "$(git merge-base HEAD origin/HEAD)"...HEAD` |
| Unstaged | `git diff` |
| Staged | `git diff --cached` |
| Uncommitted, or what I'm working on | `git diff HEAD`, and untracked files they name |
| Last commit | `git show` |
| A commit, range, or ref | `git show` or `git diff` for that range |
| A pasted diff or a patch file | That text |
| Particular files | The diff for those files only |

If `origin/HEAD` is missing, use `origin/main` or `origin/master`.

Read the PR body when there is one. It often says why. Open a file only to learn what a name refers to. Do not tour the repo.

The explanation stays in chat. Do not post it, review the change, suggest a fix, or write a PR description or a commit message.

## How to say it

Lead with what the change does, in one or two sentences they could repeat.

Then the few pieces that matter. When the diff is doing more than one thing, one short paragraph each. Say what changes for a person using the product, or for the system when no person is in the path.

Use names that already appear in the diff or the PR. The first time one matters, translate it.

Name a file or function when it is the thing that changed. Skip the rest.

A small diff is a short paragraph or two. A large diff is a map of the changes, not a pass through every hunk.

If the diff and the PR body do not say why, describe what the code does. Do not invent a motive. If a name is still unclear after a quick look, say so.

## Language

Say what happens, in the words you would use out loud. Skip coined labels ("the identity short-circuit"), metaphors that are not already in the code, and stacks of abstract nouns ("the emission stage of the orchestration layer") when a plain sentence will do.

Do not open by correcting a wrong idea ("this isn't a refactor"). Do not recap the architecture.

## Example

**Diff:** paying an invoice used to update the books and email the customer in one step. The patch saves the books first, then sends the email from a job that runs after that save commits.

**Weird:** "This PR decomposes the billing orchestrator into a transactional core and an asynchronous notification sidecar, so the fiscal write path is no longer coupled to the mailer."

**Plain:** "Paying an invoice used to update the books and email the customer in the same step. Now the books update first, and the email goes out as a separate job after that update is saved. If the email fails, the payment still stands."
