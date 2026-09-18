# Finish diagnosing macOS TCC prompts from the Cursor CLI's ripgrep

macOS intermittently shows `"rg" would like to access data from other apps.`
The cause is partly diagnosed and two mitigations are live. The remaining job
is to identify the one remaining unknown, fix it at the narrowest level, and
remove the temporary diagnostic shim.

This chat does not need to stay open. The shim logs on its own. When a prompt
appears, start a new agent session with this file.

## Status (2026-09-15)

Trigger **not captured**. No TCC AppData prompts after the 2026-09-14 10:21
burst. The shim was installed after that burst (`/tmp/rg-argv.log` starts at
10:33:37), so those argv/cwd pairs are gone (pids 64024 and 64045).

Do not force a reproduction. Wait for the next real prompt, then continue at
Workflow step 1.

## Environment

- macOS 26 (darwin 25.6.0). Agents run as Cursor CLI sessions inside `herdr`
  panes (a terminal multiplexer), usually several at once.
- Work repos: `~/dev/screensteps/screensteps-live` plus `screensteps-live.*`
  worktrees created by `worktrunk` (`wt`). Repos moved from `~/Documents/dev`
  to `~/dev` on 2026-09-11.
- Dotfiles repo `~/dots`; `~/.cursor` and `~/.codex` are symlinks into it.
- `log` is a shell builtin/shadowed in this zsh setup. Always call
  `/usr/bin/log` explicitly.

## Established facts (do not re-derive)

- The prompting binary is the Cursor CLI's bundled ripgrep,
  `~/.local/share/cursor-agent/versions/<version>/rg`, Developer ID signed
  (team DCNK4UB866). Nothing else on the machine prompts for app data.
- Service is `kTCCServiceSystemPolicyAppData` with `preflight=no`, so these are
  real reads, not speculative checks.
- `rg` asks for Full Disk Access first and gets `Denied (Service Policy)`,
  which is why it falls back to the per-app prompt.
- The 2026-09-14 10:21 prompts were qualified by
  `indirect_object_identifier="com.apple.CloudDocs.iCloudDriveFileProvider/..."`
  under `kTCCServiceFileProviderDomain`, with `target_identifier` equal to the
  `rg` path. So `rg` reads something under `~/Library/Mobile Documents`.
- `tccd` logs "Failed to fetch responsible file descriptor" and treats `rg` as
  its own responsible process (identity `herdr-<hash>`), so it cannot inherit
  iTerm2's existing grants. That is why the dialog names `rg`.
- Session startup runs five `rg` scans, all with `--hidden --follow`, including
  `--files --follow --max-depth 16` from the workspace root and instruction-file
  globs (`*/**/.cursor/**`, `*/**/.codex/**`, `AGENTS.md`, ...). The Grep tool
  itself runs `rg -l --case-sensitive --sortr modified --no-config
  --color=never --hidden --follow --regexp <pattern> -- .`
- Prompts are episodic, not chronic: a burst on 2026-09-11 16:22–16:59, then
  nothing for three days, then five at 2026-09-14 10:21. Two new worktree
  sessions started at 10:19 and 10:20, so it correlates with interactive
  session startup.
- Ruled out: no symlink under `~/dev`, `~/dots`, or `~/dots-private` resolves
  into `~/Library`; `~/Documents` is not iCloud-backed and Desktop/Documents
  sync is off; headless `agent -p` runs started from both `~/dots` and a
  worktree never rooted a scan at `$HOME`; `~/.cursor/unified_repo_list.json`
  is empty.

## The unknown

Which `rg` invocation reaches `~/Library/Mobile Documents`, and from what
working directory. Every candidate tested so far was repo-scoped.

## Current state

- Diagnostic shim: the real binary is `rg.real` in
  `~/.local/share/cursor-agent/versions/2026.09.10-fd3934a/`, and `rg` is a
  bash script that appends timestamp, pid, cwd and argv to `/tmp/rg-argv.log`
  (self-truncating at 5MB) before exec'ing `rg.real`. A CLI update silently
  replaces it and logging stops. Last confirmed intact on 2026-09-14 12:40
  (wrapper 553B, `rg.real` Mach-O arm64, log actively appending).
- `~/.ignore`: anchored patterns (`/Library/`, `/Documents/`, `/Downloads/`,
  `/Desktop/`, `/Pictures/`, `/Movies/`, `/Music/`, `/Public/`, `/Applications/`,
  `/.Trash/`) so any `$HOME`-rooted walk skips protected locations. Verified: a
  `$HOME` walk now produces no prompts and repo searches are unaffected.
- `~/dots/.ignore` (committed): excludes agent-CLI runtime data such as
  `cursor/chats/`, `codex/computer-use/`, `codex/.tmp/`, `cdx-artifacts/`.

## Evidence that can disappear without this chat

- A Cursor CLI update replaces `rg` under a new version directory and the shim
  is gone. Reinstall it: move the new `rg` to `rg.real`, write the wrapper as
  `rg` (copy from the previous version if still present).
- `/tmp/rg-argv.log` can vanish on reboot. If it is missing and the shim is
  still in place, the next `rg` invocation will recreate it.

## Workflow

1. Check for prompts since 2026-09-14 10:21:

   ```sh
   /usr/bin/log show --last 1d --predicate 'subsystem == "com.apple.TCC"' \
     --info --style compact | rg 'AUTHREQ_PROMPTING.*AppData'
   ```

2. If there are new prompts, find `/tmp/rg-argv.log` entries within a few
   seconds of each timestamp and read the `cwd` and `argv`. That identifies the
   offending search. Then reproduce it directly with `rg.real` and the same
   flags and cwd, confirming via the TCC log that it hits the file-provider
   domain. Skip to step 4.
3. If there are no new prompts, do not force it. Confirm the shim is still in
   place (a CLI update may have removed it; if so, reinstall it under the new
   version directory) and report that you are still waiting.
4. Fix at the narrowest level that holds: prefer an `.ignore` rule in the
   specific workspace, or removing whatever symlink or config makes the walk
   reach iCloud. Only if the walk root is genuinely uncontrollable, fall back
   to either granting Full Disk Access to the `rg` binary (a per-update manual
   step, since the path is version-pinned) or deleting the colocated `rg` so
   the CLI's resolver falls back to `/opt/homebrew/bin/rg` at a stable path
   (the resolver order is colocated, then `/usr/bin/rg`, `/usr/local/bin/rg`,
   `/opt/homebrew/bin/rg`, then a PATH lookup; there is no env override —
   `CURSOR_RIPGREP_PATH` is only exported to children).
5. Verify the fix by reproducing the original invocation and confirming no new
   TCC request appears in the log.
6. Remove the shim: delete `rg` and rename `rg.real` back to `rg`. Confirm
   `rg --version` works.
7. Commit any `~/dots` changes as focused commits. Do not commit agent runtime
   data; add ignore rules instead.

## Constraints

- Do not run `rg` over `$HOME` without `~/.ignore` in place; it triggers real
  dialogs for the user (Photos, Desktop, Downloads, Documents).
- Full Disk Access cannot be granted from the command line; SIP protects
  `TCC.db`. Instruct the user to drag the binary into System Settings instead.
- `~/.ignore` makes `rg` silently skip those directories, so any deliberate
  search there needs `--no-ignore`. Keep patterns anchored with a leading slash
  so same-named directories inside projects stay searchable.

## Report

State whether the trigger was captured. If it was, give the cwd and argv, the
path that reached app data, the fix applied, and how you verified it. If it was
not, say what is still pending and confirm the shim is intact.
