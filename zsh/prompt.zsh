# Load vcs_info for Git integration
autoload -Uz vcs_info
zstyle ':vcs_info:*' enable git

# Define the faces array with different faces
faces=(
  "._."
  "( ‾́ ◡ ‾́ )"
  "(o˘◡˘o)"
  "( ˙꒳​˙ )"
  "(•_•)"
  "ヾ(⁍̴̆◡⁍̴̆。)ノ"
  "✖‿✖"
  "(/°(ｴ)°)/"
  "ʕ ᵔᴥᵔ ʔ"
  "(~˘▽˘)~"
  "(｢• ω •)｢"
  "(•́ _ʖ •̀)"
  "(⌐■_■)"
  "∠( ᐛ 」∠)_"
  "ʘ‿ʘ)╯"
  "･д･)ﾉ"
  "･ω･)"
  "(^_−)☆ "
  "(⊃｡•́‿•̀｡)⊃"
  "(・_・)ノ"
  "( ° ∀ ° )ﾉﾞ"
  "(*°ｰ°)ﾉ"
  "(¬_¬ )"
  "┐( ˘_˘ )┌"
  "ᕕ( ᐛ )ᕗ"
  "(;;;*_*)"
  "▓▒░(°◡°)░▒▓"
  "(／。＼)"
  "(×_×)"
  "(｡•́︿•̀｡)"
  "ヽ(‵﹏´)ノ"
  "(︶︹︺)"
  "( ◡‿◡ *)"
  "(*/_＼)"
  "♡ ( ◡‿◡ )"
  "(◕‿◕)♡ "
  "( °◡°)"
  "ヽ(♡‿♡)ノ"
  "(„• ֊ •„)"
  "٩(｡•́‿•̀｡)۶"
  "( ‾́ ◡ ‾́ )"
  "(ﾉ◕ヮ◕)ﾉ*:･ﾟ✧"
  "( ᐛ )و"
  "(^._.^)ﾉ"
  "~(=^–^)"
  "◕ᴥ◕"
  "乁(•_•)ㄏ"
  "| ･ 〰 ･|"
)

# Generate a random face index once per session
facesize=${#faces[@]}
faceindex=$((RANDOM % facesize))

# Precommand hook to update face color based on Git status
precmd() {
  vcs_info

  # Determine color based on Git status
  if [[ -n $(git status --porcelain 2> /dev/null) ]]; then
    face_color="%F{yellow}"
  else
    face_color="%F{green}"
  fi
}

# Enable prompt substitution and set the prompt
setopt PROMPT_SUBST
PROMPT='${face_color}${faces[$faceindex]} %f%1~%F{cyan}${vcs_info_msg_0_}%f ❯ '

# Set vcs_info to display the branch name
zstyle ':vcs_info:git:*' formats ':%b'
