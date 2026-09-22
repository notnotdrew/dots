---
name: starting-herdr-work
description: >-
  Opens a Herdr child worktree and names its sidebar for the task: workspace
  label = item, $note = project (reuse existing project names). Use when the
  user says "work on …", "tidy …", starts a Linear ticket in Herdr, or asks to
  spin up a worktree workspace for a task. Also decides when a request is just
  a command to dispatch, such as "start any open prrr reviews", and needs no
  workspace at all.
---

# Starting Herdr work

Turn a short request into a focused child worktree whose Space sidebar reads:

1. **item** — what you're doing (`invite groups`, `daily view metric`, `tidy herdr`)
2. **project** — bucket reused across siblings (`CSV`, `Planhat`, `Herdr`)
3. **branch** — filled by the `drew.branch-token` plugin on focus

Requires `HERDR_ENV=1`. If unset, say you are not inside Herdr and stop.

## First: does this need a workspace at all?

Some requests are already a command. "Start any open prrr reviews" is
`prrr start --requested`, and prrr opens a workspace per PR on its own. When a
tool does the whole job, dispatch it and stop. No branch, no worktree, no agent.

`prrr list` prints what is waiting as `status`, `owner/repo`, `number`, `title`,
`url`, with status `new`, `rerun`, or `local`. It needs no terminal, so use it
to say what you started.

Only take this path when the tool covers the whole request. Anything that needs
a branch gets a worktree, named as below.

## Naming rules

| Field | Herdr surface | Rules |
| --- | --- | --- |
| item | workspace `--label` / rename | Short, lowercase sentence fragment. No project prefix. No ticket id. |
| project | `$note` via `report-metadata` | Title Case when it is a name (`Planhat`, `CSV`, `Herdr`). Reuse an existing sibling's spelling when the same bucket already exists. |
| branch | `herdr worktree create --branch` | Linear's own `branchName`, verbatim. Without a ticket, `drew/<item-slug>` (optional `YYYYMMDD` suffix). |

Do **not** use the old `project: item` compound label (`csv: invite groups`). Split them.

Transitional siblings may still look like `planhat` + note `daily view` (inverted) or `csv: invite groups`. When reusing a project name, normalize from those forms; when creating new workspaces, always use item-as-label + project-as-note.

### Derive item + project

1. **Linear ticket** (`PRO-123`, URL, or "work on PRO-123"):
   ```bash
   linear issue view PRO-123 --json --no-pager
   ```
   - branch: `.branchName` verbatim. Linear already produces `drew/pro-8934-push-daily-viewer-feedback-counts-to-planhat-companies`; never hand-roll it.
   - item: shorten `.title` to a few words (drop leading verbs like "Add"/"Fix" when the rest is clear).
   - project: reuse a matching sibling project first. Otherwise shorten `.project.name` to its distinctive word ("Sync user data to Planhat" → `Planhat`). Invent a bucket from the title only when there is no Linear project.
2. **Plain phrase** ("tidy herdr", "work on invite host"):
   - Split into item + project by judgment. "tidy herdr" → item `tidy`, project `Herdr`. "invite groups" with CSV siblings → item `invite groups`, project `CSV`.
   - If only one token and no clear project, use `Misc` only when siblings already use it; otherwise ask one short clarifying question.
3. **Reuse projects**: before inventing a name, scan open workspaces in the same repo:
   ```bash
   herdr workspace list
   ```
   Collect project candidates from `$note`, from `project: item` labels (left of `:`), and from inverted `label`+`$note` pairs. Match case-insensitively; keep the existing spelling.

## Workflow

Copy and check off:

```
- [ ] 1. Confirm Herdr + parent repo
- [ ] 2. Resolve item, project, branch
- [ ] 3. Create worktree workspace
- [ ] 4. Set $note (project)
- [ ] 5. Focus and confirm sidebar fields
```

### 1. Parent repo

Prefer the focused workspace's checkout, unless it is a scratch git dir under `/tmp` or `/var/folders`. Those are probes and test fixtures, so ask which repo instead. If the checkout is already a linked worktree, create against the repo's source workspace:

```bash
herdr workspace list
herdr worktree list --workspace "$HERDR_WORKSPACE_ID"
# or: herdr worktree list --cwd "$PWD"
```

Use `.result.source.source_workspace_id` as `--workspace` for create. Do not create a top-level duplicate of the main checkout.

### 2. Create

```bash
herdr worktree create \
  --workspace <source_workspace_id> \
  --branch "<branch>" \
  --path "<repo_root>.<branch with / replaced by ->" \
  --label "<item>" \
  --focus
```

Read `.result.workspace.workspace_id` and `.result.root_pane.pane_id` from the response.

Always pass `--path`. Herdr otherwise checks out under `~/.herdr/worktrees/`, while these repos keep worktrees beside the main checkout (`screensteps-live.drew-pro-8766-add-invite-groups-and-sites`), matching worktrunk.

Omit `--base` unless the user named a non-default base.

### 3. Set project note

Use the same metadata source as `herdr-note` so `prefix+shift+m` can edit it later:

```bash
herdr workspace report-metadata <workspace_id> \
  --source herdr-note \
  --token "note=<Project>"
```

### 4. Confirm

```bash
herdr workspace get <workspace_id>
```

Expect `label` = item and `tokens.note` = project. Branch text appears after focus via `drew.branch-token`; do not fake it with another token.

Tell the user the new workspace id, item, project, and branch in one short line. Then continue the requested work in that checkout unless they only asked to set up the space.

## Do not

- Rename or close workspaces you did not create unless asked.
- Put the project in the label or the item in `$note`.
- Invent a new spelling of an existing project (`csv` vs `CSV`).
- Run `herdr server stop` or kill Herdr.
- Create a worktree when the user only wanted a rename/note fix on an existing space — update that workspace in place instead.
- Create a worktree for a request an existing command already handles.

## Keybinding

`prefix+shift+s` focuses a persistent plain workspace named `start work`, creating
it at `~/.local/state/herdr-start-work` when needed, then runs
`~/bin/herdr-start-work` in its one pane. A second press while that pane is busy
only returns to it. The flow asks for the request, then runs a headless planning
agent that answers with one of two plans.

The planner receives no checkout hint: start-work is normally unrelated to the
workspace Drew just left, so it resolves `repo_root` from the request alone. A
plan that names a scratch git dir under `/tmp` or `/var/folders` is refused.
The workspace stays open after the command exits so the next intake can reuse
it. While the command runs, its Agents-panel row still makes the pane findable
after focus moves to a new worktree.

A worktree plan carries the JSON fields above, and the script creates the worktree, sets `$note`, focuses the workspace, and starts a `cursor` agent on the task in its root pane.

A commands plan is `{"kind":"commands","summary":…,"commands":[…]}`. The script shows it, runs it, and exits without opening anything. Only `prrr` can be dispatched, and only as literal arguments, so a plan cannot act as a shell.

`prefix+shift+y` shares the same dedicated workspace and one-at-a-time behavior,
with a fixed request: item `tidy`, project `Herdr`, repo `~/dots`, branch
`drew/tidy-herdr-YYYYMMDD`. It does not ask.

Use the manual steps above when the user is already chatting with you. Point them at the keybinding when they want to launch work without an open session.

## In-place fix

If they point at an existing child and want the new layout:

```bash
herdr workspace rename <id> "<item>"
herdr workspace report-metadata <id> --source herdr-note --token "note=<Project>"
```
