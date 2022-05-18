# $TMUX variable
if [ -z $TMUX ]; then
  # $TMUX isn't set
  export TERM=xterm-256color
else
  # $TMUX is set
  export TERM=screen-256color
fi

# ps1
export PS1="\[\e[00;37m\]\h \w \[\e[0m\]\[\e[00;35m\]\\$\[\e[0m\]\[\e[00;37m\] \[\e[0m\]"

EDITOR=/usr/bin/vim           # set vim to be the default editor
VISUAL=/usr/bin/vim           # set vim to be the default editor

set -o vi                     # use vim commands in bash

# alias
alias bb="source ~/.bashrc"
alias bv="vim ~/.bashrc"
alias grep="grep --color=auto"
alias ls="ls -lagsh"
alias pwgen="pwgen 32 --numerals --capitalize --secure --symbols"
alias qq="git status -sb"
alias sudo="sudo "
alias tree="tree -C"
alias v="vim"
alias vi="vim"

# tmux alias
alias tmn="tmux new -s"
alias tma="tmux attach -t"
alias tmd="tmux detach"
alias tml="tmux ls"
alias tms="tmux switch -t"
alias tmk="tmux kill-session -t"

# Functions

foresight() {
  # About: Stupid function that takes a string and spits out a sha256
  # Usage: `foresight "It's going to snow Christmas 2020"

  # If a string is provided
  if [[ ! -z "${@}" ]]; then
    local foresight=`echo $(date +"%Y-%m-%dT%H:%M:%S%z"): ${@}`
    local md5=`echo -n "${foresight}" | openssl md5`
    echo
    echo "Your hash is:"
    echo
    echo "  ${md5}"
    echo
    echo "Here is your receipt"
    echo
    echo "  echo -n \"${foresight}\" | openssl md5"
    echo
  else
    echo "Usage: foresight \"It's going to snow Christmas 2020\""
  fi
}

name() {
  # About: Generates a heroku-style name
  # Usage: `name`

  local debug=0
  # Array of adjectives. Adjectives and nouns taken from: https://web.archive.org/web/20180103114041/https://gist.github.com/afriggeri/1266756
  local adjectives=(autumn hidden bitter misty silent empty dry dark summer icy delicate quiet white cool spring winter patient twilight dawn crimson wispy weathered blue billowing broken cold damp falling frosty green long late lingering bold little morning muddy old red rough still small sparkling shy wandering withered wild black young holy solitary fragrant aged snowy proud floral restless divine)
  # Array of nouns
  local nouns=(waterfall river breeze moon rain wind sea morning snow lake sunset pine shadow leaf dawn glitter forest hill cloud meadow sun glade bird brook butterfly bush dew dust field fire flower firefly feather grass haze mountain night pond darkness snowflake silence sound sky shape surf thunder violet water wildflower wave water resonance sun wood dream cherry tree fog frost voice paper)

  local get_random=$((1000 + $RANDOM % 9999))
  # Get a random adjective
  local get_adjective=${adjectives[${get_random} % ${#adjectives[@]}]}
  # Get a random noun
  local get_noun=${nouns[${get_random} % ${#nouns[@]}]}
  # Get the last 4 digits of ${get_random}
  local get_number=`echo ${get_random} | tail -c 5`

  if [[ ${debug} = 1 ]]; then
    echo "  ⚡️  there are ${#adjectives[@]} adjectives"
    echo "  ⚡️  there are ${#nouns[@]} nouns"
    echo "  ⚡️  random is ${get_random}"
    echo "  ⚡️  adjective is ${get_adjective}"
    echo "  ⚡️  noun is ${get_noun}"
    echo "  ⚡️  number is ${get_number}"
  fi

  echo "${get_adjective}-${get_noun}-${get_number}"
}

note() {
  # About: Add a note to ~/notes.txt
  # Usage: `note "I miss the old Kanye"`

  # name of notes file
  local file_name="notes.txt"
  # assign any user input to `new_note` variable
  local new_note=${@}

  # check for notes file
  if [[ ! -f "~/${file_name}" ]]; then
    touch ~/${file_name}
  fi

  # if not a string of zero length
  if [[ ! -z "${new_note}" ]]; then

    # if there is only 1 word, check if it's a command
    if [[ "${#}" == 1 ]]; then
      case ${new_note} in
        # shows the last 10 notes using `head`
        --read | -r)
            echo -e "${bold}${underline}Showing last 10 notes${reset}"
            echo
            head -10 ~/${file_name}
            local is_a_command=1
        ;;
        # shows all notes using `less`
        --read-all | -ra)
            less ~/${file_name}
            local is_a_command=1
        ;;
        # open the notes file using ${EDITOR}
        --edit | -e)
            ${EDITOR} ~/${file_name}
            local is_a_command=1
        ;;
        --help | -h)
            echo "Usage: note \"I miss the old Kanye\""
            echo "Options:"
            echo "  -e, --edit      Open the notes file using ${EDITOR}"
            echo "  -h, --help      This help text"
            echo "  -r, --read      Show the last 10 notes"
            echo "  -ra, --read-all Show all notes"
            echo "  -v, --version   Show version number"
            local is_a_command=1
        ;;
        --version | -v)
          echo "note 1.0"
          local is_a_command=1
        ;;
      esac
    fi

    # if the note is not a command
    if [[ "${is_a_command}" != 1 ]]; then
      echo "$(date +"%Y-%m-%dT%H:%M:%S%z") ${HOSTNAME}: ${new_note}" | cat - ~/${file_name} > temp && mv temp ~/${file_name}
    fi

  # if there are no words
  else
    echo "note: try \"note --help\""
  fi
}

qr() {
  # About: Generates a QR code given a string or URL and puts it in the ~/Desktop folder"
  # Usage: `qr "https://example.com`

  # Check that qrencode is installed
  if ! [[ -x "$(command -v qrencode)" ]]; then
    echo "ERROR: qrencode is not installed: brew install qrencode then try again"
  fi

  local text_or_url="${1}"
  if [[ ! -z "${text_or_url}" ]]; then
    local date=$(date +"%d%m%y_%H%M%S");
    local file_name=qr_${date}_`hash 6`
    qrencode \
      "${text_or_url}" \
      --margin=1 \
      --output ~/Desktop/${file_name}.png \
      --size 10 \
      --foreground=ff66cc \
      --background=ffffff

    if [[ "$(uname)" == "Darwin" ]]; then
      open ~/Desktop/${file_name}.png
    fi
  else
    echo "Usage: qr \"https://example.com\"";
  fi
}

export PATH="$HOME/.npm-packages/bin:$PATH"
