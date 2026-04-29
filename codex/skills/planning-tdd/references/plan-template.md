# TDD Plan Template

# [Task Name] TDD Implementation Plan

## Overview

[Brief summary of the behavior being added or changed and why it matters]

## Current State Analysis

### Key Discoveries

- [Verified finding with `file:line` reference]
- [Existing test pattern to follow]
- [Constraint or dependency that shapes the plan]

### Testing Infrastructure

- **Framework**: [Vitest, RSpec, ExUnit, etc.]
- **Helpers**: [fixtures, factories, support files]
- **Run command**: [focused command for the relevant tests]
- **Wider verification**: [broader command to confirm surrounding safety]

## Desired End State

[What passes, what behavior becomes observable, and what confidence the tests provide]

## What We're Not Doing

- [Explicit non-goal]
- [Deferred work]

## TDD Strategy

[How the behaviors are sequenced and why this order reduces risk]

---

## Phase 1: [Phase Name]

### Overview

[What behavioral slice this phase delivers]

### TDD Cycles

#### Cycle 1: [Behavior]

**RED - Write Failing Test**

```text
[Exact test to write first]
```

**Expected failure**: [What should fail before implementation exists]

**Structural context**: [Relevant files, modules, and contracts with `file:line` references]

#### Cycle 2: [Behavior]

**RED - Write Failing Test**

```text
[Exact test to write first]
```

**Expected failure**: [Failure mode]

**Structural context**: [Relevant files with `file:line` references]

### Automated Testing

- [ ] [Focused test description] - `path/to/test`
- [ ] [Integration or regression test description] - `path/to/test`

**Run**: `[exact command]`
**Expected**: [expected passing result after implementation]

### Manual Verification

- [ ] [Specific user-visible or operator-visible check]
- [ ] [Concrete scenario to run]

---

## Phase 2: [Phase Name]

### Overview

[What this phase adds]

### TDD Cycles

#### Cycle 1: [Behavior]

**RED - Write Failing Test**

```text
[Exact test to write first]
```

**Expected failure**: [Failure mode]

**Structural context**: [Relevant files with `file:line` references]

### Automated Testing

- [ ] [Test description] - `path/to/test`

**Run**: `[exact command]`
**Expected**: [expected result]

### Manual Verification

- [ ] [Concrete check]
