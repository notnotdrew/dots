# Rupa Z
# https://formulae.brew.sh/formula/z
#
. $HOMEBREW_PREFIX/etc/profile.d/z.sh

alias ..='cd ..'
alias ...='cd ../..'
alias ....='cd ../../..'

# Git tab completion
# https://git-scm.com/book/en/v2/Appendix-A:-Git-in-Other-Environments-Git-in-Zsh
#
autoload -Uz compinit && compinit
