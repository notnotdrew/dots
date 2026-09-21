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

    ctrl+shift+up     previous agent or pane command in the Agents panel
    ctrl+shift+down   next agent or pane command in the Agents panel
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

    2026-09-21  start-work and tidy now share a persistent "start work"
                workspace rooted at ~/.local/state/herdr-start-work. Their
                detached key commands focus or create it, then run the flow
                in its one pane; another press while it is busy only returns
                there. The workspace stays open for reuse, and the running
                pane still claims its Agents row after focus moves away.
                Planning no longer gets the previously focused checkout as a
                hint: it resolves the repo from the request, avoiding an
                unrelated default at the cost of requiring enough repo context.
    2026-09-21  start-work plans in ~/.local/state/herdr-start-work instead of
                whichever workspace the pane landed in. It used to read its
                own cwd for the repo to branch from, which is a scratch clone
                under /tmp often enough to matter. It is handed the launching
                checkout now, and refuses to branch from a scratch one. The
                last 20 plans stay in runs/ there.
    2026-09-21  the four pane commands now report themselves to the Agents
                panel while they run, labelled keys, note, start-work or
                tidy. Step to one with ctrl+shift+up / ctrl+shift+down: the
                row names the workspace and tab holding it, and blocked
                means it is waiting on a keypress. They release the row and
                the pane name on exit.
    2026-09-21  prefix+u, prefix+shift+m, prefix+shift+s and prefix+shift+y
                run as panes instead of popups. A popup is session-modal:
                nothing else reaches herdr until it closes, so a minute of
                planning in start-work locked out workspace switching. As
                panes they open a split in the current tab, close on exit,
                and can be left running while you go elsewhere.
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

    Custom commands come in three flavours: shell runs detached with no
    terminal, pane opens a split that closes when the command exits, and
    popup opens one session-modal window. Herdr 0.9 has no non-modal popup,
    so anything that waits on an agent or a long command belongs in a pane.
    Only popups take width and height; on a pane herdr warns and ignores
    them, and the pane is sized by the tab layout instead.

    A pane command is not ephemeral. It takes over the workspace it was
    launched in, holding a split there until it exits. Help and note still
    run this way. Start-work and tidy avoid unrelated layouts by launching
    into their persistent workspace instead. All four interactive scripts
    claim an Agents row while running: it names the workspace and pane after
    focus moves elsewhere and rolls their state up onto the Spaces row.
