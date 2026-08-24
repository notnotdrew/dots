# Refactoring Workflows

Six ways to spend structural effort. Pick the lightest one that makes the work in front of you operable. None of them is "do a full cleanup."

## TDD Refactoring

**When**: Third step of Red-Green-Refactor.

**Context**: You just made a test pass. The code works but may be messy.

**Process**:
1. Tests are green — you have permission to refactor
2. Look at the code you just wrote and recently touched code
3. Apply small refactorings: rename, extract, inline
4. Keep tests green after each change
5. Stop when the code you just touched is operable for the next edit — not when it looks finished

**Scope**: Limited to code touched in the current TDD cycle. Don't wander.

**Trigger**: "Green, but this will fight the next change."

## Litter-Pickup Refactoring

**When**: Passing through code while working on something else.

**Context**: You're adding a feature and encounter a small mess.

**Process**:
1. Notice something that will make *this* task, or the immediate next one, harder
2. If it's small and well covered, fix it now
3. If longer, note it and continue
4. Leave the path you walked a little easier to walk again — do not tour the rest of the module

**Scope**: Opportunistic, small improvements only.

**Trigger**: "While I'm here, I'll clean this up."

## Comprehension Refactoring

**When**: Trying to understand unfamiliar code.

**Context**: You're reading code and it's hard to follow.

**Process**:
1. Start reading the code
2. When confused, refactor to clarify
   - Rename to what things actually represent
   - Extract methods to name confusing blocks
   - Inline indirection that obscures meaning
3. Stop when you can change it without guessing
4. Keep the clarifications as a separate, reviewable change when possible

**Scope**: Code you're trying to understand.

**Trigger**: "What does this even do?"

## Preparatory Refactoring

**When**: About to add a feature, but the code isn't ready.

**Context**: The feature would be easy if the code were structured differently. Fowler: make the change easy, then make the easy change.

**Process**:
1. Identify where the new feature will go
2. Refactor just enough that the feature has a place to go (move envy, split a phase, gather a role — only as needed)
3. Keep the preparatory refactoring separate from the feature change when possible
4. Add the feature (now easy)
5. Land the feature after the structural prep is complete

**Scope**: Code that will receive the new feature.

**Trigger**: "This would be easy if the policy lived in one object."

```
# Before: feature would require changes in 5 places
# Preparatory: gather the behavior behind one role
# After: feature requires change in 1 place
```

## Planned Refactoring

**When**: Dedicated time for cleanup of a known mess.

**Context**: Technical debt has accumulated; focused work is needed.

**Process**:
1. Identify high-impact targets (shotgun surgery on *this week's* change, not every smell)
2. Time-box; stop when the path you came to change is operable
3. Work systematically; test after each refactoring
4. Stop when time runs out or the path you came to change is operable

**Scope**: Defined by the request. Can be larger than other workflows.

**Trigger**: "We need to spend time cleaning up billing."

**Caution**: If every change needs a dedicated cleanup project, the cheaper habit is a little structure on the path you already walk.

## Long-Term Refactoring

**When**: Large structural change needed over many steps.

**Context**: Major design change that can't be done in one sitting.

**Process**:
1. Define the target state (a role, a bounded context, a new collaborator)
2. Identify incremental steps that keep the system working
3. Apply changes gradually alongside regular work
4. Use Branch by Abstraction or Parallel Change
5. Each intermediate state must be deployable

**Scope**: Architectural. May span multiple objects or packages.

**Trigger**: "We need to replace the payment gateway."

**Patterns**:
- **Branch by Abstraction**: Create the role, implement the new version behind it, migrate callers, remove the old
- **Parallel Change**: Add new, migrate callers one by one, remove old
- **Strangler Fig**: New path handles more cases over time until the old can be removed

## Workflow Selection Guide

| Situation | Workflow |
|-----------|----------|
| Test just passed | TDD Refactoring |
| Noticed small issue while working | Litter-Pickup |
| Code is confusing to read | Comprehension |
| Feature would be hard to add | Preparatory |
| Accumulated debt needs attention | Planned |
| Major architecture change | Long-Term |

## Integration with Development

### With Feature Work
```
1. Start feature
2. [Preparatory] Refactor to make the feature easy
3. Add feature (easy now)
4. [TDD] Refactor after tests pass
5. [Litter-Pickup] Fix only what would fight the next pass along this path
```

### With Bug Fixes
```
1. Write a failing test for the bug
2. [Comprehension] Refactor to understand the code
3. Fix the bug
4. [TDD] Refactor after the fix
```

### With Code Review
```
1. See confusing code in a PR
2. [Comprehension] Suggest a named refactoring, not "please clean this up"
3. Apply agreed refactorings in small steps
```

## Anti-Patterns

**Big bang refactoring**: Large structural change all at once. Prefer incremental.

**Refactoring on red**: No safety net, or you cannot tell whether the refactor broke it. Get to green first.

**Mixing hats**: Structure and behavior in one step.

**Cleanliness for its own sake**: Applying the catalog because a smell exists, or polishing code nobody is changing.

**Wrong abstraction**: Extracting a `Base` / `Helper` / flagged service that makes later change *more* expensive.

**Unreviewable batches**: Keep refactorings in small, understandable increments.
