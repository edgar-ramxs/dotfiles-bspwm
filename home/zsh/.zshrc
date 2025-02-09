#     ███████╗███████╗██╗  ██╗██████╗  ██████╗
#     ╚══███╔╝██╔════╝██║  ██║██╔══██╗██╔════╝
#       ███╔╝ ███████╗███████║██████╔╝██║
#      ███╔╝  ╚════██║██╔══██║██╔══██╗██║
#  ██╗███████╗███████║██║  ██║██║  ██║╚██████╗
#  ╚═╝╚══════╝╚══════╝╚═╝  ╚═╝╚═╝  ╚═╝ ╚═════╝

export ZSH="$HOME/.oh-my-zsh"
ZSH_THEME="powerlevel10k/powerlevel10k"

# Set list of themes to pick from when loading at random
# Setting this variable when ZSH_THEME=random will cause zsh to load
# a theme from this variable instead of looking in $ZSH/themes/
# If set to an empty array, this variable will have no effect.
# ZSH_THEME_RANDOM_CANDIDATES=( "robbyrussell" "agnoster" )

# Uncomment the following line to use case-sensitive completion.
# CASE_SENSITIVE="true"

# Uncomment the following line to use hyphen-insensitive completion.
# Case-sensitive completion must be off. _ and - will be interchangeable.
# HYPHEN_INSENSITIVE="true"

# Uncomment one of the following lines to change the auto-update behavior
# zstyle ':omz:update' mode disabled  # disable automatic updates
# zstyle ':omz:update' mode auto      # update automatically without asking
# zstyle ':omz:update' mode reminder  # just remind me to update when it's time

# Uncomment the following line to change how often to auto-update (in days).
# zstyle ':omz:update' frequency 13

# Uncomment the following line if pasting URLs and other text is messed up.
# DISABLE_MAGIC_FUNCTIONS="true"

# Uncomment the following line to disable colors in ls.
# DISABLE_LS_COLORS="true"

# Uncomment the following line to disable auto-setting terminal title.
# DISABLE_AUTO_TITLE="true"

# Uncomment the following line to enable command auto-correction.
# ENABLE_CORRECTION="true"

# Uncomment the following line to display red dots whilst waiting for completion.
# You can also set it to another string to have that shown instead of the default red dots.
# e.g. COMPLETION_WAITING_DOTS="%F{yellow}waiting...%f"
# Caution: this setting can cause issues with multiline prompts in zsh < 5.7.1 (see #5765)
# COMPLETION_WAITING_DOTS="true"

# Uncomment the following line if you want to disable marking untracked files
# under VCS as dirty. This makes repository status check for large repositories
# much, much faster.
# DISABLE_UNTRACKED_FILES_DIRTY="true"

# Uncomment the following line if you want to change the command execution time
# stamp shown in the history command output.
# You can set one of the optional three formats:
# "mm/dd/yyyy"|"dd.mm.yyyy"|"yyyy-mm-dd"
# or set a custom format using the strftime function format specifications,
# see 'man strftime' for details.
# HIST_STAMPS="mm/dd/yyyy"

# Would you like to use another custom folder than $ZSH/custom?
# ZSH_CUSTOM=/path/to/new-custom-folder

# Which plugins would you like to load?
# Standard plugins can be found in $ZSH/plugins/
# Custom plugins may be added to $ZSH_CUSTOM/plugins/
# Example format: plugins=(rails git textmate ruby lighthouse)
# Add wisely, as too many plugins slow down shell startup.
plugins=(
  fzf
  git
  sudo
  zsh-autosuggestions
  zsh-syntax-highlighting
  history-substring-search
)

source $ZSH/oh-my-zsh.sh

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

setopt histignorealldups   # Evita duplicados en el historial
setopt sharehistory        # Comparte historial entre sesiones
setopt extended_history    # Guarda timestamps en el historial
setopt inc_append_history  # Guarda comandos en historial inmediatamente
setopt histreduceblanks    # Elimina espacios extra en los comandos

export HISTFILE='~/.zsh_history'
export HISTSIZE=10000
export SAVEHIST=10000

autoload -Uz compinit && compinit
autoload -Uz promptinit && promptinit
prompt adam1  # Cambia esto para probar otros estilos con `prompt -p`

zstyle ':completion:*' menu select=2      # Selección con TAB
zstyle ':completion:*' auto-description 'specify: %d'
zstyle ':completion:*' completer _expand _complete _correct _approximate
zstyle ':completion:*' matcher-list '' 'm:{a-z}={A-Z}' 'm:{a-zA-Z}={A-Za-z}'
zstyle ':completion:*' list-colors ${(s.:.)LS_COLORS}
zstyle ':completion:*' select-prompt %SScrolling active: current selection at %p%s
zstyle ':completion:*' list-prompt %SAt %p: Hit TAB for more, or the character to insert%s
zstyle ':completion:*:*:kill:*:processes' list-colors '=(#b) #([0-9]#)*=0=01;31'
zstyle ':completion:*:kill:*' command 'ps -u $USER -o pid,%cpu,tty,cputime,cmd'

# Evita cargar compinit cada vez que abres la terminal
if [[ -z "$ZSH_COMPDUMP" ]]; then
    ZSH_COMPDUMP="${ZDOTDIR:-$HOME}/.zcompdump"
fi

if [[ ! -f "$ZSH_COMPDUMP" || "$ZSH_COMPDUMP" -ot "$ZSH_COMPDUMP.zwc" ]]; then
    compinit -C
else
    compinit
fi

# Bind keys
bindkey "\e[A" history-search-backward  # (up arrow) Buscar hacia atrás en el historial
bindkey "\e[B" history-search-forward   # (down arrow) Buscar hacia adelante en el historial
bindkey "\e[1~" beginning-of-line       # (home) Mover el cursor al inicio de la línea
bindkey "\e[4~" end-of-line             # (end) Mover el cursor al final de la línea
bindkey "\e[D" backward-word            # (left arrow) Mover el cursor al inicio de la palabra anterior
bindkey "\e[C" forward-word             # (right arrow) Mover el cursor al inicio de la siguiente palabra
setopt menu_complete                    # Muestra todas las opciones disponibles si hay ambigüedad
bindkey "^I" complete                   # Muestra las opciones al presionar Tab
bindkey "^N" backward-kill-line         # (Ctrl + N) Eliminar desde el inicio hasta el cursor
bindkey "^M" kill-line                  # (Ctrl + M) Eliminar desde el final hasta el cursor

# bindkey -e                            # Activa edición estilo emacs (Ctrl+A, Ctrl+E, etc.)
# bindkey "^[l" forward-word            # (Alt + L) → Mover adelante una palabra
# bindkey "^[h" backward-word           # (Alt + H) → Mover atrás una palabra
# bindkey "^N" backward-kill-line       # (Ctrl + N) → Elimina desde el cursor hasta el inicio
# bindkey "^M" kill-line                # (Ctrl + M) → Elimina desde el cursor hasta el final
# bindkey "^[j" down-line-or-history    # (Alt + J) → Bajar en el historial
# bindkey "^[k" up-line-or-history      # (Alt + K) → Subir en el historial
# bindkey '^ ' autosuggest-accept       # (Ctrl + Espacio) → Aceptar sugerencia automática
# bindkey '^H' autosuggest-clear        # (Ctrl + H) → Limpiar sugerencias automáticas


# Sources
source ~/.functions
source ~/.exports
source ~/.aliases

