# Project Documentation Workflow

Use for READMEs, onboarding guides, and agent-instruction files.

## Place It

- README: repo root
- getting started or onboarding guide: `docs/` or repo root
- `AGENTS.md` or established agent file: repo root

## Choose the Doc

- project overview and common commands: README
- first-run setup: getting started guide
- machine-facing rules and commands: `AGENTS.md` or existing agent file

## Write

1. Inspect the repo structure, manifests, scripts, and existing docs.
2. Prefer the happy path first.
3. Make commands exact and copy-pasteable.
4. Keep headings concrete so a skim reveals setup, commands, structure, and constraints.
5. Keep README and onboarding prose short.
6. Keep agent files directive and compact. Use `ALWAYS` and `NEVER` for hard rules.

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

## Check

- A new developer can run the happy path from the doc alone.
- Commands and versions are exact.
- README stays compact and links out for depth.
- Agent instructions stay short, directive, and runnable.
