---
name: developing-bash
description: Expert guidance for POSIX shell and Bash scripting. Use when working in `.sh` files or when the task depends on shell portability, Bash features, safety flags, traps, parameter expansion, or cross-platform command behavior.
---

# Developing Bash

Use this skill for shell-specific decisions. Keep it about shell behavior, not generic coding workflow.

## Quick Start

Open only the reference that matches the current constraint:

| Need | Open |
| --- | --- |
| Maximum portability or `sh` compatibility | [posix-scripting](references/posix-scripting.md) |
| Bash-only features such as arrays or `[[ ... ]]` | [bash-features](references/bash-features.md) |
| Safer scripts, argument handling, cleanup, traps | [defensive-patterns](references/defensive-patterns.md) |
| macOS vs Linux command differences | [cross-platform](references/cross-platform.md) |

## Scope

Use this skill for:

- POSIX vs Bash tradeoffs
- shell-safe quoting, expansion, and control flow
- script structure, error handling, and cleanup
- CLI parsing in shell
- GNU vs BSD utility differences

Do not use this skill as the primary guide for:

- general repo workflow or project planning
- non-shell language design
- deployment tooling that is not fundamentally a shell problem

## Core Principles

### Pick The Shell Contract First

1. Decide whether the script must run in POSIX `sh` or can require Bash.
2. Write the shebang and feature set to match that decision.
3. Do not mix Bash features into portability-sensitive scripts.

### Prefer Readable Defensive Shell

1. Quote expansions unless you intentionally want splitting or globbing.
2. Fail early on invalid input and missing dependencies.
3. Keep cleanup explicit with traps when the script allocates resources.

### Match The Target Platform

1. Assume macOS and Linux core utilities differ until confirmed otherwise.
2. Prefer portable flags and simple wrappers over platform-specific inline branches repeated throughout the script.
3. Test the command behavior you rely on instead of assuming GNU semantics.

### Keep Shell Small

1. Use shell for orchestration, files, processes, and glue code.
2. Avoid dense one-liners when a short function is clearer.
3. Escalate to another language when data structures or parsing become the hard part.

## Workflow

1. Identify the contract.
   - Confirm POSIX `sh` vs Bash and note the target platforms.

2. Choose the narrowest reference.
   - Open only the reference that answers the active decision.

3. Apply the smallest safe pattern.
   - Prefer quoting, validation, and simple helpers before clever shell constructs.

4. Verify behavior directly.
   - Run the script or the critical command paths on the relevant shell and platform assumptions.

## Done Well

This skill is being applied well when:

- the script's shell requirement is obvious from the top of the file
- quoting, traps, and validation match the script's real risk surface
- platform-sensitive commands are handled once, not scattered
- the result stays readable without turning shell into pseudo-Python
