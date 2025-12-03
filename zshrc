. $HOMEBREW_PREFIX/etc/profile.d/z.sh # https://formulae.brew.sh/formula/z

alias ....='cd ../../..'
alias ...='cd ../..'
alias ..='cd ..'
alias ag='rg'
alias be='bundle exec'
alias brewup='brew update; brew upgrade; brew cleanup; brew doctor'
alias cat='bat'
alias g='git'
alias gti='git'
alias init='nvim ~/.config/nvim/init.lua'
alias ivm='vim'
alias ls='ls -lahGp' # one entry/line, all files, color allowed, directory indicator
alias npmr='npm run'
alias npr='npm run'
alias nv='nvim'
alias rk='bin/rake'
alias vi='vim'
alias vim='vim'
alias vrc='vim ~/.vimrc'
alias zrc='vim ~/.zshrc'

export BAT_THEME="base16"

autoload -Uz compinit && compinit # Load completions
_comp_options+=(globdots) # include dot files for completions

eval "$(direnv hook zsh)"
eval "$(hub alias -s)"
eval "$(thefuck --alias)"

for file in $DOTS_PATH/zsh/**/*.zsh; do
  [ -r "$file" ] && source "$file"
done

# Plugins (via https://github.com/mattmc3/zsh_unplugged)
zsh_plugin_repos=(
  jeffreytse/zsh-vi-mode
  zsh-users/zsh-completions
  zsh-users/zsh-syntax-highlighting
  zsh-users/zsh-autosuggestions
)

plugin-load $zsh_plugin_repos # See $DOTS_PATH/zsh/plugin-load.zsh

bindkey '^ ' autosuggest-accept # control + space to accept suggestions
export PATH="/opt/homebrew/bin:$PATH"
eval "$(mise activate zsh)"

# heroku autocomplete setup
HEROKU_AC_ZSH_SETUP_PATH=/Users/drewprice/Library/Caches/heroku/autocomplete/zsh_setup && test -f $HEROKU_AC_ZSH_SETUP_PATH && source $HEROKU_AC_ZSH_SETUP_PATH;
