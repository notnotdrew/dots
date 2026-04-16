# Bash Features

Require Bash only when the feature meaningfully simplifies the script.

## Reach For Bash When

- arrays make the logic safer or clearer
- `[[ ... ]]` avoids fragile test syntax
- parameter expansion can replace external process churn
- process substitution or `mapfile` materially improves readability

## Commonly Worth It

```bash
#!/usr/bin/env bash
set -euo pipefail
```

- indexed arrays: `files=(./*.txt)`
- associative arrays: `declare -A by_key`
- safer tests: `[[ -f "$file" && "$name" == *.txt ]]`
- arithmetic: `((count += 1))`
- richer expansion: `${path##*/}`, `${var:-default}`
- process substitution: `diff <(sort a) <(sort b)`

## Version Notes

- macOS commonly ships Bash 3.2 unless the environment installs a newer Bash
- associative arrays, `mapfile`, and newer expansion features may require Bash 4+
- document the version requirement when using nontrivial Bash features

## Common Traps

- writing Bash-only code behind a `sh` shebang
- using advanced features when a simple loop would be clearer
- assuming every macOS machine has modern Bash
