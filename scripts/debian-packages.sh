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
        "-cancel")      color="\033[0;34m\033[1m";      signal="[!]"; shift; echo -e "\n${color}${signal} $*${RESETC}";;
        "-success")     color="\033[0;32m\033[1m";      signal="[+]"; shift; echo -e "\t${color}${signal} $*${RESETC}";;
        "-warning")     color="\033[0;33m\033[1m";      signal="[&]"; shift; echo -e "\t${color}${signal} $*${RESETC}";;
        "-error")       color="\033[0;31m\033[1m";      signal="[-]"; shift; echo -e "\t${color}${signal} $*${RESETC}";;
        *)              color="$RESETC";                signal=""; shift; echo -e "${color}${signal} $*${RESETC}";;
    esac
}

function usage() {
    message -title "Usage: $0 [-d] [-v] [-b]"
    message -warning "Target    Description"
    message -success "-b        Install Brave Browser"
    message -success "-d        Download and install Discord"
    message -success "-v        Download and install Visual Studio Code"
    echo ""
    exit 1
}

trap ctrl_c INT
function ctrl_c() {
    message -cancel "Exiting...\n"
    exit 1
}

function check_execution() {
    if [ $1 != 0 ] && [ $1 != 130 ]; then
        message -error "Error: $2"
    else
        message -success "Successful: $3"
    fi
    sleep 0.5
}

function install_brave(){
    message -subtitle "install brave"
    sleep 0.5
}

function install_vscode(){
    local DIR_DOWNLOAD=$1
    local VSCODE_DEB="$DIR_DOWNLOAD/vscode.deb"
    local VSCODE_URL="https://code.visualstudio.com/sha/download?build=stable&os=linux-deb-x64"
    
    message -subtitle "Downloading Visual Studio Code..."
    sleep 0.5

    wget -O "$VSCODE_DEB" "$VSCODE_URL" >/dev/null 2>&1
    check_execution $? "Failed to download Visual Studio Code" "Visual Studio Code downloaded successfully"
}

function install_discord(){
    local DIR_DOWNLOAD=$1
    local DISCORD_DEB="$DIR_DOWNLOAD/discord.deb"
    local DISCORD_URL="https://discord.com/api/download?platform=linux&format=deb"
    
    message -subtitle "Downloading Discord..."
    sleep 0.5

    wget -O "$DISCORD_DEB" "$DISCORD_URL" >/dev/null 2>&1
    check_execution $? "Failed to download Discord" "Discord downloaded successfully"
}

function install_obsidian(){
    local DIR_DOWNLOAD=$1
    local OBSIDIAN_DEB="$DIR_DOWNLOAD/obsidian.deb"
    local OBSIDIAN_URL="$(wget -q -O - https://api.github.com/repos/obsidianmd/obsidian-releases/releases/latest | grep 'deb"$' | awk -F'"' '{print $4}')"

    message -subtitle "install obsidian"
    sleep 0.5

    wget -O "$OBSIDIAN_DEB" "$OBSIDIAN_URL" >/dev/null 2>&1
    check_execution $? "Failed to download Discord" "Discord downloaded successfully"
}



# function download_discord() {
#     message -subtitle "Installing Discord..."
#     sudo dpkg -i "$DISCORD_DEB"
#     check_execution $? "Failed to install Discord" "Discord installed successfully"
#     sudo apt-get install -f -y
# }

# function download_vscode() {
#     message -subtitle "Installing Visual Studio Code..."
#     sudo dpkg -i "$VSCODE_DEB"
#     check_execution $? "Failed to install Visual Studio Code" "Visual Studio Code installed successfully"
#     sudo apt-get install -f -y

#     # curl https://packages.microsoft.com/keys/microsoft.asc | gpg --dearmor > microsoft.gpg
#     # sudo install -o root -g root -m 644 microsoft.gpg /etc/apt/keyrings/microsoft-archive-keyring.gpg
#     # sudo sh -c 'echo "deb [arch=amd64,arm64,armhf signed-by=/etc/apt/keyrings/microsoft-archive-keyring.gpg] https://packages.microsoft.com/repos/code stable main" > /etc/apt/sources.list.d/vscode.list'
#     # sudo apt-get update
#     # sudo apt-get install code # or code-insiders
# }

# function install_brave() {
#     message -subtitle "Installing Brave Browser..."
#     sudo apt install -y curl
#     check_execution $? "Failed to install curl" "Curl installed successfully"
    
#     sudo curl -fsSLo /usr/share/keyrings/brave-browser-archive-keyring.gpg \
#     https://brave-browser-apt-release.s3.brave.com/brave-browser-archive-keyring.gpg
#     check_execution $? "Failed to download Brave Browser key" "Brave Browser key downloaded successfully"
    
#     echo "deb [signed-by=/usr/share/keyrings/brave-browser-archive-keyring.gpg] https://brave-browser-apt-release.s3.brave.com/ stable main" \
#     | sudo tee /etc/apt/sources.list.d/brave-browser-release.list
    
#     sudo apt update
#     check_execution $? "Failed to update package list" "Package list updated successfully"
    
#     sudo apt install -y brave-browser
#     check_execution $? "Failed to install Brave Browser" "Brave Browser installed successfully"
# }

set -e
sudo -v
TEMP_DIR=$(mktemp -d)

message -title "Temporary directory created: $TEMP_DIR"
sleep 0.5

while getopts "bvdo" opt; do
    case $opt in
        b) install_brave $DIR;;
        v) install_vscode $DIR;;
        d) install_discord $DIR;;
        o) install_obsidian $DIR;;
        *) usage ;;
    esac
done

rm -rf "$TEMP_DIR"
message -title "Process completed successfully."
sleep 0.5

exit 0
