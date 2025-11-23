#!/usr/bin/env bash

#  ███████╗██╗      █████╗ ████████╗██████╗  █████╗ ██╗  ██╗    ██╗███╗   ██╗███████╗████████╗ █████╗ ██╗     ██╗     ███████╗██████╗
#  ██╔════╝██║     ██╔══██╗╚══██╔══╝██╔══██╗██╔══██╗██║ ██╔╝    ██║████╗  ██║██╔════╝╚══██╔══╝██╔══██╗██║     ██║     ██╔════╝██╔══██╗
#  █████╗  ██║     ███████║   ██║   ██████╔╝███████║█████╔╝     ██║██╔██╗ ██║███████╗   ██║   ███████║██║     ██║     █████╗  ██████╔╝
#  ██╔══╝  ██║     ██╔══██║   ██║   ██╔═══╝ ██╔══██║██╔═██╗     ██║██║╚██╗██║╚════██║   ██║   ██╔══██║██║     ██║     ██╔══╝  ██╔══██╗
#  ██║     ███████╗██║  ██║   ██║   ██║     ██║  ██║██║  ██╗    ██║██║ ╚████║███████║   ██║   ██║  ██║███████╗███████╗███████╗██║  ██║
#  ╚═╝     ╚══════╝╚═╝  ╚═╝   ╚═╝   ╚═╝     ╚═╝  ╚═╝╚═╝  ╚═╝    ╚═╝╚═╝  ╚═══╝╚══════╝   ╚═╝   ╚═╝  ╚═╝╚══════╝╚══════╝╚══════╝╚═╝  ╚═╝

# ========== MESSAGE DISPLAY ==========
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

# ========== DETECT DISTRO AND INSTALL FLATPAK ==========
function install_flatpak() {
    message -title "Detecting your distribution..."

    if [[ -f /etc/os-release ]]; then
        . /etc/os-release
        distro_id="${ID,,}"
        distro_like="${ID_LIKE,,}"
    else
        message -error "Cannot detect distribution."
        exiting_script
    fi

    message -subtitle "Detected: $NAME"

    case "$distro_id" in
        arch | manjaro )
            sudo pacman -Sy --noconfirm flatpak ;;
        debian | ubuntu | linuxmint | kali )
            sudo apt update && sudo apt install -y flatpak ;;
        fedora )
            sudo dnf install -y flatpak ;;
        opensuse* )
            sudo zypper install -y flatpak ;;
        *)
            if [[ "$distro_like" == *"debian"* ]]; then
                sudo apt update && sudo apt install -y flatpak
            elif [[ "$distro_like" == *"rhel"* || "$distro_like" == *"fedora"* ]]; then
                sudo dnf install -y flatpak
            else
                message -error "Unsupported distribution: $distro_id"
                exiting_script
            fi ;;
    esac

    message -success "Flatpak installed successfully."

    # Add Flathub if not present
    if ! flatpak remote-list | grep -q flathub; then
        message -subtitle "Adding Flathub repository..."
        sudo flatpak remote-add --if-not-exists flathub https://flathub.org/repo/flathub.flatpakrepo
        message -success "Flathub repository added."
    else
        message -warning "Flathub is already configured."
    fi
}

# ========== INSTALL FLATPAK APPS ==========
function install_flatpak_apps() {
    message -title "Installing Flatpak applications..."

    local APPS=(
        "com.github.tchx84.Flatseal"
        "com.bitwarden.desktop"
        "com.spotify.Client"
        "org.gnome.Loupe"
        "org.gnome.Calculator"
        "org.gnome.Calendar"
        "org.gnome.Weather"
        "io.github.celluloid_player.Celluloid"
        "org.gnome.Extensions"
    )

    for app in "${APPS[@]}"; do
        message -subtitle "Installing: $app"
        if flatpak install -y flathub "$app" >/dev/null 2>&1; then
            message -success "$app installed."
        else
            message -error "Failed to install $app."
        fi
    done

    message -approval "All Flatpak applications processed."
}

# ========== MAIN EXECUTION ==========
sudo -v
install_flatpak
install_flatpak_apps
