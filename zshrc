. $HOMEBREW_PREFIX/etc/profile.d/z.sh # https://formulae.brew.sh/formula/z

alias ....='cd ../../..'
alias ...='cd ../..'
alias ..='cd ..'
alias ag='rg'
alias asdfpi="cut -d' ' -f1 .tool-versions|xargs -I{} asdf plugin add {} && asdf install"
alias g='git'
alias vi='nvim'
alias vim='nvim'
alias zrc='nvim ~/.zshrc'

autoload -Uz compinit && compinit # Load completions
_comp_options+=(globdots) # include dot files for completions

bindkey -v

source $DOTS_PATH/zsh/prompt.zsh
