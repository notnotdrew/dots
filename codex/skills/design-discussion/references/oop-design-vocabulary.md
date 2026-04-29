# OOP Design Vocabulary

Use this when the repository or design is naturally object-oriented.

## Component Types

| Component | Purpose | When to Use |
|---|---|---|
| Class | Encapsulates state and behavior | Core domain entities |
| Service | Stateless business logic orchestration | Cross-cutting operations |
| Repository | Data access abstraction | Persistence boundaries |
| Factory | Complex object construction | When constructors are not enough |
| Controller | Request handling and delegation | API or web entry points |
| Adapter | External system integration | Third-party boundaries |
| Value Object | Immutable data with behavior | Money, dates, coordinates |
| Entity | Identity-based domain object | Users, orders, accounts |

## Design Prompts

- Can each component be described in one sentence without "and"?
- Are collaborators explicit, or hidden inside object construction?
- Is there a real benefit to each abstraction, or is it only ceremony?
- Does the design push behavior toward the object that owns the data?

## Common Patterns To Name Clearly

- dependency injection
- repository boundaries
- observer or pub-sub interactions
- strategy for swappable behavior
- command objects for queued or replayable work

## Anti-Patterns To Challenge

- god objects
- premature interface extraction
- service explosion
- feature envy
- anemic domain models
