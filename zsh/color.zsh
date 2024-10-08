export black=$(tput setaf 0)
export red=$(tput setaf 1)
export green=$(tput setaf 2)
export yellow=$(tput setaf 3)
export blue=$(tput setaf 4)
export magenta=$(tput setaf 5)
export cyan=$(tput setaf 6)
export white=$(tput setaf 7)
export lightblack=$(tput setaf 8)
export lightred=$(tput setaf 9)
export lightgreen=$(tput setaf 10)
export lightyellow=$(tput setaf 11)
export lightblue=$(tput setaf 12)
export lightmagenta=$(tput setaf 13)
export lightcyan=$(tput setaf 14)
export lightwhite=$(tput setaf 15)
export reset=$(tput sgr0)

colors() {
  # Define an associative array of colors with their names and codes
  local -A colors=(
    [black]=0
    [red]=1
    [green]=2
    [yellow]=3
    [blue]=4
    [magenta]=5
    [cyan]=6
    [white]=7
    [lightblack]=8
    [lightred]=9
    [lightgreen]=10
    [lightyellow]=11
    [lightblue]=12
    [lightmagenta]=13
    [lightcyan]=14
    [lightwhite]=15
  )

  # Iterate over each color and print the name with both foreground and background colors
  for color_name color_code in "${(@kv)colors}"; do
    # Print the color name with the foreground color
    echo -e "$(tput setaf $color_code)${color_name}${reset}"

    # Print the color name with the background color
    echo -e "$(tput setab $color_code)${color_name}${reset}"
  done
}
