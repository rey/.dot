# ps1
# export PS1="\[\e[00;36m\]\u\[\e[0m\]\[\e[00;37m\]@\[\e[0m\]\[\e[00;32m\]\h\[\e[0m\]\[\e[00;37m\] \[\e[0m\]\[\e[00;33m\]\w\[\e[0m\]\[\e[00;37m\] \[\e[0m\]\[\e[00;35m\]%\[\e[0m\]\[\e[00;37m\] \[\e[0m\]"

# pink
# export PS1="\[\e[00;37m\]\h \w \[\e[0m\]\[\e[00;35m\]\\$\[\e[0m\]\[\e[00;37m\] \[\e[0m\]"
# brown?
export PS1="\[\e[00;37m\]\h \w \[\e[0m\]\[\e[00;33m\]\\$\[\e[0m\]\[\e[00;37m\] \[\e[0m\]"

EDITOR=/usr/bin/vim           # set vim to be the default editor
VISUAL=/usr/bin/vim           # set vim to be the default editor

set -o vi                     # use vim commands in bash

PATH=$PATH:$HOME/.rvm/bin     # Add RVM to PATH for scripting

source ~/.dot/bash/aliases    # bash aliases
source ~/.dot/bash/external   # external tools/functions
