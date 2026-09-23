# shellcheck shell=bash
# Make a Herdr pane command findable from anywhere in the session.
#
# Sourced by the type = "pane" commands in ~/dots/herdr/config.toml.
#
# Those panes are not ephemeral. A pane command splits whichever workspace
# happened to be focused and holds that split until the command exits, so a
# flow sitting on a prompt has taken over the layout it was launched in.
# Nothing in Herdr lists plain panes across workspaces: the Spaces panel shows
# workspaces and the Agents panel shows recognized agents, so a waiting split
# is invisible from any other workspace. herdr-start-work runs for a minute or
# more and never takes the screen, so by the time it needs an answer Drew is
# usually somewhere else.
#
# Reporting the pane as an agent puts it in the surface built for this exact
# question. The Agents panel lists it with its workspace and tab,
# ctrl+shift+up / ctrl+shift+down step onto it, and the workspace's Spaces
# row rolls its state up. A toast raised by hand is no substitute:
# NotificationShowParams carries a title, body, position and sound but no
# pane, so prefix+o would have nothing to open.
#
# A pane command's pane closes the moment the command exits and takes the row
# with it, but these scripts also run by hand from a shell pane that outlives
# them, so release on exit rather than leaving that pane named and reported.

HERDR_PANE_AGENT_SOURCE=herdr-cmd
HERDR_PANE_AGENT_LABEL=

# Name this pane and claim a row in the Agents panel. State defaults to
# blocked because these panes exist to be answered. No-op outside Herdr.
# Labels follow the agent-name rule: [a-z][a-z0-9_-]{0,31}.
herdr_pane_agent() {
  HERDR_PANE_AGENT_LABEL="$1"
  [ -n "${HERDR_PANE_ID:-}" ] || return 0

  # A manual pane name wins over a reported agent label in the split border,
  # which is off by default, so rename as well to label the pane in place.
  "${HERDR_BIN_PATH:-herdr}" pane rename "$HERDR_PANE_ID" \
    "$HERDR_PANE_AGENT_LABEL" >/dev/null 2>&1 || true
  herdr_pane_state "${2:-blocked}"
}

# working while a step runs, blocked while the pane waits on the keyboard.
# Display state only: never let a failed report stop the flow it describes.
herdr_pane_state() {
  [ -n "${HERDR_PANE_ID:-}" ] && [ -n "$HERDR_PANE_AGENT_LABEL" ] || return 0

  "${HERDR_BIN_PATH:-herdr}" pane report-agent "$HERDR_PANE_ID" \
    --source "$HERDR_PANE_AGENT_SOURCE" \
    --agent "$HERDR_PANE_AGENT_LABEL" \
    --state "$1" >/dev/null 2>&1 || true
}

# Give the pane back its own name and lifecycle state. Callers run this from
# an EXIT trap; exec skips EXIT traps, which is what keeps the row unbroken
# when one of these scripts hands off to another.
herdr_pane_agent_release() {
  [ -n "${HERDR_PANE_ID:-}" ] && [ -n "$HERDR_PANE_AGENT_LABEL" ] || return 0

  "${HERDR_BIN_PATH:-herdr}" pane release-agent "$HERDR_PANE_ID" \
    --source "$HERDR_PANE_AGENT_SOURCE" \
    --agent "$HERDR_PANE_AGENT_LABEL" >/dev/null 2>&1 || true
  "${HERDR_BIN_PATH:-herdr}" pane rename "$HERDR_PANE_ID" --clear \
    >/dev/null 2>&1 || true
  HERDR_PANE_AGENT_LABEL=
}
