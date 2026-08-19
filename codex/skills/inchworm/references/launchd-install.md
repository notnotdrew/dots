# Inchworm LaunchAgent install

Schedule the daily create window with a LaunchAgent labeled `com.inchworm`.

## Install

One command builds the FDA-scoped runner **and** writes a user-local plist (paths for `$HOME`, mise, Homebrew):

```bash
inchworm launchd-setup
```

That:

1. Copies `/bin/bash` → `~/.local/share/inchworm/inchworm-launchd` (FDA target)
2. Renders `launchd/com.inchworm.plist.template` → `~/Library/LaunchAgents/com.inchworm.plist`
3. Reloads the LaunchAgent (`bootout` / `bootstrap`)
4. Opens Full Disk Access settings

Grant Full Disk Access to **only** the runner binary (`⌘⇧G`, paste the path printed by setup). Do not add `/bin/bash` unless the runner alone still hits `EPERM`.

Confirm: `launchctl print gui/$(id -u)/com.inchworm`

Options:

```bash
inchworm launchd-setup --no-open     # skip opening System Settings
inchworm launchd-setup --no-reload   # write runner + plist only
```

## Portability

The repo keeps a **template** (`launchd/com.inchworm.plist.template`) with placeholders (`@HOME@`, `@PATH@`, `@LAUNCHD_RUNNER@`, `@INCHWORM_BIN@`). No machine-specific absolute paths are committed.

`update_symlinks` does **not** link the LaunchAgent plist — `launchd-setup` owns the installed file so each machine gets its own paths.

## Why a wrapper binary

macOS Full Disk Access is per executable. A `#!/usr/bin/env bash` script is usually attributed to `/bin/bash`, which would FDA-enable every bash job.

The generated plist therefore runs:

1. `~/.local/share/inchworm/inchworm-launchd` — copy of `/bin/bash` (FDA target)
2. absolute path to this checkout’s `bin/inchworm`
3. `run`

## Environment

LaunchAgents get a minimal default `PATH`, so the generated plist sets `HOME` and a `PATH` including mise Ruby `latest`, Homebrew, and user bins. `bin/inchworm` also resolves `mise` by absolute path as a fallback.

## Schedule

- Create window hours 8–14 (Mon–Fri): one tick per weekday hour in that range.
- Missed days are not caught up — if a create window is skipped, inchworm does not backfill.

## Unload

```bash
launchctl bootout gui/$(id -u)/com.inchworm
```

Re-run `inchworm launchd-setup` after pulling template changes so the installed plist stays in sync.
