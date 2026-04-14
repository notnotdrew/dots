# QRDSPI Runner Contract

This directory defines the tracked contract for runner-driven QRDSPI work. `bin/qrdspi` is the human-facing entrypoint for starting or resuming that workflow.

## Runner Usage

- `bin/qrdspi start "example task"`
- `bin/qrdspi resume ~/.codex/artifacts/<project-root-or-repo>/<feature>/`
- `bin/qrdspi --dry-run start "example task"`
- `bin/qrdspi --dry-run resume ~/.codex/artifacts/dots/general-human-in-the-loop-workflow/`
- `bin/qrdspi BR-60`
- `bin/qrdspi https://flatiron.atlassian.net/browse/BR-60`

Add `--once` when you want the runner to stop after a single launched stage for debugging.

When the input is a single Jira issue key or Jira `/browse/...` URL, the runner treats it as shorthand for `start` and normalizes the task prompt to the issue key.

## Current Runner Scope

The runner auto-advances from `question` through repeated `implement-plan` invocations when artifact state clearly allows it. Completed implementation phases now pass through a post-phase review gate before the runner can continue.

## Canonical Artifact Root

QRDSPI work lives outside the target repository under:

```text
~/.codex/artifacts/<project-root-or-repo>/<feature>/
```

- `<project-root-or-repo>` is the stable repository or project key.
- `<feature>` is the workflow topic slug.
- Reuse an existing artifact root for the same work item instead of migrating mid-stream.

## Persisted Artifact Files

QRDSPI persists exactly five stage artifacts:

- `question--<feature>.md`
- `research--<feature>.md`
- `design--<feature>.md`
- `structure--<feature>.md`
- `plan--<feature>.md`

Execution does not create a sixth artifact. `implement-plan` updates the existing `plan--<feature>.md` file in place.

## Stage Mapping

| Stage | Skill | Prompt Template | Primary Output | Continue Automatically When |
| --- | --- | --- | --- | --- |
| `Q` | `question-stage` | `codex/qrdspi/prompts/question.md` | `question--<feature>.md` | The question artifact contains resolved scope and research targets, so `research-codebase` is unambiguous |
| `R` | `research-codebase` | `codex/qrdspi/prompts/research.md` | `research--<feature>.md` | The research artifact is written and leaves concrete design inputs for `design-discussion` |
| `D` | `design-discussion` | `codex/qrdspi/prompts/design.md` | `design--<feature>.md` | The design artifact is updated to `Status: approved` inside the invocation |
| `S` | `structure-outline` | `codex/qrdspi/prompts/structure.md` | `structure--<feature>.md` | The structure artifact is updated to `Status: approved` inside the invocation |
| `P` | `plan-implementation` | `codex/qrdspi/prompts/plan.md` | `plan--<feature>.md` | The plan artifact is updated to `Status: approved` inside the invocation |
| `I` | `implement-plan` | `codex/qrdspi/prompts/implement-plan.md` | Updated `plan--<feature>.md` | The first phase without an execution checkpoint is the next safe target, and every earlier execution checkpoint is `Status: completed` |

## Continuation Rule

The runner continues automatically after a stage only when the artifact state makes the next stage explicit without guessing.

Continue only when all of these are true:

- the current stage wrote or updated the expected artifact
- required approvals are encoded in artifact frontmatter or body, not implied by chat history
- exactly one next stage is valid from the current artifact set
- no blocker, unresolved human question, or ambiguous artifact state remains

If any of those conditions fail, the runner stops and reports why.

## Approval Rule

Approval-gated stages handle approval inside the launched Codex invocation, not between runner steps.

- Human-gated stages start with an inline checkpoint conversation. They do not prewrite the stage artifact before the first human response.
- Once a checkpoint is reviewed, the stage updates the artifact to match the reviewed state and continues section by section.
- `design-discussion` sets the design artifact to `Status: approved` when the human approves the design in-session
- `structure-outline` sets the structure artifact to `Status: approved` when the human approves the phase structure in-session
- `plan-implementation` sets the plan artifact to `Status: approved` when the human approves the plan in-session

If the human has not approved yet, the stage leaves the artifact in a non-approved state and the runner stops there.

When multiple artifacts exist, the runner trusts the furthest approved stage instead of replaying earlier stages. An approved `plan--<feature>.md` therefore becomes the handoff into execution even if an upstream artifact still has stale frontmatter.

## Execution Rule

`implement-plan` is still one approved phase per invocation.

- It starts from an approved local plan artifact.
- It updates the existing plan artifact in place.
- It preserves that plan artifact's frontmatter `Status: approved` while appending one phase checkpoint at a time.
- It records `Execution Status`, `Automated Verification`, `Review And Simplification`, `Manual Verification Result`, and `Blockers Or Follow-Up Notes` under the executed phase.
- Inside `Execution Status`, `Status: completed` is the only execution state that lets the runner consider the next phase.
- `Status: blocked` and `Status: waiting-for-manual-verification` both stop the runner.
- It stops after one phase checkpoint instead of rolling directly into the next phase inside the same invocation.

## Post-Phase Review Gate

When `implement-plan` completes a phase, the runner pauses before continuing.

- The runner prints the current `git status --short --untracked-files=all` output and `git diff --no-ext-diff --submodule=diff`.
- `1. Approve` launches Codex with the local `writing-git-commits` skill so the reviewed phase can be committed.
- `2. Request changes` launches Codex back into the repository so the human can request follow-up edits, then returns to the diff review loop.
- This review loop does not create a sixth QRDSPI stage or a new artifact. It is runner-controlled flow around execution.

## Prompt Template Contract

Each prompt template in `codex/qrdspi/prompts/` is intentionally thin. The template names the stage-specific caveats, and the runner appends a small QRDSPI contract instead of restating the whole workflow.

The runner-owned contract should provide:

- `SkillInvocation`
- `ArtifactRoot`
- `OutputArtifact`
- either `TaskPrompt` for `question` or `InputArtifact` for later stages
- the stop rule: stop when the stage still needs human input or approval, or when the output artifact remains unresolved
- the no-chaining rule: do not advance to the next stage inside the same invocation

For `research`, `design`, `structure`, and `plan`, the primary handoff is the previous stage artifact. The skill should discover sibling artifacts from the same artifact root when it needs more context rather than receiving the whole artifact set inline.
`question` is the exception because it starts from the task prompt, and `implement-plan` is the exception because it executes directly from the approved plan artifact.

## Stop Conditions

Stop the runner when:

- a stage is still waiting on human answers, corrections, or approval
- artifact status is missing, non-approved where approval is required, or otherwise ambiguous
- the expected artifact file was not created or updated
- more than one next stage could apply
- execution records a blocker, unresolved manual verification, or any execution checkpoint whose `Status:` is not `completed`

This contract keeps orchestration deterministic and keeps human judgment inside stage invocations.
