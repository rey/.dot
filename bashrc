# ps1
export PS1="\[\e[00;37m\]\h \w \[\e[0m\]\[\e[00;35m\]\\$\[\e[0m\]\[\e[00;37m\] \[\e[0m\]"

EDITOR=/usr/bin/vim           # set vim to be the default editor
VISUAL=/usr/bin/vim           # set vim to be the default editor

set -o vi                     # use vim commands in bash

PATH=$PATH:$HOME/.rvm/bin     # Add RVM to PATH for scripting

# alias

alias hash:6='date | md5sum | cut -c 1-6'
alias hash:8='date | md5sum | cut -c 1-8'
alias hash:10='date | md5sum | cut -c 1-10'
alias grep='grep --color=auto'
alias j='jump'
alias ls='ls -lags'
alias nano='vim'
alias qq='git status -sb'
alias reboot='shutdown -r now'
alias sudo='sudo '
alias tmn="tmux new-session -s"
alias tml="tmux ls"
alias tma="tmux attach -t"
alias tms="tmux switch -t"
alias tree="tree -C"
alias v='vim'
alias vi='vim'

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
