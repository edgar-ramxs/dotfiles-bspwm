#!/usr/bin/env bash

#  ██████╗ ███████╗██████╗ ██╗ █████╗ ███╗   ██╗    ██████╗  █████╗  ██████╗██╗  ██╗ █████╗  ██████╗ ███████╗███████╗
#  ██╔══██╗██╔════╝██╔══██╗██║██╔══██╗████╗  ██║    ██╔══██╗██╔══██╗██╔════╝██║ ██╔╝██╔══██╗██╔════╝ ██╔════╝██╔════╝
#  ██║  ██║█████╗  ██████╔╝██║███████║██╔██╗ ██║    ██████╔╝███████║██║     █████╔╝ ███████║██║  ███╗█████╗  ███████╗
#  ██║  ██║██╔══╝  ██╔══██╗██║██╔══██║██║╚██╗██║    ██╔═══╝ ██╔══██║██║     ██╔═██╗ ██╔══██║██║   ██║██╔══╝  ╚════██║
#  ██████╔╝███████╗██████╔╝██║██║  ██║██║ ╚████║    ██║     ██║  ██║╚██████╗██║  ██╗██║  ██║╚██████╔╝███████╗███████║
#  ╚═════╝ ╚══════╝╚═════╝ ╚═╝╚═╝  ╚═╝╚═╝  ╚═══╝    ╚═╝     ╚═╝  ╚═╝ ╚═════╝╚═╝  ╚═╝╚═╝  ╚═╝ ╚═════╝ ╚══════╝╚══════╝

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
}

function download_discord() {
    message -subtitle "Downloading Discord..."
    local DISCORD_URL="https://discord.com/api/download?platform=linux&format=deb"
    local DISCORD_DEB="$TEMP_DIR/discord.deb"
    wget -O "$DISCORD_DEB" "$DISCORD_URL"
    check_execution $? "Failed to download Discord" "Discord downloaded successfully"
    
    message -subtitle "Installing Discord..."
    sudo dpkg -i "$DISCORD_DEB"
    check_execution $? "Failed to install Discord" "Discord installed successfully"
    sudo apt-get install -f -y
}

function download_vscode() {
    message -subtitle "Downloading Visual Studio Code..."
    local VSCODE_URL="https://code.visualstudio.com/sha/download?build=stable&os=linux-deb-x64"
    local VSCODE_DEB="$TEMP_DIR/code.deb"
    wget -O "$VSCODE_DEB" "$VSCODE_URL"
    check_execution $? "Failed to download Visual Studio Code" "Visual Studio Code downloaded successfully"
    
    message -subtitle "Installing Visual Studio Code..."
    sudo dpkg -i "$VSCODE_DEB"
    check_execution $? "Failed to install Visual Studio Code" "Visual Studio Code installed successfully"
    sudo apt-get install -f -y
    
    # curl https://packages.microsoft.com/keys/microsoft.asc | gpg --dearmor > microsoft.gpg
    # sudo install -o root -g root -m 644 microsoft.gpg /etc/apt/keyrings/microsoft-archive-keyring.gpg
    # sudo sh -c 'echo "deb [arch=amd64,arm64,armhf signed-by=/etc/apt/keyrings/microsoft-archive-keyring.gpg] https://packages.microsoft.com/repos/code stable main" > /etc/apt/sources.list.d/vscode.list'
    # sudo apt-get update
    # sudo apt-get install code # or code-insiders
}

function install_brave() {
    message -subtitle "Installing Brave Browser..."
    sudo apt install -y curl
    check_execution $? "Failed to install curl" "Curl installed successfully"
    
    sudo curl -fsSLo /usr/share/keyrings/brave-browser-archive-keyring.gpg \
    https://brave-browser-apt-release.s3.brave.com/brave-browser-archive-keyring.gpg
    check_execution $? "Failed to download Brave Browser key" "Brave Browser key downloaded successfully"
    
    echo "deb [signed-by=/usr/share/keyrings/brave-browser-archive-keyring.gpg] https://brave-browser-apt-release.s3.brave.com/ stable main" \
    | sudo tee /etc/apt/sources.list.d/brave-browser-release.list
    
    sudo apt update
    check_execution $? "Failed to update package list" "Package list updated successfully"
    
    sudo apt install -y brave-browser
    check_execution $? "Failed to install Brave Browser" "Brave Browser installed successfully"
}

function usage() {
    echo "Usage: $0 [-d] [-v] [-b]"
    echo "  -d    Download and install Discord"
    echo "  -v    Download and install Visual Studio Code"
    echo "  -b    Install Brave Browser"
    echo "  -h    Display this help"
    exit 1
}

set -e
sudo -v

TEMP_DIR=$(mktemp -d)
message -title "Temporary directory created: $TEMP_DIR"

while getopts "dvb" opt; do
    case $opt in
        d) download_discord ;;
        v) download_vscode ;;
        b) install_brave ;;
        *) usage ;;
    esac
done

message -subtitle "Cleaning up temporary files..."
rm -rf "$TEMP_DIR"

message -success "Process completed successfully."
exit 1
