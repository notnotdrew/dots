# Category File Templates

Templates for each category file written to `guidelines/`. Adapt them to the project's actual instruction set.

## Universal Template

Every category file follows this structure:

```markdown
# [Category Title]

[Optional: one-line scope statement if the title alone is ambiguous.]

## [Sub-topic 1]

- [Actionable instruction]
- [Actionable instruction]

## [Sub-topic 2]

- [Actionable instruction]
- [Actionable instruction]
```

Rules:
- Title matches filename: `testing.md` has heading `# Testing`
- No frontmatter
- No cross-references to other category files
- Every line is an actionable directive
- Use bullet lists for instructions, not long prose paragraphs
- Add sub-topic headings only when 3 or more instructions share a theme

## Category-Specific Templates

### guidelines/code-style.md

```markdown
# Code Style

## Formatting

- [Indentation rule]
- [Line length rule]
- [Trailing comma preference]

## Naming

- [Variable naming convention]
- [File naming convention]
- [Function naming convention]

## Imports

- [Import ordering rule]
- [Import grouping rule]

## Language-Specific

- [Type annotation preferences]
- [Pattern preferences]
```

### guidelines/testing.md

```markdown
# Testing

## Framework

- [Test runner and framework]
- [Assertion library]

## Conventions

- [Test file location and naming]
- [Test description style]
- [Setup or teardown patterns]

## Patterns

- [Mocking approach]
- [Fixture management]
- [Integration vs unit preferences]

## Coverage

- [Coverage requirements]
- [What to test vs skip]
```

### guidelines/git-workflow.md

```markdown
# Git Workflow

## Branches

- [Branch naming convention]
- [Base branch for new work]
- [Branch lifecycle]

## Commits

- [Commit message format]
- [Commit scope and size]
- [Co-author conventions]

## Pull Requests

- [PR title format]
- [PR description requirements]
- [Review process]

## Restrictions

- [Protected branches]
- [Force-push policy]
```

### guidelines/architecture.md

```markdown
# Architecture

## Project Structure

- [Directory layout conventions]
- [Module organization]

## Patterns

- [Design patterns in use]
- [State management approach]
- [Data-flow conventions]

## Boundaries

- [Layer responsibilities]
- [Dependency direction rules]
- [API surface rules]
```

### guidelines/typescript.md

```markdown
# TypeScript

## Types

- [Type vs interface preference]
- [Strictness settings]
- [Generic patterns]

## Components

- [Component patterns]
- [Props conventions]
- [Hook patterns]

## Patterns

- [Error handling]
- [Async patterns]
- [Module structure]
```

### guidelines/elixir.md

```markdown
# Elixir

## Modules

- [Module naming and organization]
- [Context boundaries]
- [Public API conventions]

## Functions

- [Function clause ordering]
- [Pipeline conventions]
- [Pattern-matching style]

## OTP

- [GenServer patterns]
- [Supervision-tree conventions]
- [Process boundaries]

## Ecto

- [Schema conventions]
- [Query patterns]
- [Migration style]
```

### guidelines/security.md

```markdown
# Security

## Secrets

- [Secret storage approach]
- [Environment variable conventions]
- [Files to never commit]

## Input Validation

- [Validation patterns]
- [Sanitization rules]

## Authentication

- [Auth approach]
- [Session management]
```

### guidelines/api-design.md

```markdown
# API Design

## Endpoints

- [URL structure rules]
- [HTTP method conventions]
- [Versioning rules]

## Responses

- [Success response format]
- [Error response format]
- [Pagination conventions]

## Contracts

- [Schema or typing requirements]
- [Backward-compatibility rules]
```
