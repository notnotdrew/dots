# QRDSPI Design Stage

Use the local skill `design-discussion`.

## Objective

Turn the approved research into a concise design artifact that the human can review inside this invocation.

## Artifact Contract

- Load the current question and research artifacts before writing.
- Create or update `{{ArtifactRoot}}/design--{{TopicSlug}}.md`.
- Keep the artifact concise enough for section-by-section review in one sitting.

## Completion Signal

This stage is ready for runner continuation only when:

- the design artifact reflects the current discussion, and
- the human approves it inside this invocation, and
- the artifact frontmatter is updated to `Status: approved`

## When To Stop

- Stop after each correction until the human approves or leaves the design unresolved.
- If the design is approved in-session, update the artifact to `Status: approved`, state that it is ready for `$structure-outline`, and stop.
- If approval is still pending, leave the artifact in a non-approved state and stop.
- Do not expand into the structure stage in this invocation.

## Runner Variables

```text
ProjectRoot: {{ProjectRoot}}
ProjectKey: {{ProjectKey}}
ArtifactRoot: {{ArtifactRoot}}
TopicSlug: {{TopicSlug}}
Stage: design
TaskPrompt: {{TaskPrompt}}
CurrentArtifact: {{CurrentArtifact}}
RelatedArtifacts: {{RelatedArtifacts}}
ResumeTarget: {{ResumeTarget}}
```
