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

## After init

Move `slowfriday/` into `~/dots-private` and replace the checkout path with a symlink. Same kind of step as inchworm. The script does not do it.
