# QRDSPI Question Stage

Use the local skill `question-stage`.

## Objective

Turn the task prompt into a scoped QRDSPI handoff without researching the codebase yet.

## Artifact Contract

- Read any existing `question--<topic-slug>.md` artifact before asking new questions.
- Create or update `{{ArtifactRoot}}/question--{{TopicSlug}}.md`.
- Keep the artifact focused on scope decisions, boundaries, and research targets.

## Completion Signal

This stage is complete only when the artifact contains a resolved handoff for `research-codebase`, including:

- `Resolved Scope`
- `Resolved Decisions`
- `Scope Boundaries`
- `Research Targets`
- `Next Step` pointing to `$research-codebase`

## When To Stop

- If the human still needs to answer questions, stop after presenting or persisting those questions.
- If the human answers inside this invocation, update the question artifact with the resolved handoff and then stop.
- Do not research the codebase in this invocation.

## Runner Variables

```text
ProjectRoot: {{ProjectRoot}}
ProjectKey: {{ProjectKey}}
ArtifactRoot: {{ArtifactRoot}}
TopicSlug: {{TopicSlug}}
Stage: question
TaskPrompt: {{TaskPrompt}}
CurrentArtifact: {{CurrentArtifact}}
RelatedArtifacts: {{RelatedArtifacts}}
ResumeTarget: {{ResumeTarget}}
```
