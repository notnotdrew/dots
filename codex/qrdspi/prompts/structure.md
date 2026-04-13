# QRDSPI Structure Stage

Use the local skill `structure-outline`.

## Objective

Convert the approved design into a reviewable sequence of implementation phases.

## Artifact Contract

- Load the approved design artifact before outlining phases.
- Create or update `{{ArtifactRoot}}/structure--{{TopicSlug}}.md`.
- Keep the artifact structural, not implementation-detailed.

## Completion Signal

This stage is ready for runner continuation only when:

- the structure artifact defines the approved phase sequence, and
- the human approves that phase structure inside this invocation, and
- the artifact frontmatter is updated to `Status: approved`

## When To Stop

- Stop after presenting or revising the structure artifact until the human approves it.
- If the human approves in-session, update the artifact to `Status: approved`, state that it is ready for `$implementation-plan`, and stop.
- If approval is still pending, leave the artifact in a non-approved state and stop.
- Do not expand the structure artifact into a detailed plan in this invocation.

## Runner Variables

```text
ProjectRoot: {{ProjectRoot}}
ProjectKey: {{ProjectKey}}
ArtifactRoot: {{ArtifactRoot}}
TopicSlug: {{TopicSlug}}
Stage: structure
TaskPrompt: {{TaskPrompt}}
CurrentArtifact: {{CurrentArtifact}}
RelatedArtifacts: {{RelatedArtifacts}}
ResumeTarget: {{ResumeTarget}}
```
