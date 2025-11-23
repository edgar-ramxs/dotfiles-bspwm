#!/usr/bin/env bash

#  ███████╗███████╗██╗  ██╗    ██╗███╗   ██╗███████╗████████╗ █████╗ ██╗     ██╗     ███████╗██████╗ 
#  ╚══███╔╝██╔════╝██║  ██║    ██║████╗  ██║██╔════╝╚══██╔══╝██╔══██╗██║     ██║     ██╔════╝██╔══██╗
#    ███╔╝ ███████╗███████║    ██║██╔██╗ ██║███████╗   ██║   ███████║██║     ██║     █████╗  ██████╔╝
#   ███╔╝  ╚════██║██╔══██║    ██║██║╚██╗██║╚════██║   ██║   ██╔══██║██║     ██║     ██╔══╝  ██╔══██╗
#  ███████╗███████║██║  ██║    ██║██║ ╚████║███████║   ██║   ██║  ██║███████╗███████╗███████╗██║  ██║
#  ╚══════╝╚══════╝╚═╝  ╚═╝    ╚═╝╚═╝  ╚═══╝╚══════╝   ╚═╝   ╚═╝  ╚═╝╚══════╝╚══════╝╚══════╝╚═╝  ╚═╝

# ========== MESSAGE SYSTEM ==========
function message() {
    local RESETC="\033[0m\e[0m"
    local BOLD="\033[1m"
    declare -A MESSAGE_MAP=(
        [-title]="\033[0;37m${BOLD} [$]"
        [-subtitle]="\033[0;35m${BOLD} [*]"
        [-approval]="\033[38;5;51m${BOLD} [?]"
        [-cancel]="\033[0;34m${BOLD} [!]"
        [-success]="\033[0;32m${BOLD} [+]"
        [-warning]="\033[0;33m${BOLD} [&]"
        [-error]="\033[0;31m${BOLD} [-]"
    )

    local key="$1"
    shift
    local color_msg="${MESSAGE_MAP[$key]}"
    local prefix="\n"
    [[ "$key" == "-success" || "$key" == "-warning" || "$key" == "-error" ]] && prefix="\t"
    echo -e "${prefix}${color_msg} $*${RESETC}"

    case "$key" in
        -title) sleep 0.5 ;;
        -subtitle) sleep 0.3 ;;
        -cancel) sleep 0.5 ;;
    esac
}

trap exiting_script INT
function exiting_script() {
    message -cancel "Exiting...\n"
    exit 1
}

function check_execution() {
    [[ $1 -ne 0 && $1 -ne 130 ]] && message -error "Error: $2" || message -success "$3"
    sleep 0.3
}

# ========== INSTALL ZSH IF MISSING ==========
function install_zsh() {
    message -title "Installing Zsh..."

    if command -v zsh &>/dev/null; then
        message -success "Zsh is already installed."
        return
    fi

    message -warning "Zsh is not installed. Proceeding with installation..."

    if command -v apt &>/dev/null; then
        sudo apt update && sudo apt install -y zsh
    elif command -v pacman &>/dev/null; then
        sudo pacman -Syu --noconfirm zsh
    elif command -v dnf &>/dev/null; then
        sudo dnf install -y zsh
    elif command -v yum &>/dev/null; then
        sudo yum install -y zsh
    elif command -v zypper &>/dev/null; then
        sudo zypper install -y zsh
    else
        message -error "Unsupported package manager. Install Zsh manually."
        exiting_script
    fi

    message -success "Zsh installed successfully."
}

# ========== INSTALL OH-MY-ZSH AND PLUGINS ==========
function install_oh_my_zsh() {
    message -title "Installing Oh My Zsh and plugins..."

    local ZSH_CUSTOM="${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}"
    local plugins=(
        "https://github.com/zsh-users/zsh-syntax-highlighting.git"
        "https://github.com/zsh-users/zsh-autosuggestions.git"
    )

    # Remove previous installation
    if [[ -d "$HOME/.oh-my-zsh" ]]; then
        message -warning "Found existing Oh My Zsh. Removing..."
        rm -rf "$HOME/.oh-my-zsh"
        message -success "Previous installation removed."
    fi

    # Install Oh My Zsh
    message -subtitle "Installing Oh My Zsh..."
    yes | sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" >/dev/null 2>&1
    check_execution $? "Error installing Oh My Zsh" "Oh My Zsh installed successfully."

    # Plugins
    message -subtitle "Installing plugins..."
    for plugin_url in "${plugins[@]}"; do
        local name=$(basename "$plugin_url" .git)
        local dest="$ZSH_CUSTOM/plugins/$name"
        message -warning "Installing: $name"
        git clone "$plugin_url" "$dest" >/dev/null 2>&1
        check_execution $? "Error installing $name" "$name installed successfully."
    done

    # Theme
    message -subtitle "Installing theme: powerlevel10k..."
    git clone --depth=1 https://github.com/romkatv/powerlevel10k.git "$ZSH_CUSTOM/themes/powerlevel10k" >/dev/null 2>&1
    check_execution $? "Error installing powerlevel10k" "Theme installed successfully."

    # Change shell
    message -subtitle "Setting Zsh as the default shell..."
    if [[ "$SHELL" != "$(which zsh)" ]]; then
        sudo chsh -s "$(which zsh)" "$USER"
        sudo chsh -s "$(which zsh)" root
        message -success "Zsh is now the default shell."
    else
        message -success "Zsh is already the default shell."
    fi

    exec zsh
}

# ========== EXECUTION ==========
set -e
sudo -v

install_zsh
install_oh_my_zsh

message -approval "Zsh setup completed successfully."
exit 0
