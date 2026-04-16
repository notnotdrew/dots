# Defensive Shell Patterns

Use these patterns when the script touches files, external commands, temp resources, or destructive operations.

## Baseline

```bash
#!/usr/bin/env bash
set -euo pipefail
```

Add `set -E` only when an `ERR` trap needs to propagate through functions.

## Default Moves

- quote expansions: `"$var"`
- validate required args before work starts
- check external commands with `command -v`
- prefer small helpers such as `die`, `usage`, or `require_file`
- create temp files with `mktemp`
- clean up with `trap ... EXIT`

## Minimal Pattern

```bash
die() {
    printf '%s\n' "$*" >&2
    exit 1
}

cleanup() {
    rm -f "$tmp_file"
}

tmp_file="$(mktemp)" || die "mktemp failed"
trap cleanup EXIT
```

## Common Traps

- `rm`, `mv`, or redirects built from unchecked input
- partial pipelines hidden by missing `pipefail`
- parsing command output that already has a safer interface
- traps that clobber the original exit status

## Use Judgment

- `set -e` is useful, but still read control-flow edges involving `if`, `||`, subshells, and pipelines
- do not cargo-cult every safety flag into shells that do not support them
