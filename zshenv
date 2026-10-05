# Add ~/bin to PATH if it exists and isn't already included
[[ -d "$HOME/bin" && ":$PATH:" != *":$HOME/bin:"* ]] && export PATH="$HOME/bin:$PATH"
[[ -d "$HOME/.local/bin" && ":$PATH:" != *":$HOME/.local/bin:"* ]] && export PATH="$HOME/.local/bin:$PATH"

eval "$(/opt/homebrew/bin/brew shellenv)"

# shellenv prints nothing when /opt/homebrew/bin is already first on PATH. The
# Herdr server is started that way, so a pane would have no HOMEBREW_PREFIX
# and ~/.zshrc would try to source /etc/profile.d/z.sh.
if [[ -z ${HOMEBREW_PREFIX:-} && -d /opt/homebrew ]]; then
  export HOMEBREW_PREFIX="/opt/homebrew"
  export HOMEBREW_CELLAR="/opt/homebrew/Cellar"
  export HOMEBREW_REPOSITORY="/opt/homebrew"
  export INFOPATH="/opt/homebrew/share/info${INFOPATH:+:$INFOPATH}"
  site="$HOMEBREW_PREFIX/share/zsh/site-functions"
  if [[ -d $site ]] && (( ! ${fpath[(Ie)$site]} )); then
    fpath=("$site" $fpath)
  fi
  unset site
fi

# ScreenSteps: the app API key is in config/honeybadger.yml. Booting
# RAILS_ENV=staging on a laptop still reports unless this is false.
export HONEYBADGER_REPORT_DATA=false

export DOTS_PATH="$HOME/dots"
export EDITOR="vim"
export KEYTIMEOUT=1 # Quicker switch between insert/command
export VISUAL="$EDITOR"

eval "$(/opt/homebrew/bin/brew shellenv)"
