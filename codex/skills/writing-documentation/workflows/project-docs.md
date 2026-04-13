# Project Documentation Workflow

Write READMEs, getting-started guides, onboarding docs, and agent-instruction files that serve both human developers and LLMs.

## Inputs

One or more of:

- project path to document
- natural language description of what needs documenting
- specific doc type requested such as README, getting started guide, or `AGENTS.md`

## Output Placement

Project docs are standalone markdown files:

- README: project root as `README.md`
- getting started guide: `docs/getting-started.md` or project root
- `AGENTS.md`: project root
- alternate agent instructions when required by the repo: `CLAUDE.md` or another established file

## Doc Type Detection

| Request Contains | Doc Type | Section |
| --- | --- | --- |
| "README", "project overview" | README | README template |
| "getting started", "setup guide", "onboarding" | Getting started guide | Getting started template |
| "AGENTS.md", "CLAUDE.md", "agent instructions", "coding guidelines" | Agent instructions | Agent instructions template |

## Procedure

### Step 1: Gather Context

Examine the project:

1. read the directory structure to identify the language, framework, and key directories
2. find existing docs to avoid duplication
3. read package manifests for project metadata
4. identify key commands for build, test, lint, format, and run
5. inspect configuration files that reveal conventions

### Step 2: Select Template

Choose the appropriate template below.

### Step 3: Write the Draft

Apply these principles for human readers:

- lead with what the reader needs to do
- use concrete, copy-pasteable commands
- keep paragraphs short
- provide the happy path first

Apply these principles for LLM readers:

- use explicit keyword-rich headings
- front-load context in each section
- make each section self-contained
- use fully qualified names for code references
- state relationships explicitly

### Step 4: Polish User-Facing Prose

For READMEs, getting-started guides, and tutorials, do a final rewrite pass:

- cut filler and hedging
- replace vague claims with concrete facts
- prefer active voice
- keep paragraphs to 2-4 sentences
- keep headings specific rather than generic
- make sure a skimming reader can find setup, commands, and key concepts quickly

Do not do this prose-polish pass for agent instructions. Agent files are directive documents, not narrative prose.

### Step 5: Validate

Run the quality checklist at the bottom of this file.

## README Template

````markdown
# [Project Name]

[One sentence: what this project does and who it is for.]

## Quick Start

[Minimal steps to get running.]

```bash
[clone/install/run commands]
```

## What It Does

- [Concrete behavior]
- [Concrete behavior]

## Project Structure

```text
src/
  auth/       # Authentication and session management
  billing/    # Payment processing and invoicing
  api/        # REST and GraphQL endpoints
```

## Development

### Prerequisites

[Exact versions.]

### Setup

```bash
[step-by-step commands]
```

### Common Tasks

| Task | Command |
| --- | --- |
| Run tests | `mix test` |
| Lint | `mix credo --strict` |
| Format | `mix format` |

## Architecture

[Brief mental model or link to architecture docs.]

## Contributing

[Brief contribution guidance.]
````

## Getting Started Guide Template

````markdown
# Getting Started with [Project Name]

[One sentence: what the reader will be able to do after completing this guide.]

## Prerequisites

- [Tool] [version]: [install link]

## Setup

### Step 1: [Action Verb First]

```bash
[command]
```

### Step 2: [Action Verb First]

```bash
[command]
```

### Step 3: Verify Setup

```bash
[verification command]
```

Expected output:

```text
[what they should see]
```

## First Task

[Walk through a real task with real output.]

## What to Read Next

- [Link to architecture doc]
- [Link to API reference]
- [Link to testing guide]
````

## Agent Instructions Template

Agent instruction files are machine-consumed directives optimized for reliable agent behavior.

````markdown
# [Project Name]

[One sentence: what this project is.]

## Commands

- `[test command]`
- `[lint command]`
- `[format command]`
- `[single test command pattern]`

## Rules

- [NEVER or ALWAYS directive]
- [NEVER or ALWAYS directive]

## Guidelines

- [Coding Standards](guidelines/coding-standards.md)
- [Testing](guidelines/testing.md)
- [Git Workflow](guidelines/git-workflow.md)
````

Agent-instruction rules:

- prefer `AGENTS.md` when the repo uses it
- if the repo already standardizes on `CLAUDE.md`, preserve that convention
- keep the root file short and link to detail files when needed
- use `NEVER` and `ALWAYS` for hard constraints
- list exact runnable commands
- avoid explanatory prose

## Post-Processing Decision Matrix

| Doc Type | Prose polish pass? | Reason |
| --- | --- | --- |
| README | Yes | User-facing prose |
| Getting started guide | Yes | User-facing prose |
| `AGENTS.md` | No | Machine-consumed directives |
| `CLAUDE.md` | No | Machine-consumed directives |
| Tutorial | Yes | User-facing prose |

## Quality Checklist

- [ ] A new developer can get the project running from the doc alone
- [ ] All commands are copy-pasteable and correct
- [ ] Prerequisites list exact versions
- [ ] Headings are specific and action-oriented
- [ ] Each section is self-contained
- [ ] No ambiguous pronouns cross section boundaries
- [ ] README stays compact and links out for depth
- [ ] Root agent instruction file stays compact and links out for depth
- [ ] User-facing docs have been polished for readability
- [ ] Agent instructions use `NEVER` or `ALWAYS` for hard constraints
