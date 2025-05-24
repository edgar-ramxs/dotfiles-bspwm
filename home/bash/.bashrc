#     ██████╗  █████╗ ███████╗██╗  ██╗██████╗  ██████╗
#     ██╔══██╗██╔══██╗██╔════╝██║  ██║██╔══██╗██╔════╝
#     ██████╔╝███████║███████╗███████║██████╔╝██║     
#     ██╔══██╗██╔══██║╚════██║██╔══██║██╔══██╗██║     
#  ██╗██████╔╝██║  ██║███████║██║  ██║██║  ██║╚██████╗
#  ╚═╝╚═════╝ ╚═╝  ╚═╝╚══════╝╚═╝  ╚═╝╚═╝  ╚═╝ ╚═════╝

[[ $- != *i* ]] && return 

[ -f "$HOME/.config/shell/exports" ] && source "$HOME/.config/shell/exports"
[ -f "$HOME/.config/shell/functions" ] && source "$HOME/.config/shell/functions"
[ -f "$HOME/.config/shell/aliases" ] && source "$HOME/.config/shell/aliases"

[ -x /usr/bin/lesspipe ] && eval "$(SHELL=/bin/sh lesspipe)"

shopt -s histappend
shopt -s checkwinsize
shopt -s globstar

export HISTSIZE=10000
export SAVEHIST=$HISTSIZE
export HISTFILE="$HOME/.cache/bash_history"

if ! shopt -oq posix; then
  if [ -f /usr/share/bash-completion/bash_completion ]; then
    . /usr/share/bash-completion/bash_completion
  elif [ -f /etc/bash_completion ]; then
    . /etc/bash_completion
  fi
fi

# PS1='\[\033[1;31m\]\h\[\033[1;33m\]:\[\033[1;34m\]\W \[\033[1;33m\]|\[\033[0m\] '
# PS1='\[\033[01;31m\]\h\[\033[01;33m\]:\[\033[01;34m\]\W \[\033[01;33m\]|\[\033[0m\] '

PROMPT_COMMAND='PS1_CMD1=$(git branch 2>/dev/null | grep '"'"'*'"'"' | colrm 1 2)'
PS1='\[\e[38;5;69;1m\]\u\[\e[0;38;5;255m\]@\[\e[38;5;69;1m\]\h\[\e[0m\] \[\e[38;5;252m\]in\[\e[0m\] [\[\e[38;5;163m\]\w\[\e[0m\]][${PS1_CMD1}][\[\e[38;5;222m\]\t\[\e[0m\]]\n\[\e[38;5;51m\]>\[\e[0m\] '
