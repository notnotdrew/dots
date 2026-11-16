# Phase 2: Extract Essentials

Separate instructions into two buckets: what must stay in the root file and what belongs in linked category files.

## Inputs

- Resolved instruction set from Phase 1
- All discovered instruction-file contents

## Decision Rule

Ask: would this instruction matter on nearly every task in the project?

- Yes: keep it in root
- No: move it to a category file

For detailed criteria and borderline examples, use [references/essential-vs-detailed.md](../references/essential-vs-detailed.md).

## Root Content

Only these usually belong in root:

1. Project identity
2. Non-obvious package manager or command entrypoints
3. Non-standard build, test, lint, or format commands
4. Critical overrides that must be seen first
5. Truly universal rules
6. Links to `guidelines/`

## Category Content

Move everything else into categories, including:
- language-specific style rules
- testing conventions
- git workflow details
- architecture guidance
- API, security, performance, and documentation rules

## Procedure

### 1. Classify Each Instruction

For every instruction, decide:
- root or category
- destination filename if category
- final wording if it needs tightening

### 2. Build Two Outputs

Produce:
- a root-content list
- a category-content map

### 3. Validate Root Size

If the root would exceed about 50 lines:
1. re-check every item against the essential criteria
2. move borderline items out
3. tighten wording to short, direct bullets

### 4. Present The Classification

When useful, show:
- what stays in root
- which category files will be created
- rough counts for each

## Outputs

- root-content list
- category-content map
- root-file line estimate
