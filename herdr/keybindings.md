# Herdr keys worth using

Prefix is `ctrl+b`. `prefix+?` lists every active binding; this file is the
shortlist worth building muscle memory for. Open it with `prefix+u`.

## Use these often

    prefix+w          spaces panel (navigate mode)
    prefix+g          session navigator, searches everything
    prefix+shift+g    worktree: switch / create from default branch
    prefix+shift+s    workspace: start work on a task
    prefix+shift+y    workspace: tidy herdr
    prefix+o          jump to the pane that raised the last notification
    prefix+b          toggle sidebar
    prefix+z          zoom the focused pane
    prefix+[          copy mode

## Agents and navigation

    ctrl+shift+up     previous agent in the Agents panel
    ctrl+shift+down   next agent in the Agents panel
    prefix+h/j/k/l    move between panes
    prefix+n / p      next / previous tab
    prefix+1..9       jump to tab 1-9
    prefix+c          new tab
    prefix+v          split right
    prefix+minus      split down

## Plugin shortcuts

    prefix+a          annotate: capture selection
    prefix+m          annotate: manage annotations
    prefix+d          annotate: review documents in this folder
    prefix+shift+c    annotate: copy annotations as context
    prefix+shift+o    annotate: review the agent's last reply
    prefix+f          golden ratio: resize the focused pane
    prefix+shift+r    worktree: switch / create including remotes
    prefix+shift+d    worktree: remove
    prefix+shift+m    workspace: set note
    prefix+u          this cheatsheet

## Recently added or discussed

    2026-09-18  ctrl+shift+up / ctrl+shift+down step the Agents panel. Herdr
                has no navigate-mode surface for agents, and iTerm composes
                alt chords into characters because Option Key Sends is
                Normal, so modified arrows are the chord that survives.
    2026-09-18  annotate.open moved from prefix+o to prefix+d, leaving
                prefix+o to herdr's builtin open_notification_target.
    2026-09-18  reinstalled the annotate plugin. prefix+a had been erroring
                because the plugin was missing from the registry.
    2026-09-18  prefix+shift+g / s / y promoted to "use these often":
                worktree switch, start work, tidy herdr.

## Worth knowing

    prefix+shift+r is worktrunk, not herdr's reload_config default, so
    reload from a shell instead: herdr server reload-config
