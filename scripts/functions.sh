#!/usr/bin/env bash

#  ██╗   ██╗ █████╗ ██████╗ ██╗ █████╗ ██████╗ ██╗     ███████╗███████╗
#  ██║   ██║██╔══██╗██╔══██╗██║██╔══██╗██╔══██╗██║     ██╔════╝██╔════╝
#  ██║   ██║███████║██████╔╝██║███████║██████╔╝██║     █████╗  ███████╗
#  ╚██╗ ██╔╝██╔══██║██╔══██╗██║██╔══██║██╔══██╗██║     ██╔══╝  ╚════██║
#   ╚████╔╝ ██║  ██║██║  ██║██║██║  ██║██████╔╝███████╗███████╗███████║
#    ╚═══╝  ╚═╝  ╚═╝╚═╝  ╚═╝╚═╝╚═╝  ╚═╝╚═════╝ ╚══════╝╚══════╝╚══════╝

USER=$(whoami)
DISTRO=$(lsb_release -is)
DIR_REPO="$HOME/dotfiles-bspwm"

#   ██████╗ ██████╗ ██╗      ██████╗ ██████╗ ███████╗
#  ██╔════╝██╔═══██╗██║     ██╔═══██╗██╔══██╗██╔════╝
#  ██║     ██║   ██║██║     ██║   ██║██████╔╝███████╗
#  ██║     ██║   ██║██║     ██║   ██║██╔══██╗╚════██║
#  ╚██████╗╚██████╔╝███████╗╚██████╔╝██║  ██║███████║
#   ╚═════╝ ╚═════╝ ╚══════╝ ╚═════╝ ╚═╝  ╚═╝╚══════╝

RESETC="\033[0m\e[0m"
RED_COLOR="\033[0;31m\033[1m"
GRAY_COLOR="\033[0;37m\033[1m"
BLUE_COLOR="\033[0;34m\033[1m"
GREEN_COLOR="\033[0;32m\033[1m"
YELLOW_COLOR="\033[0;33m\033[1m"
PURPLE_COLOR="\033[0;35m\033[1m"
ORANGE_COLOR="\033[38;5;208m\033[1m" 
TURQUOISE_COLOR="\033[0;36m\033[1m"

#  ███████╗██╗   ██╗███╗   ██╗ ██████╗████████╗██╗ ██████╗ ███╗   ██╗███████╗
#  ██╔════╝██║   ██║████╗  ██║██╔════╝╚══██╔══╝██║██╔═══██╗████╗  ██║██╔════╝
#  █████╗  ██║   ██║██╔██╗ ██║██║        ██║   ██║██║   ██║██╔██╗ ██║███████╗
#  ██╔══╝  ██║   ██║██║╚██╗██║██║        ██║   ██║██║   ██║██║╚██╗██║╚════██║
#  ██║     ╚██████╔╝██║ ╚████║╚██████╗   ██║   ██║╚██████╔╝██║ ╚████║███████║
#  ╚═╝      ╚═════╝ ╚═╝  ╚═══╝ ╚═════╝   ╚═╝   ╚═╝ ╚═════╝ ╚═╝  ╚═══╝╚══════╝

function message() {
    local signal
    local color
    case "$1" in
        "-title")
            color="$GRAY_COLOR"
            signal="[$]"
            ;;
        "-subtitle")
            color="$PURPLE_COLOR"
            signal="[*]"
            ;;
        "-error")
            color="$RED_COLOR"
            signal="[-]"
            ;;
        "-warning")
            color="$YELLOW_COLOR"
            signal="[&]"
            ;;
        "-success")
            color="$GREEN_COLOR"
            signal="[+]"
            ;;
        "-cancel")
            color="$BLUE_COLOR"
            signal="[!]"
            ;;
        "-approval")
            color="$ORANGE_COLOR"
            signal="[?]"
            ;;
        *)
            color="$RESETC"
            signal=""
            ;;
    esac
    shift
    echo -e "\n${color}${signal} $*${RESETC}"
}

trap ctrl_c INT
function ctrl_c() {
    message -cancel "Exiting..."
    exit 1
}

function check_execution() {
    if [ $1 != 0 ] && [ $1 != 130 ]; then
        message -error "Error: $2"
        sleep 1
    else
        message -success "Successful: $3"
        sleep 1
    fi
}

function reboot_system() {
    while true; do
        message -warning "It's necessary to restart the system."
        message -approval "Do you want to restart the system now? (y|n)"
        read -r
        REPLY=${REPLY:-"y"}
        if [[ $REPLY =~ ^[Yy]$ ]]; then
            message -success "Restarting the system..."
            sleep 1
            sudo reboot
        elif [[ $REPLY =~ ^[Nn]$ ]]; then
            message -warning "Remember to restart the system as the environment will fail to reload all the configurations."
            exit 0
        else
            message -error "Invalid response, please try again."
            sleep 1
        fi
    done
}

function updating_packages() {
    message -title "Operating system package updates ($DISTRO)"
    sleep 1

    message -subtitle "Updating packages..."
    sudo apt update -y
    check_execution $? "Failed to updating packages" "Update packages"
    sleep 1

    message -subtitle "Upgrading packages..."
    sudo apt upgrade -y
    check_execution $? "Failed to Upgrading packages" "Upgrade packages"
    sleep 1
}

function detect_distro() {
    if [ -f /etc/os-release ]; then
        . /etc/os-release
        echo $ID
    else
        echo "unknown"
    fi
}

function install_packages() {
    local distro=$(detect_distro)
    local packages_files=$1
   
    if [ ! -f "$packages_files" ]; then
        message -error "File $packages_files does not exist"
        exit 1
    fi

    case "$distro" in
        debian|ubuntu|kali)
            while IFS= read -r package; do
                sudo apt install -y "$package" >/dev/null 2>&1
                check_execution $? "Failed installing $package" "Complete installation of $package"
            done < "$packages_files"
            ;;
        arch|manjaro)
            while IFS= read -r package; do
                sudo pacman -S --noconfirm "$package" >/dev/null 2>&1
                check_execution $? "Failed installing $package" "Complete installation of $package"
            done < "$packages_files"
            ;;
        fedora)
            while IFS= read -r package; do
                sudo dnf install -y "$package" >/dev/null 2>&1
                check_execution $? "Failed installing $package" "Complete installation of $package"
            done < "$packages_files"
            ;;
        *)
            message -cancel "Unsupported distribution: $distro"
            exit 1
            ;;
    esac
}

#  ███████╗███████╗████████╗████████╗██╗███╗   ██╗ ██████╗ ███████╗
#  ██╔════╝██╔════╝╚══██╔══╝╚══██╔══╝██║████╗  ██║██╔════╝ ██╔════╝
#  ███████╗█████╗     ██║      ██║   ██║██╔██╗ ██║██║  ███╗███████╗
#  ╚════██║██╔══╝     ██║      ██║   ██║██║╚██╗██║██║   ██║╚════██║
#  ███████║███████╗   ██║      ██║   ██║██║ ╚████║╚██████╔╝███████║
#  ╚══════╝╚══════╝   ╚═╝      ╚═╝   ╚═╝╚═╝  ╚═══╝ ╚═════╝ ╚══════╝

function setter_binaries() {
    local DIR_SOURCE="$DIR/bin"
    local DIR_DEST="$HOME/.local/bin"
    message -title "Settings of the personal bin directory"
    sleep 0.5
    if [ ! -d "$DIR_DEST" ]; then
        mkdir -p "$DIR_DEST"
        message -subtitle "Target directory $DIR_DEST was created."
    fi
    cp -rf "$DIR_SOURCE"/* "$DIR_DEST"
    sleep 0.5
    message -success "Configurations successfully copied to $DIR_DEST"
}

function setter_configs() {
    local DIR_SOURCE="$DIR/config"
    local DIR_DEST="$HOME/.config"
    message -title "Settings of the .config directory"
    sleep 0.5
    if [ ! -d "$DIR_DEST" ]; then
        mkdir -p "$DIR_DEST"
        message -subtitle "Target directory $DIR_DEST was created."
    fi
    cp -rf "$DIR_SOURCE"/* "$DIR_DEST"
    sleep 0.5
    message -success "Configurations successfully copied to $DIR_DEST"
}

function setter_homefiles() {
    local DIR_SOURCE="$DIR/home"
    local DIR_DEST="$HOME"
    message -title "Setting the home files"
    sleep 0.5
    shopt -s dotglob
    if [ ! -d "$DIR_DEST" ]; then
        mkdir -p "$DIR_DEST"
        message -subtitle "Target directory $DIR_DEST was created."
    fi
    cp -rf "$DIR_SOURCE"/* "$DIR_DEST"
    sleep 0.5
    message -success "Configurations successfully copied to $DIR_DEST"
    shopt -u dotglob
}

function setter_resources() {
    local RESOLUTION="1366x768"
    local DIR_WALLS_SOU="$HOME/dotfiles-visual-resources/wallpapers/$RESOLUTION"
    local DIR_ICONS_SOU="$HOME/dotfiles-visual-resources/icons"
    local DIR_WALLS_DES="$HOME/.wallpapers"
    local DIR_ICONS_DES="/usr/share/icons"

    message -title "Installing Resources"
    git clone https://github.com/edgar-ramxs/dotfiles-visual-resources.git ~/dotfiles-visual-resources >/dev/null 2>&1
    check_execution $? "Failed Resources download for $USER" "Complete download of $USER resources"
    sleep 0.5

    message -subtitle "Copying resources.."

    if [ ! -d "$DIR_WALLS_DES" ]; then
        mkdir -p "$DIR_WALLS_DES"
        message -subtitle "Target directory $DIR_WALLS_DES was created."
        sleep 0.5
    fi
    cp -rf "$DIR_WALLS_SOU"/* "$DIR_WALLS_DES"
    message -success "Resources successfully copied to $DIR_WALLS_DES"
    sleep 1

    # if [ ! -d "$DIR_ICONS_DES" ]; then
    #     mkdir -p "$DIR_ICONS_DES"
    #     message -subtitle "Target directory $DIR_ICONS_DES was created."
    #     sleep 0.5
    # fi
    # cp -rf "$DIR_ICONS_SOU"/* "$DIR_ICONS_DES"
    # message -success "Resources successfully copied to $DIR_ICONS_DES"
    # sleep 1
}

function setter_symbolic_links() {
    message -title "Symbolic link of root..."
    sleep 0.5
    sudo ln -sfv /home/$USER/.zshrc /root/.zshrc
    sudo ln -sfv /home/$USER/.profile /root/.profile
    sudo ln -sfv /home/$USER/.p10k.zsh /root/.p10k.zsh
    sleep 0.5
}

function setter_permissions(){
    message -title "Setting execution permissions to dotfiles..."
    sleep 0.5
    # BSPWM
    chmod +x "$HOME/.config/bspwm/bspwmrc"
    chmod +x "$HOME/.config/bspwm/scripts/bspwm_resize"
    chmod +x "$HOME/.config/bspwm/scripts/nitrogen.sh"
    chmod +x "$HOME/.config/bspwm/scripts/polybar.sh"
    # POLYBAR
    chmod +x "$HOME/.config/polybar/htb/network_status.sh"
    chmod +x "$HOME/.config/polybar/htb/set_target.sh"
    chmod +x "$HOME/.config/polybar/htb/vpn_status.sh"
    chmod +x "$HOME/.config/polybar/menu/bluetooth.sh"
    chmod +x "$HOME/.config/polybar/menu/networks.sh"
    chmod +x "$HOME/.config/polybar/menu/powermenu.sh"
    chmod +x "$HOME/.config/polybar/menu/weather_browser.sh"
    chmod +x "$HOME/.config/polybar/menu/weather.sh"
    chmod +x "$HOME/.config/polybar/menu/wifi.sh"
    # BIN
    chmod +x "$HOME/.local/bin/whichSystem.py"
}


