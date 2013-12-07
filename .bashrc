# GIT AWARE PROMPT

export GITAWAREPROMPT=~/.dot/.bash/git-aware-prompt
source $GITAWAREPROMPT/main.sh

# PS1

export PS1="\[\033[36m\]\u\[\033[m\]@\[\033[32m\]\h:\[\033[33;1m\]\w\[\033[m\]\$git_branch\$ "


#ALIAS TINGS

alias g='git'           # quick git
alias j='jump'
alias ls='ls -al'       # nice ls
alias nano='vim'        # no more nano
alias qq='git status'   # quick git status
alias sudo='sudo '      # When using sudo, use alias expansion (otherwise sudo ignores your aliases)
alias v='vim'           # quick vim
alias vi='vim'          # no vi
alias tmn="tmux new-session -s"
alias tml="tmux ls"
alias tma="tmux attach-session -t"
alias tms="tmux switch-session -t"


# Quickly navigate your filesystem from the command-line http://jeroenjanssens.com/2013/08/16/quickly-navigate-your-filesystem-from-the-command-line.html

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
