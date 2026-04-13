# Use Case Document Template

Use this template for the final output of `analyzing-use-cases`.

For inline responses, the markdown body is usually enough.
For persisted sidecar documents, add the optional frontmatter block and link the file from the active artifact set.

## Optional Frontmatter For Persisted Sidecar Docs

```yaml
---
Title: "Use Case: [Goal in active verb form]"
Slug: "<topic-slug>"
Project: "<project-slug>"
Created: YYYY-MM-DD
Modified: YYYY-MM-DD
Status: draft | approved
SourceInputs:
  - "<ticket, artifact path, or prompt summary>"
RelatedArtifacts:
  - "<related artifact path>"
---
```

## Template

```markdown
# Use Case: [Goal in Active Verb Form]

## Summary

| Field | Value |
| --- | --- |
| Goal Level | [☁️ Summary / 🌊 User-goal / 🐟 Subfunction] |
| Primary Actor | [Who initiates and owns the goal] |
| Scope | [System under design] |
| Trigger | [What starts the use case] |

## Stakeholders And Interests

| Stakeholder | Interest | Implied Requirement |
| --- | --- | --- |
| [Actor or team] | [What they need] | [Operational, security, compliance, or product concern] |

## Preconditions

- [Specific, verifiable precondition]
- [Specific, verifiable precondition]

## Main Success Scenario

1. The [actor] [action].
2. The system [response].
3. The [actor] [next action].
4. The system [response].

## Extensions

**2a. [Condition at step 2]:**
1. The system [response].
2. [Recovery path or "Use case ends."]

**3a. [Condition at step 3]:**
1. The system [response].
2. Use case continues at step [N].

## Postconditions

### Success Guarantees

- [Observable result]
- [Observable result]

### Minimum Guarantees

- [Invariant that must hold even on failure]
- [Invariant that must hold even on failure]

## Acceptance Criteria Coverage

| Acceptance Criterion | Covered By |
| --- | --- |
| [Criterion from source] | [Main scenario step, extension, precondition, or postcondition] |

## TDD Mapping

### From Main Scenario

| Step | Test Description |
| --- | --- |
| Step [N] | [Behavior the happy-path test should verify] |

### From Extensions

| Extension | Test Description |
| --- | --- |
| [2a] | [Behavior the edge-case test should verify] |

### From Preconditions

| Precondition | Test Description |
| --- | --- |
| [Precondition] | [Guard clause or setup verification] |

### From Postconditions

| Postcondition | Test Description |
| --- | --- |
| [Guarantee] | [Assertion or invariant test] |

## References

- Source ticket or prompt: [reference]
- Research artifact: [path, if any]
- Related artifacts: [paths, if any]
```

## Format Choice

Use a lighter casual version when the story is simple:

- keep `Summary`
- keep `Preconditions`
- keep `Main Success Scenario`
- keep `Extensions`
- keep `Success Guarantees`
- keep `Acceptance Criteria Coverage`

Use the full version when stakeholder interests, external dependencies, or failure handling are substantial.
