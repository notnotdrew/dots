---
name: building-it
description: >-
  Builds one draft pull request from a prompt, then runs an isolated
  antagonistic test review, a pare, and two simplify passes, and folds that
  cleanup into history with a force-push. Use when the user says "build it",
  invokes /building-it, or asks to plan a change and ship it through that
  cleanup.
disable-model-invocation: true
---

# Building it

You are the coordinator. You do not plan, implement, review, pare, simplify, or edit history.

The user's message after the invocation is the prompt. If there is no prompt, ask for it once and stop.

Each step is one fresh general-purpose subagent. Never resume one. Run the steps in order, and wait for each to finish. If a step fails or returns a question, stop and relay it.

The handoff is the whole instruction. Name the skill, the one artifact for that step, and the limit below. Do not open the plan or the diff, and do not paste the skill body, a previous subagent's reasoning, rejected alternatives, review notes, or your judgment about the code. Steps 3 through 6 return only whether the worktree changed.

Skills that launch their own subagents keep that inner sequence. Do not flatten it into this list, and do not tell a skill to skip, reorder, or rewrite its own subagents.

Before step 1, note paths that are already dirty. Every subagent leaves those paths, and `plan.md`, untouched and uncommitted.

## Steps

1. **Plan.** Follow `writing-simple-plans` on the user's prompt. Do not implement. Return the plan path. If that skill needs a load-bearing fact, return the question and stop.

2. **Draft PR.** Follow `executing-draft-pr-plans` on that plan path, through verify and `--force-with-lease`. Do not wait for user review. Return the PR URL, branch, base, commit list, and checkout path. Leave `plan.md` untracked.

3. **Attack tests.** In that checkout, follow `reviewing-tests-antagonistically` on the new and changed examples on that branch. Leave edits unstaged. Do not commit or push.

4. **Pare.** In that checkout, follow `paring-code` on the branch diff, including uncommitted edits. Leave edits unstaged. Do not commit or push.

5. **Simplify.** In that checkout, follow `simplify-code` on the branch diff, including uncommitted edits. Leave edits unstaged. Do not commit or push.

6. **Simplify again.** A new subagent with the same handoff as step 5, and nothing about what step 5 decided.

7. **Fold.** Follow "Fold review fixes into history" in `executing-draft-pr-plans` for the uncommitted cleanup only. Put each change in the commit that introduced the behavior it edits. Do not add a trailing cleanup commit. Re-verify, then force-push that feature branch with `--force-with-lease`. Never force-push `main` or `master`. Update the draft PR title or description if its meaning changed. Do not wait for user review. If the only uncommitted paths are `plan.md` and the pre-existing dirty files, do not rewrite history or push. Return the PR URL and commit list.

## Done

Reply with the PR link and the commit list. Then wait for the user.

## Example

**Input:** `/building-it` stop the billing page from showing the old plan for a minute after upgrade

**Output:** A draft PR whose commits follow the plan. If the cleanup edits changed code, those edits are inside the commits they belong to, and the feature branch is force-pushed with lease. The reply is the PR link and the commit list.
