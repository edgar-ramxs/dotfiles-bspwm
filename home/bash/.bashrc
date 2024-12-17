#     ██████╗  █████╗ ███████╗██╗  ██╗██████╗  ██████╗
#     ██╔══██╗██╔══██╗██╔════╝██║  ██║██╔══██╗██╔════╝
#     ██████╔╝███████║███████╗███████║██████╔╝██║     
#     ██╔══██╗██╔══██║╚════██║██╔══██║██╔══██╗██║     
#  ██╗██████╔╝██║  ██║███████║██║  ██║██║  ██║╚██████╗
#  ╚═╝╚═════╝ ╚═╝  ╚═╝╚══════╝╚═╝  ╚═╝╚═╝  ╚═╝ ╚═════╝

# If not running interactively, don't do anything 
[[ $- != *i* ]] && return 

HISTSIZE=2000
HISTFILESIZE=2000
HISTCONTROL=ignoreboth

shopt -s histappend
shopt -s checkwinsize
shopt -s globstar

[ -x /usr/bin/lesspipe ] && eval "$(SHELL=/bin/sh lesspipe)"

if [ -x /usr/bin/dircolors ]; then
    test -r ~/.dircolors && eval "$(dircolors -b ~/.dircolors)" || eval "$(dircolors -b)"
    export LS_COLORS="$LS_COLORS:ow=30;44:"
    alias ls='ls --color=auto'
    alias ip='ip --color=auto'
    alias diff='diff --color=auto' 
    alias grep='grep --color=auto'
    alias fgrep='fgrep --color=auto'
    alias egrep='egrep --color=auto'

    export LESS_TERMCAP_mb=$'\E[1;31m'     # begin blink
    export LESS_TERMCAP_md=$'\E[1;36m'     # begin bold
    export LESS_TERMCAP_me=$'\E[0m'        # reset bold/blink
    export LESS_TERMCAP_so=$'\E[01;33m'    # begin reverse video
    export LESS_TERMCAP_se=$'\E[0m'        # reset reverse video
    export LESS_TERMCAP_us=$'\E[1;32m'     # begin underline
    export LESS_TERMCAP_ue=$'\E[0m'        # reset underline
fi

if ! shopt -oq posix; then
  if [ -f /usr/share/bash-completion/bash_completion ]; then
    . /usr/share/bash-completion/bash_completion
  elif [ -f /etc/bash_completion ]; then
    . /etc/bash_completion
  fi
fi

[ -f ~/.aliases] && source ~/.aliases
[ -f ~/.exports] && source ~/.exports
[ -f ~/.functions] && source ~/.functions

PROMPT_COMMAND='PS1_CMD1=$(git branch 2>/dev/null | grep '"'"'*'"'"' | colrm 1 2)'
PS1='\[\e[38;5;69;1m\]\u\[\e[0;38;5;255m\]@\[\e[38;5;69;1m\]\h\[\e[0m\] \[\e[38;5;252m\]in\[\e[0m\] [\[\e[38;5;163m\]\w\[\e[0m\]][${PS1_CMD1}][\[\e[38;5;222m\]\t\[\e[0m\]]\n\[\e[38;5;51m\]>\[\e[0m\] '
