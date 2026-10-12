# Slowfriday

One Friday look at a slow part of a registered app. Init sets that up.

## Init

From the repo, run `slowfriday init`.

It writes:

- `slowfriday/guide.md`. A short placeholder for the procedure a Friday follows.
- `slowfriday/config.yml`. Version 1. `trunk` is blank, which means main.
- `slowfriday/log.md`. A one-line heading.
- `slowfriday/notes/`. An empty directory.

It appends `slowfriday/` to the global gitignore (`~/.gitignore_global`). It registers the absolute path of the current directory in `~/.config/slowfriday/config.yml` (or `$XDG_CONFIG_HOME/slowfriday/config.yml` when that is set).

The registry is version 1. The defaults are runtime `cursor-cli`, Fridays (`fri`), window `08:00-16:00`, and `catch_up_missed_days` false. Repos are a list of absolute paths.

Init is idempotent. A second init keeps a single registry entry and a single gitignore line. It does not replace guide, log, or config contents that are already there. Notes already in the directory stay.

## Run

`slowfriday run` considers each registered repository on Friday, from 08:00 until 16:00 local time. 08:00 is inside the window. 16:00 is outside. Outside the window it skips the repo and does not query.

`slowfriday/notes/<yymmdd>.md` is the weekly stamp. `yymmdd` is the local date as six digits. When that note exists, the repo is skipped. A live `progress_pid` in `slowfriday/config.yml` blocks another run. A pid whose process is gone is cleared, and the tick continues. If preflight or the queries fail, the note is not written, so the week stays unstamped and a later Friday tick can retry.

An eligible run fetches the configured trunk (`trunk` blank means main) and opens `drew/slowfriday-<yymmdd>` with `herdr worktree create --cwd`, `--branch`, and `--base origin/<trunk>`. The worktree's `slowfriday/` entry becomes a symlink to the registered checkout's directory. If the fetch or the Herdr open fails, the note is not written and a later tick retries.

The orchestrator runs in the dated worktree. It follows the registered guide, and it writes the log and the weekly note itself.

## LaunchAgent

`slowfriday launchd-setup` installs a LaunchAgent that ticks `slowfriday run` on Friday from 08:00–15:30, every 30 minutes.

Grant Full Disk Access only to the runner path that command prints. A rebuilt runner needs the grant added again.

## After init

Move `slowfriday/` into `~/dots-private` and replace the checkout path with a symlink. Same kind of step as inchworm. The script does not do it.
