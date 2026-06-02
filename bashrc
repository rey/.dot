# exports
export HISTTIMEFORMAT="%F %T "
export PS1="\[\e[00;37m\]\h \w \[\e[0m\]\[\e[00;35m\]\\$\[\e[0m\]\[\e[00;37m\] \[\e[0m\]"

# tmux overwrites TERM_PROGRAM to "tmux" on start, hiding the real outer
# terminal from inner programs. Many TUI tools branch on TERM_PROGRAM
# for per-terminal palette/capability tweaks, so capture it in the outer
# shell and restore it inside tmux. If the outer terminal doesn't set
# TERM_PROGRAM, we leave tmux's value alone.
if [ -z "$TMUX" ]; then
  export OUTER_TERM_PROGRAM="$TERM_PROGRAM"
elif [ -n "$OUTER_TERM_PROGRAM" ]; then
  export TERM_PROGRAM="$OUTER_TERM_PROGRAM"
fi

export EDITOR=/usr/bin/vim           # set vim to be the default editor
export VISUAL=/usr/bin/vim           # set vim to be the default editor

set -o vi                            # use vim commands in bash

# alias
alias bb="source ~/.bashrc"
alias bv="vim ~/.bashrc"
alias grep="grep --color=auto"
alias ls="ls -laghtG"
alias nosleep="caffeinate -d -t 3600"
alias pwgen="pwgen 32 --numerals --capitalize --secure --symbols"
alias qq="git status -sb"
alias sudo="sudo "
alias tree="tree -C"
alias uuid="uuidgen | tr '[:upper:]' '[:lower:]'"
alias v="vim"
alias vi="vim"
alias wav="yt-dlp --extract-audio --audio-format wav --audio-quality 0 --paths ~/Desktop/_samples/ --output \"%(title)s.%(ext)s\""
# tmux alias
alias tmn="tmux new-session -s"
alias tma="tmux attach-session -t"
alias tmd="tmux detach-client"
alias tml="tmux list-sessions"
alias tms="tmux switch-client -t"
alias tmk="tmux kill-session -t"
alias tmr="tmux rename-session -t"

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

  # Adjectives and nouns taken from: https://web.archive.org/web/20180103114041/https://gist.github.com/afriggeri/1266756
  local adjectives=(autumn hidden bitter misty silent empty dry dark summer icy delicate quiet white cool spring winter patient twilight dawn crimson wispy weathered blue billowing broken cold damp falling frosty green long late lingering bold little morning muddy old red rough still small sparkling shy wandering withered wild black young holy solitary fragrant aged snowy proud floral restless divine)
  local nouns=(waterfall river breeze moon rain wind sea morning snow lake sunset pine shadow leaf dawn glitter forest hill cloud meadow sun glade bird brook butterfly bush dew dust field fire flower firefly feather grass haze mountain night pond darkness snowflake silence sound sky shape surf thunder violet water wildflower wave water resonance sun wood dream cherry tree fog frost voice paper)

  local adjective=${adjectives[$((RANDOM % ${#adjectives[@]}))]}
  local noun=${nouns[$((RANDOM % ${#nouns[@]}))]}
  local number=$((RANDOM % 9000 + 1000))

  echo "${adjective}-${noun}-${number}"
}

note() {
  # About: Add a note to ~/notes.txt
  # Usage: `note "I miss the old Kanye"`

  local file_name="notes.txt"
  local file=~/"${file_name}"

  # ensure the notes file exists
  [[ -f "$file" ]] || touch "$file"

  # dispatch on the first argument; anything unrecognised is a note
  case "$1" in
    # shows the last 10 notes using `head`
    --read | -r)
      echo -e "${bold}${underline}Showing last 10 notes${reset}"
      echo
      head -10 "$file"
      ;;
    # shows all notes using `less`
    --read-all | -ra)
      less "$file"
      ;;
    # open the notes file using ${EDITOR}
    --edit | -e)
      "${EDITOR:-vi}" "$file"
      ;;
    --help | -h)
      echo "Usage: note \"I miss the old Kanye\""
      echo "Options:"
      echo "  -e, --edit      Open the notes file using ${EDITOR:-vi}"
      echo "  -h, --help      This help text"
      echo "  -r, --read      Show the last 10 notes"
      echo "  -ra, --read-all Show all notes"
      echo "  -v, --version   Show version number"
      ;;
    --version | -v)
      echo "note 1.0"
      ;;
    # no input
    "")
      echo "note: try \"note --help\""
      ;;
    # anything else: prepend a timestamped note
    *)
      local tmp
      tmp=$(mktemp) && \
        printf '%s %s: %s\n' "$(date +"%Y-%m-%dT%H:%M:%S%z")" "${HOSTNAME}" "$*" \
          | cat - "$file" > "$tmp" && mv "$tmp" "$file"
      ;;
  esac
}

rec() {
  # About: Record an adhoc meeting transcript using yap
  # Usage: `rec`

  if ! [[ -x "$(command -v yap)" ]]; then
    echo "ERROR: yap is not installed: brew install yap then try again"
    return 1
  fi

  local timestamp=$(date +'%Y-%m-%d-%H-%M')
  local outfile=~/Documents/Meetings/Adhoc\ Transcriptions/${timestamp}-adhoc-recording.vtt.txt

  read -p "Attendees (Enter to skip): " attendees

  yap listen-and-dictate --vtt --mic-label Rey --system-label 'Meeting Participant(s)' > "$outfile"

  if [[ -n "$attendees" ]]; then
    printf '\nNOTE\nAttendees: %s\n' "$attendees" >> "$outfile"
  fi

  echo "Saved: $outfile"
  open ~/Documents/Meetings/Adhoc\ Transcriptions
}

qr() {
  # About: Generates a QR code given a string or URL and puts it in the ~/Desktop folder"
  # Usage: `qr "https://example.com`

  # If qrencode is not installed then throw an error
  if ! [[ -x "$(command -v qrencode)" ]]; then
    echo "ERROR: qrencode is not installed: brew install qrencode then try again"
  fi

  local text_or_url="${1}"
  if [[ ! -z "${text_or_url}" ]]; then
    local date=$(date +"%d%m%y_%H%M%S")
    local file_name=qr_${date}
    qrencode \
      "${text_or_url}" \
      --margin=0 \
      --output ~/Desktop/${file_name}.png \
      --size 10 \
      --foreground=ffffff \
      --background=9370db

    if [[ "$(uname)" == "Darwin" ]]; then
      open ~/Desktop/${file_name}.png
    fi
  else
    echo "Usage: qr \"https://example.com\"";
  fi
}

track() {

  # Get current date in YYYY-MM-DD format
  current_date=$(date +"%Y-%m-%d")

  # Check if at least one argument is provided
  if [ $# -eq 0 ]; then
    # No argument provided, prompt for input
    read -p "Enter project name: " project_name
  else
    # Use the first argument as input
    project_name="$1"
  fi

  # Remove spaces and replace with hyphens in project name
  project_filename="${current_date}-${project_name// /-}"

  # Loop until user confirms project filename
  while true; do
    echo "Your project filename will be: ${project_filename}"

    # Prompt for confirmation (y/N)
    read -p "Are you happy with this filename (y/N)? " confirm

    case "$confirm" in
      [Yy]*)  # User confirms, exit loop
        break
        ;;
      [Nn]*)  # User wants to edit, prompt for new name
        read -p "Enter a new project name: " new_name
        project_name="$new_name"
        project_filename="${current_date}-${project_name// /-}"
        ;;
      *) echo "Invalid input. Please enter 'y' or 'N'." ;;
    esac
  done

  # Base path for project directory
  base_dir="/Volumes/REYREYREY/New projects"

  # Create project directory structure with filename embedded
  mkdir -p "${base_dir}/${project_filename}"

  # Notes file
  touch "${base_dir}/${project_filename}/${project_filename}.txt"

  # MPC
  mkdir -p "${base_dir}/${project_filename}/MPC"

  # create file to click on: `.xpj` file so it will show up in MPC file explorer
  touch "${base_dir}/${project_filename}/MPC/${project_filename}.xpj"

  # A5n
  mkdir -p "${base_dir}/${project_filename}/A5n"

  # create file to click on
  touch "${base_dir}/${project_filename}/A5n/${project_filename}"

  echo "Project directory '${project_filename}' created successfully!"
}

export PATH=/opt/homebrew/bin:$PATH
