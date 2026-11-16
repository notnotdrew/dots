# Essential vs. Detailed

Use this decision rule to decide whether an instruction belongs in the root file or a linked file in `guidelines/`.

## Core Question

Would someone need this instruction on nearly every task, regardless of which part of the project they touch?

- Yes: it may belong in the root file
- No: move it to a category file

## Root File Criteria

An instruction belongs in the root only if it meets one or more of these criteria.

### 1. Project Identity

Keep a one- or two-line description that explains what the project is.

Keep in root:
- "Phoenix API backend for the Acme billing platform"
- "React component library published as `@acme/ui`"

Move to guidelines:
- detailed architectural patterns
- stack-specific conventions
- deeper design decisions

### 2. Non-Standard Commands

Keep build, test, lint, or format commands only when they are non-obvious for the stack.

Keep in root:
- `pnpm test`
- `mix test --warnings-as-errors`
- `make build`

Move to guidelines:
- `npm test`
- `pytest`
- detailed test or lint configuration

### 3. Critical Overrides

Keep instructions that must be seen before any work begins.

Keep in root:
- "NEVER push to main"
- "NEVER commit `.env` files"
- "All auth changes require security review"
- "This is a monorepo; always identify the target package"

Move to guidelines:
- normal git workflow details
- detailed security practices

### 4. Universal Rules

Keep rules that apply across almost every task.

Keep in root:
- "All code must pass strict TypeScript"
- "No `console.log` in committed code"
- "Every public function needs a doc comment"

Move to guidelines:
- language-specific style rules
- test conventions
- architecture patterns

### 5. Links To Guidelines

The root file's main job after essentials is navigation.

Use a compact links section such as:

```markdown
## Guidelines

- Code Style: `guidelines/code-style.md`
- Testing: `guidelines/testing.md`
- Git Workflow: `guidelines/git-workflow.md`
```

## Common Category Destinations

| Content Type | Destination |
| --- | --- |
| Language-specific style | `guidelines/typescript.md`, `guidelines/elixir.md`, etc. |
| Testing conventions | `guidelines/testing.md` |
| Git rules | `guidelines/git-workflow.md` |
| Architecture decisions | `guidelines/architecture.md` |
| API conventions | `guidelines/api-design.md` |
| Security practices | `guidelines/security.md` |
| Error handling | `guidelines/error-handling.md` |
| Performance constraints | `guidelines/performance.md` |
| Documentation rules | `guidelines/documentation.md` |

## Borderline Cases

### "Always use semicolons"

Usually move this to `guidelines/code-style.md`. One style rule rarely deserves root placement on its own.

### "Use feature branches"

Usually move this to `guidelines/git-workflow.md`.

### "Prefer composition over inheritance"

Move this to `guidelines/architecture.md`.

### "Run `npm run lint` before committing"

If automation already enforces it, delete it. If not, keep it in `guidelines/git-workflow.md`, not in the root.

## 50-Line Test

After classifying content, count the root file lines.

If the root file is over 50 lines:
1. Re-check every item against the essential criteria
2. Move borderline items into categories
3. Tighten wording into short bullets

If the root file is under 20 lines, that is fine. Minimal is the goal.
