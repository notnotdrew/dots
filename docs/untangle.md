# Untangle

Init registers a repo for a Wednesday look at one knot.

## Init

From the repo, run `untangle init`.

It writes:

- `untangle/guide.md`, when that file is missing. The guide lists the eight buckets in cursor order and the note rules.
- `untangle/config.yml`, when that file is missing. Version 1. `trunk` is a blank string, which means main.
- `untangle/log.md`, when that file is missing or empty. The content is `# Log`.
- `untangle/notes/`. An empty directory.

It appends `untangle/` to the global gitignore (`~/.gitignore_global`, or `UNTANGLE_GITIGNORE_GLOBAL` when that is set). A line that is already there stays a single line. Lines that were already in the file stay.

It registers the absolute path of the current directory once in `UNTANGLE_CONFIG_DIR/config.yml`. That directory defaults to `${XDG_CONFIG_HOME:-$HOME/.config}/untangle`.

The registry is version 1. The defaults are runtime `cursor-cli`, Wednesday (`wed`), window `08:00-16:00`, and `catch_up_missed_days` false. Repos are a list of absolute paths.

A second init keeps a single registry entry and a single gitignore line. A second init leaves an existing guide alone. Log, config, and notes that are already there stay. Another registered repo stays.

## After init

Move `untangle/` into `~/dots-private` and replace the checkout path with a symlink. The script does not do that move.
