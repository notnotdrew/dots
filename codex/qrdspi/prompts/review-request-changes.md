# QRDSPI Post-Phase Change Request

Stay within the current QRDSPI implementation review loop.

## Objective

Let the human request follow-up changes to the just-implemented phase before it is committed.

## Instructions

- Start by stating that this is the post-phase review session, then ask the human what should change.
- After the human gives review feedback, implement those changes in this invocation.
- Keep the work scoped to the just-reviewed phase unless the human explicitly expands scope.
- Do not create a commit in this session.
- When the requested changes are complete, stop so the runner can show the updated diff again.

## Runner Variables

```text
ProjectRoot: {{ProjectRoot}}
ProjectKey: {{ProjectKey}}
ArtifactRoot: {{ArtifactRoot}}
TopicSlug: {{TopicSlug}}
TaskPrompt: {{TaskPrompt}}
PlanArtifact: {{PlanArtifact}}
ReviewAction: request-changes
ResumeTarget: {{ResumeTarget}}
```
