# TDD Plan Examples

Use these examples as format guidance. Adapt the language and commands to the target repo.

## Example: Bug Fix Phase

### Phase 1: Reproduce The Bug

#### Cycle 1: Duplicate submissions are ignored

**RED - Write Failing Test**

```text
it('submits the form only once when the save action is triggered twice quickly', async () => {
  // arrange realistic state
  // trigger duplicate action
  // assert one persisted outcome
})
```

**Expected failure**: the assertion shows two persisted records instead of one

**Structural context**: `app/models/...`, `spec/models/...`, or equivalent verified source locations

### Automated Testing

- [ ] Regression test for duplicate submission handling

**Run**: `bundle exec rspec path/to/spec`
**Expected**: 1 example, 1 failure before the fix; green after implementation

### Manual Verification

- [ ] Trigger the save action twice quickly in the UI or CLI and confirm only one record is created

## Example: New Feature Phase

### Phase 2: Retry Feedback

#### Cycle 1: User sees retry state

**RED - Write Failing Test**

```text
it('shows retry status after the first recoverable failure', async () => {
  // arrange a recoverable failure from the system boundary
  // trigger the action
  // assert on visible retry feedback
})
```

**Expected failure**: no retry status is rendered yet

**Structural context**: verified component file, related test file, and any supporting hook or service contract

### Automated Testing

- [ ] Component test for retry messaging
- [ ] Existing happy-path test remains green

**Run**: `npx vitest run path/to/test`
**Expected**: focused suite passes after implementation

### Manual Verification

- [ ] Simulate a transient failure and confirm the interface shows retry feedback before recovery
