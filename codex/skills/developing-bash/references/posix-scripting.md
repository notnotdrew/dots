# POSIX Shell Scripting

Use POSIX `sh` when the script must run broadly across minimal or unknown Unix environments.

## Prefer POSIX When

- the shebang is `#!/bin/sh`
- the script may run on BusyBox, Alpine, Debian `dash`, or older systems
- portability matters more than convenience

## Safe Baseline

```sh
#!/bin/sh
set -eu
```

Use `pipefail` only when you explicitly require a shell that supports it.

## Stay Inside The Contract

- use `[ ... ]`, not `[[ ... ]]`
- use `=` for string comparison
- use `$(...)` for command substitution
- use `$((...))` for arithmetic
- use `printf`, not `echo -e` or `echo -n`
- use positional parameters or plain strings instead of arrays

## Common Traps

- Bash arrays in `sh` scripts
- `[[ ... ]]`, `(( ... ))`, `function`, or `local`
- relying on GNU-only flags without checking availability
- unquoted expansions when you do not want word splitting

## Check

```sh
dash ./script.sh
shellcheck --shell=sh script.sh
```
