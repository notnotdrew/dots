# TDD Plan Template

# [Task Name] TDD Implementation Plan

## Overview

[Brief summary of the behavior being added or changed and why it matters]

## Current State

- [Verified finding with `file:line` reference]
- [Existing test pattern to follow]
- [Constraint or dependency that shapes the plan]

## Desired End State

[What passes, what behavior becomes observable, and what confidence the tests provide]

## What We're Not Doing

- [Explicit non-goal]
- [Deferred work]

## TDD Strategy

[How the behaviors are sequenced and why this order reduces risk]

---

## Phase [N]: [Phase Name]

[One behavioral slice this phase delivers]

### Cycle [N]: [Behavior]

**RED - Write Failing Test**

```text
[Exact test to write first]
```

**Expected failure**: [What should fail before implementation exists]

**Structural context**: [Relevant files, modules, and contracts with `file:line` references]

### Automated Testing

- [ ] [Focused test description] - `path/to/test`
- [ ] [Nearby regression or integration check] - `path/to/test`

**Run**: `[exact command]`
**Expected**: [expected passing result after implementation]

### Manual Verification

- [ ] [Specific user-visible or operator-visible check]
- [ ] [Concrete scenario to run]
