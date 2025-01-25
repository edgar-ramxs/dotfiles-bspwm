#!/usr/bin/env bash

#  ███████╗███████╗██╗  ██╗    ██╗███╗   ██╗███████╗████████╗ █████╗ ██╗     ██╗     ███████╗██████╗ 
#  ╚══███╔╝██╔════╝██║  ██║    ██║████╗  ██║██╔════╝╚══██╔══╝██╔══██╗██║     ██║     ██╔════╝██╔══██╗
#    ███╔╝ ███████╗███████║    ██║██╔██╗ ██║███████╗   ██║   ███████║██║     ██║     █████╗  ██████╔╝
#   ███╔╝  ╚════██║██╔══██║    ██║██║╚██╗██║╚════██║   ██║   ██╔══██║██║     ██║     ██╔══╝  ██╔══██╗
#  ███████╗███████║██║  ██║    ██║██║ ╚████║███████║   ██║   ██║  ██║███████╗███████╗███████╗██║  ██║
#  ╚══════╝╚══════╝╚═╝  ╚═╝    ╚═╝╚═╝  ╚═══╝╚══════╝   ╚═╝   ╚═╝  ╚═╝╚══════╝╚══════╝╚══════╝╚═╝  ╚═╝

function message() {
    local signal color
    local RESETC="\033[0m\e[0m"
    case "$1" in
        "-title")   color="\033[0;37m\033[1m"; signal="[$]"; shift ;;
        "-success") color="\033[0;32m\033[1m"; signal="[+]" ; shift ;;
        "-warning") color="\033[0;33m\033[1m"; signal="[&]" ; shift ;;
        "-error")   color="\033[0;31m\033[1m"; signal="[-]" ; shift ;;
        *) color="$RESETC"; signal=""; shift ;;
    esac
    echo -e "${color}${signal} $*${RESETC}"
}

function check_execution() {
    if [[ $1 -ne 0 ]]; then
        message -error "$2"
    else
        message -success "$3"
    fi
    sleep 0.5
}

message -title "ZSH Installation"
sleep 0.5
sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
sleep 1

message -subtitle "Installing ZSH plugins..."
sleep 0.5

message -subtitle "Installation: zsh-syntax-highlighting"
git clone https://github.com/zsh-users/zsh-syntax-highlighting.git ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting >/dev/null 2>&1
check_execution $? "Failed plugin download" "Plugin download successful"

message -subtitle "Installation: zsh-autosuggestions"
git clone https://github.com/zsh-users/zsh-autosuggestions ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-autosuggestions >/dev/null 2>&1
check_execution $? "Failed plugin download" "Plugin download successful"


message -subtitle "Setting ZSH as default..."
sleep 0.5
sudo chsh -s $(which zsh) $USER
sudo chsh -s $(which zsh) root

exit 1
