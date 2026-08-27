# FP Design Vocabulary

Use this when the repository or design is naturally functional.

## Component Types

| Component | Purpose | When to Use |
|---|---|---|
| Module | Namespace for related functions | Core organizational unit |
| Context module | Public API boundary | Domain boundary in app code |
| Behaviour | Callback contract for polymorphism | Swappable implementations |
| Protocol | Type-based dispatch | Extending behavior for new data types |
| GenServer | Stateful process | Serialized mutable state |
| Supervisor | Process lifecycle management | Fault tolerance and restarts |
| Task | One-off async computation | Parallel or deferred work |
| Worker | Background job processing | Persistent async work with retries |

## Design Prompts

- What is the pure core, and where are the side-effect boundaries?
- Which transformations are sequential pipelines, and which are process interactions?
- Does any state really need a process, or can it stay as plain data?
- Are contracts best expressed as types, tagged tuples, behaviours, or schemas?

## Common Patterns To Name Clearly

- transformation pipelines
- `with` chains for failure propagation
- message passing between processes
- event broadcasting
- functional core with imperative shell

## Anti-Patterns To Challenge

- unnecessary stateful processes
- I/O mixed into transformation logic
- god modules
- callback soup
- stringly typed domain data
