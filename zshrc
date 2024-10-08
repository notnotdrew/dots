# Rupa Z
# https://formulae.brew.sh/formula/z
#
. $HOMEBREW_PREFIX/etc/profile.d/z.sh

alias ....='cd ../../..'
alias ...='cd ../..'
alias ..='cd ..'
alias ag='rg'
alias asdfpi="cut -d' ' -f1 .tool-versions|xargs -I{} asdf plugin add {} && asdf install"
alias vi='nvim'
alias vim='nvim'
alias zrc='nvim ~/.zshrc'

# Git tab completion
# https://git-scm.com/book/en/v2/Appendix-A:-Git-in-Other-Environments-Git-in-Zsh
#
autoload -Uz compinit && compinit
