# Phase 3: Categorize Instructions

Group all non-root instructions into 3-8 logical category files.

## Inputs

- Category-content map from Phase 2
- Original instruction files for context

## Procedure

### 1. Identify Natural Categories

Let categories emerge from the actual content instead of forcing a generic taxonomy.

Common category options:

| Category | Use When |
| --- | --- |
| `code-style.md` | Language-agnostic style rules exist |
| `testing.md` | Test framework, conventions, or coverage rules exist |
| `git-workflow.md` | Branch, commit, PR, or release rules exist |
| `architecture.md` | Structure, boundaries, or design-pattern rules exist |
| `typescript.md` | TypeScript or React-specific rules exist |
| `elixir.md` | Elixir or Phoenix-specific rules exist |
| `python.md` | Python-specific rules exist |
| `security.md` | Secret handling, auth, or validation rules exist |
| `api-design.md` | API contract or endpoint rules exist |
| `error-handling.md` | Logging, exceptions, or failure handling rules exist |
| `performance.md` | Caching, bundle, or query constraints exist |
| `documentation.md` | Doc and comment standards exist |

Use [references/category-templates.md](../references/category-templates.md) when you need structure hints.

### 2. Apply Sizing Rules

- Minimum 3 categories when the content is substantial
- Maximum 8 categories unless the project truly needs more
- Merge categories that would only contain a handful of lines
- Split categories that would become unwieldy

### 3. Assign Instructions

For each instruction:
1. Choose the single best category
2. Prefer the most specific category that fits
3. Do not duplicate instructions across files

### 4. Order Within Each Category

Order content by:
1. highest impact
2. most frequently relevant
3. related instructions grouped together

### 5. Present The Proposed Structure

Show the user a category plan with filenames and rough contents before writing files when the grouping is materially ambiguous.

## Outputs

- final category map
- category count and rough line estimates
- user-confirmed structure when confirmation is needed

## Quality Checks

- No category is empty
- No instruction appears in more than one file
- Every detailed instruction from Phase 2 is accounted for
- Filenames are lowercase kebab-case with `.md`
