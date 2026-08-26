# Inchworm LaunchAgent install

Schedule the daily create window with a LaunchAgent labeled `com.inchworm`.

## Install

One command builds the FDA-scoped runner **and** writes a user-local plist (paths for `$HOME`, mise, Homebrew):

```bash
inchworm launchd-setup
```

That:

1. Copies Homebrew `bash` (`/opt/homebrew/bin/bash`) → `~/.local/share/inchworm/inchworm-launchd` and ad-hoc signs it as `com.inchworm.launchd` (FDA target)
2. Renders `launchd/com.inchworm.plist.template` → `~/Library/LaunchAgents/com.inchworm.plist`
3. Reloads the LaunchAgent (`bootout` / `bootstrap`)
4. Opens Full Disk Access settings

Grant Full Disk Access to **only** the runner binary (`⌘⇧G`, paste the path printed by setup). Never add `/bin/bash` — that would FDA-enable every bash job, and the runner no longer shares its identity.

Setup reuses an existing correctly signed runner. Re-signing changes the cdhash and silently voids the FDA grant, so a rebuild prints a reminder to remove the stale System Settings entry and re-add the path.

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

1. `~/.local/share/inchworm/inchworm-launchd` — re-signed Homebrew `bash` copy (FDA target)
2. absolute path to this checkout’s `bin/inchworm`
3. `run`

### Why it is not a copy of `/bin/bash`

A verbatim copy cannot work on Apple Silicon, in either direction:

- **Keep the inherited signature.** The copy still claims identifier `com.apple.bash`, and AMFI enforces a launch constraint restricting that identity to `/bin/bash`. launchd execs it and it dies in ~30ms: `OS_REASON_CODESIGNING | Launch Constraint Violation`.
- **Re-sign it ad-hoc.** `/bin/bash` is `x86_64 arm64e` with no plain `arm64` slice, and the arm64e slice uses a preview ABI only platform binaries may run. Once re-signed it is no longer a platform binary, so exec fails with `not running binary built against preview arm64e ABI` (`OS_REASON_EXEC`).

The runner is copied from Homebrew bash (`/opt/homebrew/bin/bash`, thin `arm64`) and ad-hoc signed as `com.inchworm.launchd`. That sheds any platform identity and gives the copy a cdhash distinct from its source, so the FDA grant covers this runner alone. Apple Silicon only; Intel is not supported.

Setup smoke-tests the signed runner (`runner -c 'exit 0'`) so a broken runner fails at install rather than at the next 8am tick.

## Environment

LaunchAgents get a minimal default `PATH` and no locale, so the generated plist sets `HOME`, `LANG`/`LC_ALL` to `en_US.UTF-8`, and a `PATH` including mise Ruby `latest`, Homebrew, and user bins. Without UTF-8, Ruby treats `finds.md` as US-ASCII and crashes on em dashes. `bin/inchworm` also resolves `mise` by absolute path as a fallback.

## Schedule

- Create window hours 8–15 (Mon–Fri): one tick every 30 minutes (`:00` and `:30`, last tick 15:30). No work at or after 16:00.
- Missed days are not caught up — if a create window is skipped, inchworm does not backfill.

## Unload

```bash
launchctl bootout gui/$(id -u)/com.inchworm
```

Re-run `inchworm launchd-setup` after pulling template changes so the installed plist stays in sync.
