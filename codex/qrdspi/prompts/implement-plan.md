# QRDSPI Implement Plan Stage

Use the local skill `implement-plan`.

## Objective

Execute exactly one approved implementation phase and update the existing plan artifact in place.

## Artifact Contract

- Load the approved plan artifact first, then any supporting design, structure, or research artifacts needed for the selected phase.
- Update `{{ArtifactRoot}}/plan--{{TopicSlug}}.md` in place.
- Keep execution scoped to the next incomplete approved phase unless the runner explicitly selected another approved phase whose dependencies are complete.

## Completion Signal

This stage is complete only when the updated plan artifact records one execution checkpoint for the selected phase, including:

- phase execution status
- automated verification run
- review and simplification notes
- manual verification result
- blockers or follow-up notes

## When To Stop

- Stop after one phase checkpoint.
- If the phase is blocked, incomplete, or waiting on manual work, record that state in the plan artifact and stop.
- Do not start the next phase in the same invocation.

## Runner Variables

```text
ProjectRoot: {{ProjectRoot}}
ProjectKey: {{ProjectKey}}
ArtifactRoot: {{ArtifactRoot}}
TopicSlug: {{TopicSlug}}
Stage: implement-plan
TaskPrompt: {{TaskPrompt}}
CurrentArtifact: {{CurrentArtifact}}
RelatedArtifacts: {{RelatedArtifacts}}
ResumeTarget: {{ResumeTarget}}
```
