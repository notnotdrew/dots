# QRDSPI Research Stage

Use the local skill `research-codebase`.

## Objective

Document the current codebase state for the scoped work item without proposing changes yet.

## Artifact Contract

- Load the resolved question artifact first when it exists.
- Create or update `{{ArtifactRoot}}/research--{{TopicSlug}}.md`.
- Keep the artifact factual and end with concrete design inputs for `design-discussion`.

## Completion Signal

This stage is complete only when the research artifact records:

- the research question or scoped goal
- the resolved scope decisions that shaped the investigation
- concrete findings with file references where needed
- design inputs and any open questions the codebase could not answer

## When To Stop

- Stop after the research artifact is updated.
- Do not draft design or implementation changes in this invocation.
- If evidence is missing, record that gap explicitly and stop instead of guessing.

## Runner Variables

```text
ProjectRoot: {{ProjectRoot}}
ProjectKey: {{ProjectKey}}
ArtifactRoot: {{ArtifactRoot}}
TopicSlug: {{TopicSlug}}
Stage: research
TaskPrompt: {{TaskPrompt}}
CurrentArtifact: {{CurrentArtifact}}
RelatedArtifacts: {{RelatedArtifacts}}
ResumeTarget: {{ResumeTarget}}
```
