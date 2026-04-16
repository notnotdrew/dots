# Refactoring Workflows

Pick the lightest workflow that fits the moment.

## Selection

| Situation | Workflow | Scope |
| --- | --- | --- |
| A test just passed and the code is awkward | TDD refactoring | code touched in the cycle |
| You noticed a tiny mess while doing other work | Litter-pickup | under a few minutes |
| You cannot understand the code yet | Comprehension refactoring | only the code being read |
| A feature would be easier after structural cleanup | Preparatory refactoring | code near the insertion point |
| Debt has been explicitly scheduled | Planned refactoring | time-boxed target area |
| The change spans weeks or system boundaries | Long-term refactoring | incremental, deployable slices |

## Workflow Rules

### TDD refactoring

- only after green tests
- stay close to the code you just changed
- favor rename, extract, inline

### Litter-pickup

- fix it only if it is genuinely quick
- do not let opportunistic cleanup derail the main task

### Comprehension refactoring

- rename and extract to expose meaning
- keep the edits mechanical and reviewable

### Preparatory refactoring

- make the next behavior change easy
- keep structural cleanup separate from the feature when practical

### Planned refactoring

- choose a small number of targets
- time-box the work
- stop at "good enough"

### Long-term refactoring

- define the target state
- move in deployable slices
- prefer branch-by-abstraction or parallel change

## Anti-Patterns

- big bang rewrites
- refactoring without meaningful verification
- mixing feature work and structural cleanup in the same step
- continuing past the point where the next change is speculative
