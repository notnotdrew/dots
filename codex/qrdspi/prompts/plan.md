# QRDSPI Plan Implementation Stage

Use the local skill `plan-implementation`.

## Objective

Expand the approved structure artifact into a concrete implementation plan with explicit verification and manual checkpoints.

## Artifact Contract

- Load the approved design, approved structure artifact, and relevant research artifacts before drafting.
- Create or update `{{ArtifactRoot}}/plan--{{TopicSlug}}.md`.
- Preserve approved phase names, ordering, and non-goals.

## Completion Signal

This stage is ready for runner continuation only when:

- the plan artifact is complete enough to execute without placeholders or open questions, and
- the human approves it inside this invocation, and
- the artifact frontmatter is updated to `Status: approved`

## When To Stop

- Stop after presenting or revising the plan until the human approves it.
- If the human approves in-session, update the artifact to `Status: approved` and stop.
- If approval is still pending, leave the artifact in a non-approved state and stop.
- Do not begin implementation in this invocation.

## Runner Variables

```text
ProjectRoot: {{ProjectRoot}}
ProjectKey: {{ProjectKey}}
ArtifactRoot: {{ArtifactRoot}}
TopicSlug: {{TopicSlug}}
Stage: plan
TaskPrompt: {{TaskPrompt}}
CurrentArtifact: {{CurrentArtifact}}
RelatedArtifacts: {{RelatedArtifacts}}
ResumeTarget: {{ResumeTarget}}
```
