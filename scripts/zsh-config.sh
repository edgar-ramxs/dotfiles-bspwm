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
        "-title")       color="\033[0;37m\033[1m";      signal="[$]"; shift; echo -e "\n${color}${signal} $*${RESETC}";;
        "-subtitle")    color="\033[0;35m\033[1m";      signal="[*]"; shift; echo -e "\n${color}${signal} $*${RESETC}";;
        "-approval")    color="\033[38;5;51m\033[1m";   signal="[?]"; shift; echo -e "\n${color}${signal} $*${RESETC}";;
        "-success")     color="\033[0;32m\033[1m";      signal="[+]"; shift; echo -e "\t${color}${signal} $*${RESETC}";;
        "-warning")     color="\033[0;33m\033[1m";      signal="[&]"; shift; echo -e "\t${color}${signal} $*${RESETC}";;
        "-error")       color="\033[0;31m\033[1m";      signal="[-]"; shift; echo -e "\t${color}${signal} $*${RESETC}";;
        "-cancel")      color="\033[0;34m\033[1m";      signal="[!]"; shift; echo -e "\n${color}${signal} $*${RESETC}";;
        *)              color="$RESETC";                signal=""; shift; echo -e "${color}${signal} $*${RESETC}";;
    esac
}

function check_execution() {
    if [[ $1 -ne 0 ]]; then
        message -error "$2"
        exit 1
    else
        message -success "$3"
    fi
    sleep 0.5
}

function install_zsh() {
    message -title "Zsh installation"
    sleep 0.5

    message -subtitle "Verifying that Zsh is installed..."
    sleep 0.5

    if ! command -v zsh >/dev/null 2>&1; then
        message -warning "Zsh is not installed. Proceeding with installation..."
        if command -v apt >/dev/null 2>&1; then
            sudo apt update && sudo apt install -y zsh
        elif command -v pacman >/dev/null 2>&1; then
            sudo pacman -Syu --noconfirm zsh
        elif command -v dnf >/dev/null 2>&1; then
            sudo dnf install -y zsh
        elif command -v yum >/dev/null 2>&1; then
            sudo yum install -y zsh
        elif command -v zypper >/dev/null 2>&1; then
            sudo zypper install -y zsh
        else
            message -error "The package manager could not be determined. Please install Zsh manually."
            exit 1
        fi
        message -success "Zsh installed successfully."
    else
        message -success "Zsh is now installed."
    fi
}

function install_oh_my_zsh() {
    message -title "Installing Oh My Zsh"
    sleep 0.5

    local plugins=(
        "https://github.com/zsh-users/zsh-syntax-highlighting.git"
        "https://github.com/zsh-users/zsh-autosuggestions.git"
    )

    message -subtitle "Checking that there is no .oh-my-zsh directory..."
    sleep 0.5

    if [ -d "$HOME/.oh-my-zsh" ]; then
        message -warning "A previous installation of Oh My Zsh was found. Removing it..."
        rm -rf "$HOME/.oh-my-zsh"
        message -success "Previous installation removed."
    fi

    message -subtitle "Downloading and installing Oh My Zsh..."
    sleep 0.5

    # ZSH="$HOME/.dotfiles/oh-my-zsh" sh install.sh
    yes | sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" >/dev/null 2>&1
    check_execution $? "Error installing Oh My Zsh" "Oh My Zsh installed successfully."

    message -subtitle "Installing Zsh plugins..."
    sleep 0.5

    for plugin in "${plugins[@]}"; do
        local plugin_name=$(basename "$plugin" .git)
        local plugin_path="${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/plugins/$plugin_name"
        message -warning "Installing: $plugin_name"
        git clone "$plugin" "$plugin_path" >/dev/null 2>&1
        check_execution $? "Error installing $plugin_name" "$plugin_name installed correctly."
    done

    message -subtitle "Downloading zsh theme..."
    sleep 0.5

    git clone --depth=1 https://github.com/romkatv/powerlevel10k.git "${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/themes/powerlevel10k" >/dev/null 2>&1
    check_execution $? "Error installing" "installed correctly."

    message -subtitle "Verifying default shell..."
    sleep 0.5

    if [ "$SHELL" != "$(which zsh)" ]; then
        message -warning "Changing default shell to Zsh..."
        sudo chsh -s "$(which zsh)" "$USER"
        sudo chsh -s "$(which zsh)" "root"
        message -success "Zsh is now the default shell."
    else
        message -success "Zsh is now the default shell."
    fi
    
    exec zsh
}

set -e
sudo -v

install_zsh
install_oh_my_zsh
message -cancel "installation completed successfully."
exit 0
