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
        "-title")       color="\033[0;37m\033[1m"; signal="[$]"; shift; echo -e "\n${color}${signal} $*${RESETC}";;
        "-subtitle")    color="\033[0;35m\033[1m"; signal="[*]"; shift; echo -e "\n\t${color}${signal} $*${RESETC}";;
        "-approval")    color="\033[38;5;51m\033[1m"; signal="[?]"; shift; echo -e "\n${color}${signal} $*${RESETC}";;
        "-success")     color="\033[0;32m\033[1m"; signal="[+]"; shift; echo -e "\t${color}${signal} $*${RESETC}";;
        "-warning")     color="\033[0;33m\033[1m"; signal="[&]"; shift; echo -e "\t${color}${signal} $*${RESETC}";;
        "-error")       color="\033[0;31m\033[1m"; signal="[-]"; shift; echo -e "\t${color}${signal} $*${RESETC}";;
        "-cancel")      color="\033[0;34m\033[1m"; signal="[!]"; shift; echo -e "\n${color}${signal} $*${RESETC}\n";;
        *)              color="$RESETC"; signal=""; shift; echo -e "${color}${signal} $*${RESETC}";;
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



# # Ensure Flatpak is installed
# function ensure_flatpak() {
#     if ! command -v flatpak &>/dev/null; then
#         message -title "Flatpak is not installed. Installing Flatpak..."
#         sudo apt update -y >/dev/null 2>&1
#         sudo apt install -y flatpak gnome-software-plugin-flatpak >/dev/null 2>&1
#         check_execution $? "Failed to install Flatpak and GNOME plugin." "Flatpak and GNOME plugin installed successfully."
#     else
#         message -info "Flatpak is already installed."
#     fi
# }

# # Add Flathub repository if it doesn't exist
# function add_flathub_repo() {
#     message -title "Adding Flathub repository..."
#     sudo flatpak remote-add --if-not-exists flathub https://dl.flathub.org/repo/flathub.flatpakrepo
#     check_execution $? "Failed to add Flathub repository." "Flathub repository added successfully."
# }

# # Install a Flatpak package
# function install_flatpak_package() {
#     local package=$1
#     message -subtitle "Installing: $package..."
#     flatpak install -y flathub "$package" >/dev/null 2>&1
#     check_execution $? "Failed to install $package." "$package installed successfully."
#     sleep 1
# }

# # Main script
# function main() {
#     # Step 1: Ensure Flatpak is installed
#     ensure_flatpak

#     # Step 2: Add Flathub repository
#     add_flathub_repo

#     # Step 3: List of Flatpak packages to install
#     declare -a FLATPAK_PACKAGES=(
#         "com.bitwarden.desktop"
#         "md.obsidian.Obsidian"
#         "org.libreoffice.LibreOffice"
#         "com.obsproject.Studio"
#         "org.kde.kdenlive"
#         "com.discordapp.Discord"
#         "com.brave.Browser"
#         "org.DolphinEmu.dolphin-emu"
#         "org.libretro.RetroArch"
#         "org.gnome.Boxes"
#     )

#     # Step 4: Install each Flatpak package
#     for package in "${FLATPAK_PACKAGES[@]}"; do
#         install_flatpak_package "$package"
#     done

#     message -success "All Flatpak packages have been installed successfully!"
# }

# # Run the script
# main