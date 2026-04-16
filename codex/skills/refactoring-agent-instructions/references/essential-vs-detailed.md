# Essential vs. Detailed

Root files are for what must be seen first. Everything else belongs in `guidelines/`.

## Test

Ask: would this matter on nearly every task?

- Yes: root candidate
- No: category file

## Keep In Root

| Type | Examples |
| --- | --- |
| Project identity | one-line description of the repo or package |
| Non-obvious commands | custom `make`, `just`, or package-specific entrypoints |
| Critical overrides | never push to main, auth changes need review, monorepo targeting rules |
| Universal rules | repo-wide rules that affect almost every task |
| Navigation | links to `guidelines/*.md` |

## Move To Categories

- Language-specific style rules
- Testing conventions
- Git workflow details
- Architecture patterns
- Security, API, performance, and documentation specifics

## Borderline Rule

If the root grows past about 50 lines, it is not minimal enough. Move borderline items out and tighten wording.
