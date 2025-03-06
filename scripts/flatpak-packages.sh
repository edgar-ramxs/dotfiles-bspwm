#!/usr/bin/env bash

#  ███████╗██╗      █████╗ ████████╗██████╗  █████╗ ██╗  ██╗    ██╗███╗   ██╗███████╗████████╗ █████╗ ██╗     ██╗     ███████╗██████╗
#  ██╔════╝██║     ██╔══██╗╚══██╔══╝██╔══██╗██╔══██╗██║ ██╔╝    ██║████╗  ██║██╔════╝╚══██╔══╝██╔══██╗██║     ██║     ██╔════╝██╔══██╗
#  █████╗  ██║     ███████║   ██║   ██████╔╝███████║█████╔╝     ██║██╔██╗ ██║███████╗   ██║   ███████║██║     ██║     █████╗  ██████╔╝
#  ██╔══╝  ██║     ██╔══██║   ██║   ██╔═══╝ ██╔══██║██╔═██╗     ██║██║╚██╗██║╚════██║   ██║   ██╔══██║██║     ██║     ██╔══╝  ██╔══██╗
#  ██║     ███████╗██║  ██║   ██║   ██║     ██║  ██║██║  ██╗    ██║██║ ╚████║███████║   ██║   ██║  ██║███████╗███████╗███████╗██║  ██║
#  ╚═╝     ╚══════╝╚═╝  ╚═╝   ╚═╝   ╚═╝     ╚═╝  ╚═╝╚═╝  ╚═╝    ╚═╝╚═╝  ╚═══╝╚══════╝   ╚═╝   ╚═╝  ╚═╝╚══════╝╚══════╝╚══════╝╚═╝  ╚═╝

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

function ensure_flatpak() {
    message -title "Installing Flatpak and GNOME Flatpak Plugin..."
    if ! command -v flatpak &>/dev/null; then
        message -subtitle "Flatpak is not installed. Installing Flatpak..."
        sudo apt update -y >/dev/null 2>&1
        sudo apt install -y flatpak gnome-software-plugin-flatpak >/dev/null 2>&1
        check_execution $? "Failed to install Flatpak and GNOME plugin." "Flatpak and GNOME plugin installed successfully."
    else
        message -subtitle "Flatpak is already installed."
    fi
    sleep 1
}

function add_flathub_repo() {
    message -title "Adding Flathub repository..."
    sudo flatpak remote-add --if-not-exists flathub https://dl.flathub.org/repo/flathub.flatpakrepo
    check_execution $? "Failed to add Flathub repository." "Flathub repository added successfully."
    sleep 1
}

function install_flatpak_package() {
    local package=$1
    message -subtitle "Installing: $package..."
    flatpak install -y flathub "$package" >/dev/null 2>&1
    check_execution $? "Failed to install $package." "$package installed successfully."
    sleep 1
}

function main() {
    ensure_flatpak
    add_flathub_repo
    declare -a FLATPAK_PACKAGES=(
        "com.bitwarden.desktop"
        "md.obsidian.Obsidian"
        "org.libreoffice.LibreOffice"
        "com.obsproject.Studio"
        "org.kde.kdenlive"
        "com.discordapp.Discord"
        "com.brave.Browser"
        "org.DolphinEmu.dolphin-emu"
        "org.libretro.RetroArch"
        "org.gnome.Boxes"
    )
    message -title "Installing Flatpak packages"
    for package in "${FLATPAK_PACKAGES[@]}"; do
        install_flatpak_package "$package"
    done
    
    message -success "All Flatpak packages have been installed successfully!"
    exit 1
}

set -e
sudo -v

main
