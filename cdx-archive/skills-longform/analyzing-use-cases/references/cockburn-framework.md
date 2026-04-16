# Cockburn's Use Case Framework

Reference for Alistair Cockburn's use case concepts as adapted for Codex workflow handoffs.

Load this when you need deeper guidance on goal-level classification, main-scenario step grammar, or extension discovery.

## Goal Levels

Correct goal-level classification prevents wasted work.

### Summary (Cloud-High) ☁️

**Scope:** multiple goals, sessions, or user roles across hours or days.

**Signals:**

- the source spans multiple distinct user goals
- multiple roles are each trying to accomplish different outcomes
- success is not obvious at the end of one sitting

**Action:** too broad for one use case. Slice it first with `slicing-elephant-carpaccio`.

### User-Goal (Sea-Level) 🌊

**Scope:** one actor, one sitting, one goal accomplished or abandoned.

**Signals:**

- a specific actor wants to accomplish a specific thing
- the actor would know immediately whether they succeeded
- the scenario can be expressed as one coherent flow with a small set of extensions

**Action:** this is the right level for use case analysis.

### Subfunction (Fish-Level) 🐟

**Scope:** a partial step inside a larger goal, usually seconds to minutes.

**Signals:**

- completing it would not satisfy a user goal by itself
- it sounds like internal processing or one UI/API step
- the primary outcome is really a means to some larger end

**Action:** identify the parent user-goal and analyze that instead.

## Classification Heuristics

| Signal | Likely Level |
| --- | --- |
| Multiple distinct user roles or workflows | ☁️ Summary |
| One actor pursuing one outcome in one sitting | 🌊 User-goal |
| Mostly phrased as validate/check/log/generate/update | 🐟 Subfunction |
| No user would say "I accomplished X" afterward | 🐟 Subfunction |

## Step Grammar

Main success scenarios should alternate visible actor actions and system responses.

### Actor Steps

- `The user submits the request.`
- `The administrator approves the change.`
- `The customer selects a delivery option.`

### System Steps

- `The system validates the request.`
- `The system confirms the order.`
- `The system records the approval.`

### Rules For Good Steps

- **Observable:** describe behavior visible from outside the implementation
- **Technology-neutral:** avoid buttons, endpoints, SQL, queues, or internal storage
- **Consistent granularity:** keep all steps at roughly the same level
- **One action per step:** split steps that hide multiple actions
- **Goal-directed:** every step should move toward completion or abandonment of the goal

## Extension Discovery

Extensions capture where the main scenario deviates. That is usually where the real implementation complexity lives.

### Notation

Key each extension to the step where the deviation occurs:

```text
3a. [Condition at step 3]:
    1. The system [response].
    2. Use case continues at step 4.

3b. [Different condition at step 3]:
    1. The system [response].
    2. Use case ends.
```

### Discovery Checklist

For each main step, ask:

1. Can the actor provide invalid input?
2. Can authorization or a business rule block progress?
3. Can an external system fail, time out, or reject the request?
4. Can the data already be in an incompatible state?
5. Is there a valid alternate path?
6. Can the step expire, race, or become stale?

### Common Outcomes

An extension can:

- resume the main scenario at a later step
- loop back to an earlier step
- end the use case
- branch to another use case

## Preconditions And Postconditions

### Preconditions

State what must already be true before step 1. Good preconditions are specific, minimal, and verifiable.

Typical categories:

- authentication or session state
- required data already exists
- permissions or roles
- feature flags or system availability

### Success Guarantees

State what must be true after the happy path succeeds. These should become direct assertions in tests.

### Minimum Guarantees

State what must remain true even when the use case fails. These capture invariants such as data integrity, auditability, and security constraints.

## Stakeholders And Interests

Do not stop at the primary actor. The use case should surface stakeholder interests that acceptance criteria often miss.

| Stakeholder Type | Typical Interests |
| --- | --- |
| Operations | logging, monitoring, alerting |
| Security | audit trail, abuse prevention, authorization, sanitization |
| Support | diagnosable error messages, traceability |
| Product | analytics, feature flags, rollout control |
| Compliance | consent, retention, regulatory evidence |

Each interest usually implies a non-functional requirement that later planning must account for.
