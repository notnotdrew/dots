# Mermaid Diagram Patterns

Use diagrams only when they materially improve understanding.

## Component Diagram

Use for a high-level system picture when naming responsibilities and boundaries.

```mermaid
graph TB
    UI[User Interface]
    Service[Domain Service]
    Queue[Background Queue]
    DB[(Database)]

    UI --> Service
    Service --> DB
    Service --> Queue
```

## Sequence Diagram

Use for request or workflow scenarios across components.

```mermaid
sequenceDiagram
    actor User
    participant API
    participant Service
    participant Repo

    User->>API: submit request
    API->>Service: execute()
    Service->>Repo: save()
    Repo-->>Service: result
    Service-->>API: response
    API-->>User: success
```

## Flowchart

Use for branching logic, policy decisions, or retry flows.

```mermaid
flowchart TD
    A[Receive input] --> B{Valid?}
    B -->|yes| C[Process]
    B -->|no| D[Reject]
    C --> E{Needs follow-up?}
    E -->|yes| F[Schedule work]
    E -->|no| G[Finish]
```

## Rules

- Prefer the smallest diagram that answers the question
- Keep labels domain-specific, not generic placeholders
- Do not draw diagrams for single-component changes unless the interaction is the hard part
