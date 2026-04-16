# Phase 2: Extract Essentials

Decide what belongs in the root versus `guidelines/`.

Use [references/essential-vs-detailed.md](../references/essential-vs-detailed.md) for borderline cases.

## Rule

Ask: would this matter on nearly every task in the project?

- Yes: root candidate
- No: category file

## Root Usually Keeps

1. Project identity
2. Non-obvious commands or entrypoints
3. Critical overrides that must be seen first
4. Truly universal rules
5. Links to `guidelines/`

## Procedure

1. Classify each instruction as `root` or `category`.
2. Tighten wording while classifying.
3. Assign each category item to a destination file.
4. If the root would exceed about 50 lines, move borderline items out.

## Output

- Root-content list
- Category-content map
- Root line estimate
