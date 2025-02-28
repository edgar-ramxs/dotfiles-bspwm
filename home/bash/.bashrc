#     ██████╗  █████╗ ███████╗██╗  ██╗██████╗  ██████╗
#     ██╔══██╗██╔══██╗██╔════╝██║  ██║██╔══██╗██╔════╝
#     ██████╔╝███████║███████╗███████║██████╔╝██║     
#     ██╔══██╗██╔══██║╚════██║██╔══██║██╔══██╗██║     
#  ██╗██████╔╝██║  ██║███████║██║  ██║██║  ██║╚██████╗
#  ╚═╝╚═════╝ ╚═╝  ╚═╝╚══════╝╚═╝  ╚═╝╚═╝  ╚═╝ ╚═════╝

[[ $- != *i* ]] && return 

export HISTSIZE=2000
export HISTFILESIZE=2000
export HISTCONTROL=ignoreboth

shopt -s histappend
shopt -s checkwinsize
shopt -s globstar

[ -x /usr/bin/lesspipe ] && eval "$(SHELL=/bin/sh lesspipe)"

if ! shopt -oq posix; then
  if [ -f /usr/share/bash-completion/bash_completion ]; then
    . /usr/share/bash-completion/bash_completion
  elif [ -f /etc/bash_completion ]; then
    . /etc/bash_completion
  fi
fi


# # Bind keys
# bind '"\e[A": history-search-backward'  # (up arrow) Buscar hacia adelante en el historial
# bind '"\e[B": history-search-forward'   # (down arrow) Buscar hacia atrás en el historial 
# bind '"\e[1~": beginning-of-line'       # (home) Mover el cursor al inicio de la línea
# bind '"\e[4~": end-of-line'             # (end) Mover el cursor al final de la línea
# bind '"\e[D": backward-word'            # (left arrow) Mover el cursor al inicio de la palabra anterior
# bind '"\e[C": forward-word'             # (right arrow) Mover el cursor al inicio de la siguiente palabra
# bind 'set show-all-if-ambiguous on'     # Muestra todas las opciones disponibles
# bind 'TAB:menu-complete'                # Muestra las opciones al presionar Tab
# bind '"\C-n": backward-kill-line'       # (Ctrl + N) Eliminar desde el inicio hasta el cursor
# bind '"\C-m": kill-line'                # (Ctrl + M) Eliminar desde el final hasta el cursor


# Sources
source ~/.exports
source ~/.functions
source ~/.aliases


PROMPT_COMMAND='PS1_CMD1=$(git branch 2>/dev/null | grep '"'"'*'"'"' | colrm 1 2)'
PS1='\[\e[38;5;69;1m\]\u\[\e[0;38;5;255m\]@\[\e[38;5;69;1m\]\h\[\e[0m\] \[\e[38;5;252m\]in\[\e[0m\] [\[\e[38;5;163m\]\w\[\e[0m\]][${PS1_CMD1}][\[\e[38;5;222m\]\t\[\e[0m\]]\n\[\e[38;5;51m\]>\[\e[0m\] '
