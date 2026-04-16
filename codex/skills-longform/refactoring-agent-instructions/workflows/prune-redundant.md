# Phase 5: Prune Redundant

Identify instructions that should be deleted or rewritten because they add little or no value.

## Inputs

- New root and `guidelines/` files
- Original source files
- [references/deletion-criteria.md](../references/deletion-criteria.md)

## Procedure

### 1. Scan For Deletion Candidates

Check each instruction against these categories:
- agent default
- too vague
- overly obvious
- duplicates built-in behavior
- outdated
- aspirational

Decision rule:
- if removing the instruction would not change behavior, flag it
- if removing it would change behavior, keep it

### 2. Present Candidates

Group candidates by category and present:
- the quoted instruction
- its location
- why it is weak or redundant
- a recommendation to delete or rewrite

Also flag original source files that are now fully represented by the new structure.

### 3. Get User Decisions

For each candidate, the user can:
- delete it
- rewrite it
- keep it

### 4. Apply Approved Changes

- delete approved items
- rewrite items that need stronger wording
- keep explicitly retained items
- delete or archive redundant source files only with approval

### 5. Re-Verify

After pruning:
1. root file remains concise
2. all links resolve
3. no contradictions remain
4. every remaining instruction is actionable
5. no instruction was lost without approval
6. each file is self-contained

## Outputs

- updated root and guideline files
- list of deleted, rewritten, and retained items
- before and after line counts
