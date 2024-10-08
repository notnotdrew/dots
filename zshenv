# Add ~/bin to PATH if it exists and isn't already included
[[ -d "$HOME/bin" && ":$PATH:" != *":$HOME/bin:"* ]] && export PATH="$HOME/bin:$PATH"

eval "$(/opt/homebrew/bin/brew shellenv)"

export DOTS_PATH="$HOME/dots"
export EDITOR="nvim"
export KEYTIMEOUT=1 # Quicker switch between insert/command
export VISUAL="nvim"
