#     ███████╗███████╗██╗  ██╗██████╗  ██████╗
#     ╚══███╔╝██╔════╝██║  ██║██╔══██╗██╔════╝
#       ███╔╝ ███████╗███████║██████╔╝██║     
#      ███╔╝  ╚════██║██╔══██║██╔══██╗██║     
#  ██╗███████╗███████║██║  ██║██║  ██║╚██████╗
#  ╚═╝╚══════╝╚══════╝╚═╝  ╚═╝╚═╝  ╚═╝ ╚═════╝

if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
    source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

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


# # configure key keybindings
# bindkey -e                                        # emacs key bindings
# bindkey ' ' magic-space                           # do history expansion on space
# bindkey '^U' backward-kill-line                   # ctrl + U
# bindkey '^[[3;5~' kill-word                       # ctrl + Supr
# bindkey '^[[3~' delete-char                       # delete
# bindkey '^[[1;5C' forward-word                    # ctrl + ->
# bindkey '^[[1;5D' backward-word                   # ctrl + <-
# bindkey '^[[5~' beginning-of-buffer-or-history    # page up
# bindkey '^[[6~' end-of-buffer-or-history          # page down
# bindkey '^[[H' beginning-of-line                  # home
# bindkey '^[[F' end-of-line                        # end
# bindkey '^[[Z' undo                               # shift + tab undo last action
# bindkey "^[[H" beginning-of-line
# bindkey "^[[F" end-of-line
# bindkey "^[[3~" delete-char
# bindkey "^[[1;3C" forward-word
# bindkey "^[[1;3D" backward-word


HISTSIZE=5000000
SAVEHIST=5000000
HISTFILE=~/.zsh_history

bindkey -e
autoload -Uz promptinit
autoload -Uz compinit
prompt adam1
promptinit
compinit
setopt histignorealldups sharehistory

zstyle ':completion:*' auto-description 'specify: %d'
zstyle ':completion:*' completer _expand _complete _correct _approximate
zstyle ':completion:*' format 'Completing %d'
zstyle ':completion:*' group-name ''
zstyle ':completion:*' menu select=2
eval "$(dircolors -b)"
zstyle ':completion:*:default' list-colors ${(s.:.)LS_COLORS}
zstyle ':completion:*' list-colors ''
zstyle ':completion:*' list-prompt %SAt %p: Hit TAB for more, or the character to insert%s
zstyle ':completion:*' matcher-list '' 'm:{a-z}={A-Z}' 'm:{a-zA-Z}={A-Za-z}' 'r:|[._-]=* r:|=* l:|=*'
zstyle ':completion:*' menu select=long
zstyle ':completion:*' select-prompt %SScrolling active: current selection at %p%s
zstyle ':completion:*' use-compctl false
zstyle ':completion:*' verbose true
zstyle ':completion:*:*:kill:*:processes' list-colors '=(#b) #([0-9]#)*=0=01;31'
zstyle ':completion:*:kill:*' command 'ps -u $USER -o pid,%cpu,tty,cputime,cmd'

[ -x /usr/bin/lesspipe ] && eval "$(SHELL=/bin/sh lesspipe)"

if [ -f /usr/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh ]; then
    . /usr/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
    ZSH_HIGHLIGHT_HIGHLIGHTERS=(main brackets pattern)
    ZSH_HIGHLIGHT_STYLES[default]=none
    ZSH_HIGHLIGHT_STYLES[unknown-token]=underline
    ZSH_HIGHLIGHT_STYLES[reserved-word]=fg=cyan,bold
    ZSH_HIGHLIGHT_STYLES[suffix-alias]=fg=green,underline
    ZSH_HIGHLIGHT_STYLES[global-alias]=fg=green,bold
    ZSH_HIGHLIGHT_STYLES[precommand]=fg=green,underline
    ZSH_HIGHLIGHT_STYLES[commandseparator]=fg=blue,bold
    ZSH_HIGHLIGHT_STYLES[autodirectory]=fg=green,underline
    ZSH_HIGHLIGHT_STYLES[path]=bold
    ZSH_HIGHLIGHT_STYLES[path_pathseparator]=
    ZSH_HIGHLIGHT_STYLES[path_prefix_pathseparator]=
    ZSH_HIGHLIGHT_STYLES[globbing]=fg=blue,bold
    ZSH_HIGHLIGHT_STYLES[history-expansion]=fg=blue,bold
    ZSH_HIGHLIGHT_STYLES[command-substitution]=none
    ZSH_HIGHLIGHT_STYLES[command-substitution-delimiter]=fg=magenta,bold
    ZSH_HIGHLIGHT_STYLES[process-substitution]=none
    ZSH_HIGHLIGHT_STYLES[process-substitution-delimiter]=fg=magenta,bold
    ZSH_HIGHLIGHT_STYLES[single-hyphen-option]=fg=green
    ZSH_HIGHLIGHT_STYLES[double-hyphen-option]=fg=green
    ZSH_HIGHLIGHT_STYLES[back-quoted-argument]=none
    ZSH_HIGHLIGHT_STYLES[back-quoted-argument-delimiter]=fg=blue,bold
    ZSH_HIGHLIGHT_STYLES[single-quoted-argument]=fg=yellow
    ZSH_HIGHLIGHT_STYLES[double-quoted-argument]=fg=yellow
    ZSH_HIGHLIGHT_STYLES[dollar-quoted-argument]=fg=yellow
    ZSH_HIGHLIGHT_STYLES[rc-quote]=fg=magenta
    ZSH_HIGHLIGHT_STYLES[dollar-double-quoted-argument]=fg=magenta,bold
    ZSH_HIGHLIGHT_STYLES[back-double-quoted-argument]=fg=magenta,bold
    ZSH_HIGHLIGHT_STYLES[back-dollar-quoted-argument]=fg=magenta,bold
    ZSH_HIGHLIGHT_STYLES[assign]=none
    ZSH_HIGHLIGHT_STYLES[redirection]=fg=blue,bold
    ZSH_HIGHLIGHT_STYLES[comment]=fg=black,bold
    ZSH_HIGHLIGHT_STYLES[named-fd]=none
    ZSH_HIGHLIGHT_STYLES[numeric-fd]=none
    ZSH_HIGHLIGHT_STYLES[arg0]=fg=cyan
    ZSH_HIGHLIGHT_STYLES[bracket-error]=fg=red,bold
    ZSH_HIGHLIGHT_STYLES[bracket-level-1]=fg=blue,bold
    ZSH_HIGHLIGHT_STYLES[bracket-level-2]=fg=green,bold
    ZSH_HIGHLIGHT_STYLES[bracket-level-3]=fg=magenta,bold
    ZSH_HIGHLIGHT_STYLES[bracket-level-4]=fg=yellow,bold
    ZSH_HIGHLIGHT_STYLES[bracket-level-5]=fg=cyan,bold
    ZSH_HIGHLIGHT_STYLES[cursor-matchingbracket]=standout
fi

if [ -f /usr/share/zsh-autosuggestions/zsh-autosuggestions.zsh ]; then
    . /usr/share/zsh-autosuggestions/zsh-autosuggestions.zsh
    ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE='fg=#999'
fi

if [ -f /usr/share/zsh-sudo/zsh-sudo.zsh ]; then
    . /usr/share/zsh-sudo/zsh-sudo.zsh
fi

if [ -f /etc/zsh_command_not_found ]; then
    . /etc/zsh_command_not_found
fi

[ -f ~/.aliases] && source ~/.aliases
[ -f ~/.exports] && source ~/.exports
[ -f ~/.functions] && source ~/.functions
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh
