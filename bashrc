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
alias busy='cat /dev/urandom | hexdump -C | grep "ca fe"'
alias cmatrix='cmatrix -a'
alias grep='grep --color=auto'
alias j='jump'
alias ls='ls -lagsh'
alias pwgen='pwgen 32 --numerals --capitalize --secure --symbols'
alias qq='git status -sb'
alias sudo='sudo '
alias tree="tree -C"
alias v='vim'
alias vi='vim'

## tmux alias
alias tmn="tmux new -s"
alias tma="tmux attach -t"
alias tmd="tmux detach"
alias tml="tmux ls"
alias tms="tmux switch -t"

# Functions etc

# https://web.archive.org/web/20180103112636/http://jeroenjanssens.com/2013/08/16/quickly-navigate-your-filesystem-from-the-command-line.html
export MARKPATH=$HOME/.marks
function jump {
  cd -P "$MARKPATH/$1" 2>/dev/null || echo "No such mark: $1"
}
function mark {
  mkdir -p "$MARKPATH"; ln -s "$(pwd)" "$MARKPATH/$1"
}
function unmark {
  rm -i "$MARKPATH/$1"
}
function marks {
  \ls -l "$MARKPATH" | tail -n +2 | sed 's/  / /g' | cut -d' ' -f9- | awk -F ' -> ' '{printf "%-10s -> %s\n", $1, $2}'
}

# Creates a zip file of the form name_ddmmyy_hhmm_descripton.zip
# Usage: `zzip folder`
function zzip() {
  echo "Enter zip description" && read description;
  if [ ! -z "${description}" ]; then
    title=${1%/}_$(date +"%d%m%y_%H%M")_${description//[^a-zA-Z0-9]/_}
    zip -r ${title}.zip $1
    if [ $? -eq 0 ]; then
      echo
      echo "${title}.zip has been created!"
    else
      echo
      echo "ERROR: zzip has failed :("
    fi
  else
    echo "ERROR: You must provide a description for your zip file"
  fi
}

# Fires up vim with an empty markdown file of the form title_ddmmyy_hhmm.markdown
# Usage: `markdown title`
function markdown() {
  if [ ! -z "${1}" ]; then
    title=${@};
    vim ${title//[^a-zA-Z0-9]/_}_$(date +"%d%m%y_%H%M").markdown
  else
    echo
    echo "ERROR: You must provide a title for your Markdown file"
  fi
}

# Generates a heroku-style name
# Adjectives and nouns taken from: https://web.archive.org/web/20180103114041/https://gist.github.com/afriggeri/1266756
# Usage: `name`
function name() {

  # Output variable values
  local debug=0
  # Array of adjectives
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

  if [ ${debug} = 1 ]; then
    echo "  ⚡️  there are ${#adjectives[@]} adjectives"
    echo "  ⚡️  there are ${#nouns[@]} nouns"
    echo "  ⚡️  random is ${get_random}"
    echo "  ⚡️  adjective is ${get_adjective}"
    echo "  ⚡️  noun is ${get_noun}"
    echo "  ⚡️  number is ${get_number}"
  fi

  echo -e "Your name is \033[96m${get_adjective}-${get_noun}-${get_number}\033[0m"

}

# Generates a QR code given a string or URL
# Usage: `qr`
function qr() {
  # Check that qrencode is installed
  if ! [ -x "$(command -v qrencode)" ]; then
    echo "ERROR: qrencode is not installed: brew install qrencode then try again :)"
  fi

  local text_or_url="${1}"
  # echo "Enter text or URL" && read text_or_url
  if [ ! -z "${text_or_url}" ]; then
    local date=$(date +"%d%m%y_%H%M");
    qrencode \
      "${text_or_url}" \
      --output ~/qrcode_${date}.png \
      --size 10 \
      --foreground=ff66cc \
      --background=ffffff
  else
    echo "ERROR: You didn't enter anything";
  fi
}

# Creates a copy of a file and appends the ddmmyyy_hhmmss
# Usage: `version filename`
function version() {
  local debug=0
  local filename_with_extension=`echo ${1}`
  if [ -d "${filename_with_extension}" ]; then
    # TODO: There's no reason this couldnt work on directories other than I use
    # the `zzip` function for those
    echo "ERROR: version doesn't work on directories"
    exit 1
  else
    local filename_only=`echo ${filename_with_extension%.*}`
    local extension_only=`echo ${filename_with_extension} | awk -F . '{print $NF}'`
    local filename_with_version=`echo ${filename_only// /_}_$(date +"%d%m%y_%H%M%S").${extension_only}`
    if [ ${debug} = 1 ]; then
      echo "  ⚡️  filename_with_extension is ${filename_with_extension}"
      echo "  ⚡️  filename_only is ${filename_only}"
      echo "  ⚡️  extension_only is ${extension_only}"
      echo "  ⚡️  filename_with_version is ${filename_with_version}"
    fi

    cp -v "${filename_with_extension}" "${filename_with_version}"
    file ${filename_with_version}
  fi
}

foresight() {
  # Takes a string and spits out a sha256
  if [ ! -z "${@}" ]; then
    local foresight=`echo $(date +"%d/%m/%y @ %H:%M"): ${@}`
    local sha=`echo -n "${foresight}" | openssl sha256`
    echo
    echo "🔮 Your sha is:"
    echo -e "\t\033[36m${sha}\033[0m"
    echo
    echo "🔮 Prove it!"
    echo -e "\t\033[36mecho -n \"${foresight}\" | openssl sha256\033[0m"
    echo
  else
    echo "ERROR:  Please provide something you'd like to prove! For example:"
    echo "        foresight \"It's going to snow Christmas 2020\""
    echo "        Don't forget the double quotes"
  fi

}

archive() {
  # Replaces my own archive.org function which only now works sometimes.
  if [ ! -z "${@}" ]; then
    # create a working directory named with a timestamp
    local directory=$(date +"%d%m%y_%H%M%S")
    # takes the user-input URL and removes http/https, removes any trailing
    # slash and replaces other slashes with underscores
    local friendly_name=`echo ${@#*//} | sed -e 's#/$##' -e 's/\//_/g'`

    wget \
      --adjust-extension \
      --span-hosts \
      --convert-links \
      --no-directories \
      --timestamping \
      --page-requisites \
      --directory-prefix=/tmp/${directory} \
      ${@}

      mv -v /tmp/${directory} /tmp/${friendly_name}_${directory}

      # it's okay to use `junk-paths` as we're using `no-directories` with wget
      zip -rmj ~/Desktop/${friendly_name}_${directory}.zip /tmp/${friendly_name}_${directory}

  else
    echo "ERROR: Please enter a URL that you would like to create an archive for"
  fi
}





export PATH="$HOME/.npm-packages/bin:$PATH"
