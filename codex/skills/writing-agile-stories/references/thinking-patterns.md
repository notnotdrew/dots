# Thinking Patterns For Story Writing

Use `thinking-patterns` selectively when the story is hard to bound or reason about in one pass.

## Phase 1: Discovery

| Situation | Pattern | Application |
| --- | --- | --- |
| Requirements span multiple domains | `atomic-thought` | Decompose into independent facts from each area |
| Multiple stakeholder perspectives | `atomic-thought` | Understand each viewpoint separately |
| Unclear which need is primary | `tree-of-thoughts` | Explore different framings before drafting |

## Phase 2: Drafting

| Situation | Pattern | Application |
| --- | --- | --- |
| Multiple valid story framings | `tree-of-thoughts` | Compare alternatives before choosing one |
| Synthesizing several discovery findings | `graph-of-thoughts` | Combine them into one coherent story |
| Story seems too large | `skeleton-of-thought` | Outline split options before detailing |

## Phase 3: Acceptance Criteria

| Situation | Pattern | Application |
| --- | --- | --- |
| Identifying complete scenario coverage | `skeleton-of-thought` | Outline scenario types before expanding them |
| Complex business logic | `chain-of-thought` | Trace each path step by step |
| Verifying completeness | `self-consistency` | Check coverage from more than one angle |

## Phase 4: Review

| Situation | Pattern | Application |
| --- | --- | --- |
| High-stakes or complex story | `self-consistency` | Run an explicit verification pass |
| Checking scenario coverage | `chain-of-thought` | Walk the story end to end |
| Checking language consistency | `atomic-thought` | Isolate key terms and validate their usage |

## Quick Reference

- `atomic-thought`: multi-domain requirements or terminology cleanup
- `tree-of-thoughts`: competing story framings or split options
- `skeleton-of-thought`: scenario outlines before detail
- `chain-of-thought`: business-rule tracing
- `graph-of-thoughts`: synthesis across discovery inputs
- `self-consistency`: final validation and confidence check
