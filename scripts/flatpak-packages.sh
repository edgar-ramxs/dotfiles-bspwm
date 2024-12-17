#!/usr/bin/env bash

#  ███████╗██╗      █████╗ ████████╗██████╗  █████╗ ██╗  ██╗    ██╗███╗   ██╗███████╗████████╗ █████╗ ██╗     ██╗     ███████╗██████╗ 
#  ██╔════╝██║     ██╔══██╗╚══██╔══╝██╔══██╗██╔══██╗██║ ██╔╝    ██║████╗  ██║██╔════╝╚══██╔══╝██╔══██╗██║     ██║     ██╔════╝██╔══██╗
#  █████╗  ██║     ███████║   ██║   ██████╔╝███████║█████╔╝     ██║██╔██╗ ██║███████╗   ██║   ███████║██║     ██║     █████╗  ██████╔╝
#  ██╔══╝  ██║     ██╔══██║   ██║   ██╔═══╝ ██╔══██║██╔═██╗     ██║██║╚██╗██║╚════██║   ██║   ██╔══██║██║     ██║     ██╔══╝  ██╔══██╗
#  ██║     ███████╗██║  ██║   ██║   ██║     ██║  ██║██║  ██╗    ██║██║ ╚████║███████║   ██║   ██║  ██║███████╗███████╗███████╗██║  ██║
#  ╚═╝     ╚══════╝╚═╝  ╚═╝   ╚═╝   ╚═╝     ╚═╝  ╚═╝╚═╝  ╚═╝    ╚═╝╚═╝  ╚═══╝╚══════╝   ╚═╝   ╚═╝  ╚═╝╚══════╝╚══════╝╚══════╝╚═╝  ╚═╝

set -e
sudo -v

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
        exit 1
    else
        message -success "$3"
    fi
}


message -title "Installing Flatpak and GNOME Flatpak Plugin..."
sudo apt update -y >/dev/null 2>&1
sudo apt install -y flatpak gnome-software-plugin-flatpak >/dev/null 2>&1
check_execution $? "Failed to install Flatpak and plugin." "Flatpak and plugin installed successfully."


message -title "Adding Flathub repository..."
sudo flatpak remote-add --if-not-exists flathub https://dl.flathub.org/repo/flathub.flatpakrepo
check_execution $? "Failed to add Flathub repository." "Flathub repository added successfully."


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


function install_flatpak() {
    local package=$1
    message -title "Installing Flatpak package: $package..."
    flatpak install -y flathub "$package" >/dev/null 2>&1
    check_execution $? "Failed to install $package." "$package installed successfully."
    sleep 1
}

for package in "${FLATPAK_PACKAGES[@]}"; do
    install_flatpak "$package"
done

message -success "All Flatpak packages have been installed and launched successfully."
