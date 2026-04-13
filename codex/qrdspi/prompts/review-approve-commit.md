# QRDSPI Post-Phase Approval

Use the local skill `writing-git-commits`.

## Objective

Turn the currently reviewed QRDSPI phase changes into one Git commit.

## Instructions

- Inspect the current repository state with `git status --short`, `git diff`, and `git diff --cached` before deciding on the commit.
- Follow any project-specific commit template or convention if one exists. Otherwise use Tim Pope style.
- Stage the files that belong to the just-reviewed QRDSPI phase.
- Create one non-interactive commit for those reviewed changes.
- Do not make additional implementation changes unless a tiny commit-readiness fix is required to complete the commit safely.
- If the diff is ambiguous or nothing is ready to commit, stop and explain the blocker instead of guessing.

## Runner Variables

```text
ProjectRoot: {{ProjectRoot}}
ProjectKey: {{ProjectKey}}
ArtifactRoot: {{ArtifactRoot}}
TopicSlug: {{TopicSlug}}
TaskPrompt: {{TaskPrompt}}
PlanArtifact: {{PlanArtifact}}
ReviewAction: approve
ResumeTarget: {{ResumeTarget}}
```
