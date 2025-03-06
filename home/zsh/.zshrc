#     ███████╗███████╗██╗  ██╗██████╗  ██████╗
#     ╚══███╔╝██╔════╝██║  ██║██╔══██╗██╔════╝
#       ███╔╝ ███████╗███████║██████╔╝██║
#      ███╔╝  ╚════██║██╔══██║██╔══██╗██║
#  ██╗███████╗███████║██║  ██║██║  ██║╚██████╗
#  ╚═╝╚══════╝╚══════╝╚═╝  ╚═╝╚═╝  ╚═╝ ╚═════╝

if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

[ -f "$HOME/.config/shell/exports" ] && source "$HOME/.config/shell/exports"
[ -f "$HOME/.config/shell/functions" ] && source "$HOME/.config/shell/functions"
[ -f "$HOME/.config/shell/aliases" ] && source "$HOME/.config/shell/aliases"

export HISTSIZE=10000
export SAVEHIST=$HISTSIZE
export HISTFILE="$HOME/.cache/zsh_history"
export ZSH="$HOME/.oh-my-zsh"
ZSH_THEME="powerlevel10k/powerlevel10k"

plugins=(
  git
  sudo
  zsh-autosuggestions
  zsh-syntax-highlighting
  history-substring-search
)

source $ZSH/oh-my-zsh.sh
autoload -Uz promptinit && promptinit
autoload -Uz compinit && compinit -C -d $XDG_CACHE_HOME/.zcompdump

# setopt menu_complete            # Muestra todas las opciones disponibles si hay ambigüedad
# setopt autocd                   # change directory just by typing its name
# setopt correct                  # auto correct mistakes
# setopt interactivecomments      # allow comments in interactive mode
# setopt magicequalsubst          # enable filename expansion for arguments of the form ‘anything=expression’
# setopt nonomatch                # hide error message if there is no match for the pattern
# setopt notify                   # report the status of background jobs immediately
# setopt numericglobsort          # sort filenames numerically when it makes sense
# setopt promptsubst              # enable command substitution in prompt
# setopt hist_expire_dups_first   # delete duplicates first when HISTFILE size exceeds HISTSIZE
# setopt hist_ignore_dups         # ignore duplicated commands history list
# setopt hist_ignore_space        # ignore commands that start with space
# setopt hist_verify              # show command with history expansion to user before running it
# setopt share_history            # share command history data

setopt histignorealldups        # Evita duplicados en el historial
setopt sharehistory             # Comparte historial entre sesiones
setopt extended_history         # Guarda timestamps en el historial
setopt inc_append_history       # Guarda comandos en historial inmediatamente
setopt histreduceblanks         # Elimina espacios extra en los comandos

zstyle ':completion:*' menu select=2
zstyle ':completion:*' auto-description 'specify: %d'
zstyle ':completion:*' completer _expand _complete _correct _approximate
zstyle ':completion:*' matcher-list '' 'm:{a-z}={A-Z}' 'm:{a-zA-Z}={A-Za-z}'
zstyle ':completion:*' list-colors ${(s.:.)LS_COLORS}
zstyle ':completion:*' select-prompt %SScrolling active: current selection at %p%s
zstyle ':completion:*' list-prompt %SAt %p: Hit TAB for more, or the character to insert%s
zstyle ':completion:*:*:kill:*:processes' list-colors '=(#b) #([0-9]#)*=0=01;31'
zstyle ':completion:*:kill:*' command 'ps -u $USER -o pid,%cpu,tty,cputime,cmd'

[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh
