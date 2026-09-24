# Herdr erases the visible screen in place when it gets ED2, so the rows on
# screen when you clear never reach the pane's scrollback, and ncurses `clear`
# also emits E3 (\e[3J), which throws away the scrollback that was already
# there. iTerm scrolls the screen into history instead. Do that first, then
# erase only the viewport.
#
# Printing exactly $LINES newlines scrolls off precisely the rows in use: the
# ones below the cursor land on blank rows, which the erase wipes before they
# can reach scrollback.
scroll-screen-into-scrollback() {
  printf '\n%.0s' {1..$LINES}
}

clear() {
  scroll-screen-into-scrollback
  printf '\e[H\e[2J'
}

scroll-and-clear-screen() {
  scroll-screen-into-scrollback
  zle clear-screen
}
zle -N scroll-and-clear-screen

# zsh-vi-mode rebuilds the keymaps at its first precmd, which is after this file
# is sourced, so re-bind from its hook when the plugin is present.
bind-scroll-and-clear-screen() {
  bindkey '^L' scroll-and-clear-screen
}
bind-scroll-and-clear-screen
zvm_after_init_commands+=(bind-scroll-and-clear-screen)
