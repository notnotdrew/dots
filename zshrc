. $HOMEBREW_PREFIX/etc/profile.d/z.sh # https://formulae.brew.sh/formula/z
. $HOMEBREW_PREFIX/opt/asdf/libexec/asdf.sh https://formulae.brew.sh/formula/asdf

alias ....='cd ../../..'
alias ...='cd ../..'
alias ..='cd ..'
alias ag='rg'
alias asdfpi="cut -d' ' -f1 .tool-versions|xargs -I{} asdf plugin add {} && asdf install"
alias be='bundle exec'
alias g='git'
alias ivm='nvim'
alias ls='ls -lahGp' # one entry/line, all files, color allowed, directory indicator
alias nv='nvim'
alias rk='bin/rake'
alias vi='nvim'
alias vim='nvim'
alias zrc='nvim ~/.zshrc'

autoload -Uz compinit && compinit # Load completions
_comp_options+=(globdots) # include dot files for completions

bindkey -v

eval "$(direnv hook zsh)"
eval "$(thefuck --alias)"

source $DOTS_PATH/zsh/color.zsh
source $DOTS_PATH/zsh/prompt.zsh
source $DOTS_PATH/zsh/toggle_cursor.zsh
