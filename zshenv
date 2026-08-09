# Add ~/bin to PATH if it exists and isn't already included
[[ -d "$HOME/bin" && ":$PATH:" != *":$HOME/bin:"* ]] && export PATH="$HOME/bin:$PATH"
[[ -d "$HOME/.local/bin" && ":$PATH:" != *":$HOME/.local/bin:"* ]] && export PATH="$HOME/.local/bin:$PATH"

eval "$(/opt/homebrew/bin/brew shellenv)"

export DOTS_PATH="$HOME/dots"
export EDITOR="vim"
export KEYTIMEOUT=1 # Quicker switch between insert/command
export VISUAL="$EDITOR"

eval "$(/opt/homebrew/bin/brew shellenv)"
