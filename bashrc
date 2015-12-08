if [ "$COLORTERM" == "xfce4-terminal" ]; then
  export TERM=xterm-256color
fi

# ps1
export PS1="\[\e[00;37m\]\h \w \[\e[0m\]\[\e[00;35m\]\\$\[\e[0m\]\[\e[00;37m\] \[\e[0m\]"

EDITOR=/usr/bin/vim           # set vim to be the default editor
VISUAL=/usr/bin/vim           # set vim to be the default editor

set -o vi                     # use vim commands in bash

PATH=$PATH:$HOME/.rvm/bin     # Add RVM to PATH for scripting

# alias

alias busy='cat /dev/urandom | hexdump -C | grep "ca fe"'
alias grep='grep --color=auto'
alias j='jump'
alias ip='ifconfig | grep "inet " | grep -v 127.0.0.1 | cut -d\  -f2'
alias ls='ls -lags'
alias nano='vim'
alias qq='git status -sb'
alias reboot='shutdown -r now'
alias sing='ruby ~/.dot/tools/spark-ping'
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

# external

# http://jeroenjanssens.com/2013/08/16/quickly-navigate-your-filesystem-from-the-command-line.html
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

# https://gist.github.com/atomotic/721aefe8c72ac095cb6e
# usage: `archive http://google.com`
function archive() { curl -s -I https://web.archive.org/save/$* | grep Content-Location | awk '{print "https://web.archive.org"$2}'; }
# creates a zip file of the form name_ddmmyy_hhmm_descripton.zip
# usage: `zzip folder`
function zzip() {
  echo "Enter zip description" && read description;
  if [ "$description" != "" ];
    then
      title=${1%/}_$(date +"%d%m%y_%H%M")_${description//[^a-zA-Z0-9]/_};
      zip -r ${title}.zip $1;
      if [ $? -eq 0 ];
        then
          echo
          echo "${title}.zip has been created!";
        else
          echo
          echo "ERROR: zzip has failed :(";
      fi
    else
      echo "ERROR: You must provide a description for your ZIP";
  fi
}

# creates a tar archive of the form name_ddmmyy_hhmm_description.tar.gz
# usage `ttar folder`
function ttar() {
  echo "Enter tar.gz description" && read description;
  if [ "$description" != "" ];
    then
      title=${1%/}_$(date +"%d%m%y_%H%M")_${description//[^a-zA-Z0-9]/_};
      tar -zcvf ${title}.tar.gz $1;
      if [ $? -eq 0 ];
        then
          echo
          echo "${title}.tar.gz has been created!";
        else
          echo
          echo "ERROR: ttar has failed :(";
      fi
    else
      echo "ERROR: You must provide a description for your TAR.GZ";
  fi
}

# fires up vim with an empty markdown file of the form title_ddmmyy_hhmm.markdown
# usage: `markdown title`
function markdown() {
  if [ "$1" != "" ];
    then
      title=${@};
      vim ${title//[^a-zA-Z0-9]/_}_$(date +"%d%m%y_%H%M").markdown;
    else
      echo
      echo "ERROR: You must provide a title for your MARKDOWN";
  fi
}
