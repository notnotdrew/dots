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

  # Worktrunk names worktrees "<repo>.<branch>" (slashes become dashes), which
  # repeats the branch that vcs_info already shows. Drop the suffix.
  prompt_dir=${(%):-%1~}
  local branch=${vcs_info_msg_0_#:}
  if [[ -n $branch ]]; then
    prompt_dir=${prompt_dir%.${branch}}
    prompt_dir=${prompt_dir%.${branch//\//-}}
  fi

  # Truncate long branch names for the prompt (keep the ticket-ish prefix).
  prompt_branch=
  if [[ -n $branch ]]; then
    local max_branch_len=26
    if (( ${#branch} > max_branch_len )); then
      prompt_branch=":${branch[1,max_branch_len-1]}…"
    else
      prompt_branch=":$branch"
    fi
  fi
}

# Enable prompt substitution and set the prompt
setopt PROMPT_SUBST
PROMPT='${face_color}${faces[$faceindex]} %f${prompt_dir}%F{cyan}${prompt_branch}%f ❯ '

# Set vcs_info to display the branch name
zstyle ':vcs_info:git:*' formats ':%b'
