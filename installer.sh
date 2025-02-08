#!/usr/bin/env bash

sudo -v

#  ██╗   ██╗ █████╗ ██████╗ ██╗ █████╗ ██████╗ ██╗     ███████╗███████╗
#  ██║   ██║██╔══██╗██╔══██╗██║██╔══██╗██╔══██╗██║     ██╔════╝██╔════╝
#  ██║   ██║███████║██████╔╝██║███████║██████╔╝██║     █████╗  ███████╗
#  ╚██╗ ██╔╝██╔══██║██╔══██╗██║██╔══██║██╔══██╗██║     ██╔══╝  ╚════██║
#   ╚████╔╝ ██║  ██║██║  ██║██║██║  ██║██████╔╝███████╗███████╗███████║
#    ╚═══╝  ╚═╝  ╚═╝╚═╝  ╚═╝╚═╝╚═╝  ╚═╝╚═════╝ ╚══════╝╚══════╝╚══════╝

DIR=$(pwd)
USER=$(whoami)
DISTRO=$(grep -i '^ID=' /etc/os-release | cut -d= -f2 | tr -d '"' | tr '[:upper:]' '[:lower:]')
P_SHELL=""
P_THEME=""
P_PACKAGES=""
P_RESOLUTION=""

#  ███████╗██╗   ██╗███╗   ██╗ ██████╗████████╗██╗ ██████╗ ███╗   ██╗███████╗
#  ██╔════╝██║   ██║████╗  ██║██╔════╝╚══██╔══╝██║██╔═══██╗████╗  ██║██╔════╝
#  █████╗  ██║   ██║██╔██╗ ██║██║        ██║   ██║██║   ██║██╔██╗ ██║███████╗
#  ██╔══╝  ██║   ██║██║╚██╗██║██║        ██║   ██║██║   ██║██║╚██╗██║╚════██║
#  ██║     ╚██████╔╝██║ ╚████║╚██████╗   ██║   ██║╚██████╔╝██║ ╚████║███████║
#  ╚═╝      ╚═════╝ ╚═╝  ╚═══╝ ╚═════╝   ╚═╝   ╚═╝ ╚═════╝ ╚═╝  ╚═══╝╚══════╝

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

function usage() {
    message -title "Usage: $0 -s [option] -r [option] -p [option] -t [option]"
    message -subtitle "Parameter     Target  Options                 Description"
    message -warning "shell         -s      [bash|zsh]              Download and install Discord"
    message -warning "resolution    -r      [1920x1080|1366x768]    Download and install Visual Studio Code"
    message -warning "packages      -p      [all|dev|hack|games]    Install Brave Browser"
    message -warning "theme         -t      [a|b|c]                 Install Brave Browser"
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
        sleep 0.5
    else
        message -success "Successful: $3"
        sleep 0.5
    fi
}

function reboot_system() {
    local attempts=0
    local max_attempts=3
    
    message -title "Reboot: It's necessary to restart the system."
    while (( attempts < max_attempts )); do
        message -approval "Do you want to restart the system now? (yes|y|no|n)"
        read -r REPLY
        REPLY=${REPLY,,}
        
        case "$REPLY" in
            yes|y)
                message -cancel "Restarting the system..."
                sleep 1
                sudo reboot
            ;;
            no|n)
                message -warning "Remember to restart the system as the environment will fail to reload all configurations."
                message -cancel "Exiting...\n"
                exit 0
            ;;
            *)
                message -error "Invalid response. Please enter 'yes', 'y', 'no', or 'n'."
                ((attempts++))
                if (( attempts == max_attempts )); then
                    message -cancel "Too many invalid attempts. Exiting...\n"
                    exit 1
                fi
            ;;
        esac
    done
}

function updating_packages() {
    message -title "Operating System Package Updates ($DISTRO)"
    sleep 0.5
    
    message -subtitle "Requesting sudo permissions..."
    if ! sudo -v; then
        message -error "Failed to authenticate sudo. Please check your password."
        exit 1
    fi
    
    case "$DISTRO" in
        debian|ubuntu|kali|mint|parrot)
            message -subtitle "Updating package list..."
            sudo apt update -y >/dev/null 2>&1
            check_execution $? "Failed to update package list." "Package list updated successfully."
            
            message -subtitle "Upgrading installed packages..."
            sudo apt upgrade -y >/dev/null 2>&1
            check_execution $? "Failed to upgrade packages." "Packages upgraded successfully."
        ;;
        
        arch|manjaro)
            message -subtitle "Updating package list..."
            sudo pacman -Sy --noconfirm >/dev/null 2>&1
            check_execution $? "Failed to update package list." "Package list updated successfully."
            
            message -subtitle "Upgrading installed packages..."
            sudo pacman -Syu --noconfirm >/dev/null 2>&1
            check_execution $? "Failed to upgrade packages." "Packages upgraded successfully."
        ;;
        
        fedora)
            message -subtitle "Updating and upgrading packages..."
            sudo dnf upgrade --refresh -y >/dev/null 2>&1
            check_execution $? "Failed to update packages." "Packages upgraded successfully."
        ;;
        
        opensuse*)
            message -subtitle "Updating package list..."
            sudo zypper refresh >/dev/null 2>&1
            check_execution $? "Failed to refresh repositories." "Repositories refreshed successfully."
            
            message -subtitle "Upgrading installed packages..."
            sudo zypper update -y >/dev/null 2>&1
            check_execution $? "Failed to upgrade packages." "Packages upgraded successfully."
        ;;
        
        alpine)
            message -subtitle "Updating and upgrading packages..."
            sudo apk update >/dev/null 2>&1 && sudo apk upgrade >/dev/null 2>&1
            check_execution $? "Failed to upgrade packages." "Packages upgraded successfully."
        ;;
        
        *)
            message -error "Package manager not supported for this distribution: $DISTRO"
            return 1
        ;;
    esac
    
    message -success "All packages are up to date."
    sleep 0.5
}

#  ██╗███╗   ██╗███████╗████████╗ █████╗ ██╗     ██╗     ███████╗██████╗ ███████╗
#  ██║████╗  ██║██╔════╝╚══██╔══╝██╔══██╗██║     ██║     ██╔════╝██╔══██╗██╔════╝
#  ██║██╔██╗ ██║███████╗   ██║   ███████║██║     ██║     █████╗  ██████╔╝███████╗
#  ██║██║╚██╗██║╚════██║   ██║   ██╔══██║██║     ██║     ██╔══╝  ██╔══██╗╚════██║
#  ██║██║ ╚████║███████║   ██║   ██║  ██║███████╗███████╗███████╗██║  ██║███████║
#  ╚═╝╚═╝  ╚═══╝╚══════╝   ╚═╝   ╚═╝  ╚═╝╚══════╝╚══════╝╚══════╝╚═╝  ╚═╝╚══════╝

function install_packages() {
    message -title "Installation of packages for $DISTRO distribution"
    sleep 0.5
    
    case "$DISTRO" in
        debian|ubuntu|kali|mint|parrot)
            message -subtitle "Checking and installing packages for APT-based systems..."
            local PACKAGES_FILE="$DIR/packages/debian/list-packages.txt"
            if [[ ! -f "$PACKAGES_FILE" ]]; then
                message -cancel "There is no file related to your distribution."
                exit 1
            fi
            
            message -subtitle "File detected. Starting package installation..."
            sleep 0.5
            
            grep -Ev '^#|^$' "$PACKAGES_FILE" | while IFS= read -r package; do
                if apt-cache show "$package" &>/dev/null; then
                    sudo apt install -y "$package" >/dev/null 2>&1
                    if [[ $? -eq 0 ]]; then
                        message -success "(installed) $package"
                    else
                        message -error "(failed to install) $package"
                    fi
                else
                    message -error "(not available) $package"
                fi
            done
        ;;
        
        arch|manjaro)
            message -subtitle "Checking and installing packages for Pacman-based systems..."
            local PACKAGES_FILE="$DIR/packages/arch/list-packages.txt"
            if [[ ! -f "$PACKAGES_FILE" ]]; then
                message -cancel "There is no file related to your distribution."
                exit 1
            fi
            
            message -subtitle "File detected. Starting package installation..."
            sleep 0.5
            
            grep -Ev '^#|^$' "$PACKAGES_FILE" | while IFS= read -r package; do
                if pacman -Si "$package" &>/dev/null; then
                    sudo pacman -S --noconfirm "$package" >/dev/null 2>&1
                    if [[ $? -eq 0 ]]; then
                        message -success "(installed) $package"
                    else
                        message -error "(failed to install) $package"
                    fi
                else
                    message -error "(not available) $package"
                fi
            done
        ;;
        
        fedora)
            message -subtitle "Checking and installing packages for DNF-based systems..."
            local PACKAGES_FILE="$DIR/packages/fedora/list-packages.txt"
            if [[ ! -f "$PACKAGES_FILE" ]]; then
                message -cancel "There is no file related to your distribution."
                exit 1
            fi
            
            message -subtitle "File detected. Starting package installation..."
            sleep 0.5
            
            grep -Ev '^#|^$' "$PACKAGES_FILE" | while IFS= read -r package; do
                if dnf info "$package" &>/dev/null; then
                    sudo dnf install -y "$package" >/dev/null 2>&1
                    if [[ $? -eq 0 ]]; then
                        message -success "(installed) $package"
                    else
                        message -error "(failed to install) $package"
                    fi
                else
                    message -error "(not available) $package"
                fi
            done
        ;;
        
        opensuse*)
            message -subtitle "Checking and installing packages for Zypper-based systems..."
            local PACKAGES_FILE="$DIR/packages/opensuse/list-packages.txt"
            if [[ ! -f "$PACKAGES_FILE" ]]; then
                message -cancel "There is no file related to your distribution."
                exit 1
            fi
            
            message -subtitle "File detected. Starting package installation..."
            sleep 0.5
            
            grep -Ev '^#|^$' "$PACKAGES_FILE" | while IFS= read -r package; do
                if zypper info "$package" &>/dev/null; then
                    sudo zypper install -y "$package" >/dev/null 2>&1
                    if [[ $? -eq 0 ]]; then
                        message -success "(installed) $package"
                    else
                        message -error "(failed to install) $package"
                    fi
                else
                    message -error "(not available) $package"
                fi
            done
        ;;
        
        alpine)
            message -subtitle "Checking and installing packages for APK-based systems..."
            local PACKAGES_FILE="$DIR/packages/alpine/list-packages.txt"
            if [[ ! -f "$PACKAGES_FILE" ]]; then
                message -cancel "There is no file related to your distribution."
                exit 1
            fi
            
            message -subtitle "File detected. Starting package installation..."
            sleep 0.5
            
            grep -Ev '^#|^$' "$PACKAGES_FILE" | while IFS= read -r package; do
                if apk info "$package" &>/dev/null; then
                    sudo apk add "$package" >/dev/null 2>&1
                    if [[ $? -eq 0 ]]; then
                        message -success "(installed) $package"
                    else
                        message -error "(failed to install) $package"
                    fi
                else
                    message -error "(not available) $package"
                fi
            done
        ;;
        
        *)
            message -error "Package manager not supported for this distribution: $DISTRO"
            return 1
        ;;
    esac
    
    message -success "Package installation completed for $DISTRO."
}

function install_fonts(){
    local FONTS=("FiraCode" "CascadiaCode" "Iosevka" "Hack" "JetBrainsMono")
    local DIR_FONTS="/usr/share/fonts"
    local DIR_DOWNLOADS="/tmp/fonts_tmp"
    mkdir -p "$DIR_DOWNLOADS"
    sleep 0.5
    
    if ! command -v curl &>/dev/null || ! command -v tar &>/dev/null; then
        message -error "Dependencies missing: curl and tar are required. Please install them first."
        exit 1
    fi
    
    message -title "Installing and downloading Nerd Fonts."
    sleep 0.5
    
    for font in "${FONTS[@]}"; do
        local FONT_DIR="$DIR_FONTS/${font}"
        local FONT_URL="https://github.com/ryanoasis/nerd-fonts/releases/latest/download/${font}.tar.xz"
        local FONT_ARCHIVE="$DIR_DOWNLOADS/${font}.tar.xz"
        
        message -subtitle "Downloading ${font}..."
        if ! curl -L "$FONT_URL" -o "$FONT_ARCHIVE" --silent --fail; then
            message -error "Error: ${font} could not be downloaded."
            continue
        fi
        
        if ! tar -tf "$FONT_ARCHIVE" &>/dev/null; then
            message -error "Error: ${font} archive is invalid."
            rm -f "$FONT_ARCHIVE"
            continue
        fi
        
        if [[ -d "$FONT_DIR" ]]; then
            message -warning "The ${font} folder already exists. Replacing it..."
            sudo rm -rf "$FONT_DIR"
        fi
        
        message -success "Installing ${font}..."
        sudo mkdir -p "$FONT_DIR"
        if sudo tar -xf "$FONT_ARCHIVE" -C "$FONT_DIR" --wildcards "*.ttf" >/dev/null 2>&1; then
            message -success "${font} installed successfully."
        else
            message -error "Error: Failed to extract ${font}."
        fi
    done
    
    rm -rf "$DIR_DOWNLOADS"
    
    message -subtitle "Reloading font cache..."
    sudo fc-cache -fv >/dev/null 2>&1
    sleep 1
    
    message -success "Nerd Fonts installation complete!"
    
}

function install_pywal() {
    message -title "Pywal Installation"
    sleep 0.5
    
    local PIP_CMD=""
    if command -v pip3 &>/dev/null; then
        PIP_CMD="pip3"
        elif command -v pip &>/dev/null; then
        PIP_CMD="pip"
    else
        message -error "Neither pip3 nor pip is installed. Please install pip3 or pip before proceeding."
        exit 1
    fi
    
    message -subtitle "Using $PIP_CMD for installation."
    sleep 0.5
    
    sudo $PIP_CMD install setuptools --break-system-packages >/dev/null 2>&1
    check_execution $? "Failed to install setuptools. Please check your Python environment." "Setuptools installed successfully."
    sleep 0.5
    
    sudo $PIP_CMD install pywal --break-system-packages >/dev/null 2>&1
    check_execution $? "Failed to install pywal. Please check your Python environment." "Pywal installed successfully."
    sleep 0.5
    
    if command -v wal &>/dev/null; then
        message -warning "Pywal is installed and ready to use."
    else
        message -error "Pywal installation completed, but the 'wal' command is not found. Check your PATH."
        exit 1
    fi
}

#  ███████╗███████╗████████╗████████╗██╗███╗   ██╗ ██████╗ ███████╗
#  ██╔════╝██╔════╝╚══██╔══╝╚══██╔══╝██║████╗  ██║██╔════╝ ██╔════╝
#  ███████╗█████╗     ██║      ██║   ██║██╔██╗ ██║██║  ███╗███████╗
#  ╚════██║██╔══╝     ██║      ██║   ██║██║╚██╗██║██║   ██║╚════██║
#  ███████║███████╗   ██║      ██║   ██║██║ ╚████║╚██████╔╝███████║
#  ╚══════╝╚══════╝   ╚═╝      ╚═╝   ╚═╝╚═╝  ╚═══╝ ╚═════╝ ╚══════╝

function copy_configs() {
    local DIR_SOURCE="$1"
    local DIR_DEST="$2"
    local TITLE="$3"
    
    message -subtitle "$TITLE"
    if [ ! -d "$DIR_DEST" ]; then
        mkdir -p "$DIR_DEST"
        message -warning "Target directory $DIR_DEST was created."
    fi
    
    cp -rf "$DIR_SOURCE"/* "$DIR_DEST"
    message -success "Configurations successfully copied to $DIR_DEST"
    sleep 0.5
}

function setter_configs() {
    message -title "Installing Configs"
    copy_configs "$DIR/config" "$HOME/.config" "Setting up .config directory"
    
    message -title "Installing Binaries"
    copy_configs "$DIR/bin" "$HOME/.local/bin" "Setting up personal binaries"
    
    message -title "Installing Wallpapers"
    copy_configs "$DIR/wallpapers/$P_RESOLUTION" "$HOME/.config/wallpapers" "Copying wallpapers to $USER's profile"
    
    # # ICONS
    # copy_configs "$DIR_RESOURCES/icons" "/usr/share/icons" "Copying icons to the system"
    
    # # THEMES
    # copy_configs "$DIR_RESOURCES/themes" "/usr/share/themes" "Copying themes into the system"
    
    # # GRUB
    # copy_configs "$DIR_RESOURCES/grub" "/boot/grub/themes" "Copying grub themes to the system"
}

function setter_homefiles() {
    local current_shell=$(basename "$SHELL")
    
    message -title "Installing Home Files"
    sleep 0.5
    
    shopt -s dotglob
    
    for file in .aliases .exports .functions .profile; do
        if [[ -f "$DIR/home/$file" ]]; then
            cp -rf --preserve=mode,ownership "$DIR/home/$file" "$HOME/"
            message -success "Copied $file to $HOME."
        else
            message -error "$file does not exist in $DIR/home. Skipping."
        fi
    done

    case "$current_shell" in
        bash)   copy_configs "$DIR/home/bash" "$HOME" "Copying Bash configuration";;
        zsh)    copy_configs "$DIR/home/zsh" "$HOME" "Copying Zsh configuration";;
        *)      message -error "Unknown shell: $current_shell. Skipping shell-specific files.";;
    esac
    
    shopt -u dotglob
    
    message -warning "Home files installation completed."
    sleep 0.5
}

function setter_permissions() {
    local EXTENSIONS=("*.sh" "*.py")
    local DIRECTORIES=(
        "$HOME/.config/bspwm/scripts"
        "$HOME/.config/polybar/scripts"
        "$HOME/.config/rofi/htb"
        "$HOME/.config/rofi/scripts"
        "$HOME/.local/bin"
    )

    message -title "Setting execution permissions to specified file types..."
    sleep 0.5
    
    for dir in "${DIRECTORIES[@]}"; do
        if [[ -d "$dir" ]]; then
            message -subtitle "Processing directory: $dir"
            for ext in "${EXTENSIONS[@]}"; do
                while IFS= read -r file; do
                    chmod +x "$file"
                    message -success "Execution permission set: $file"
                done < <(find "$dir" -type f -name "$ext")
            done
        else
            message -warning "Directory not found: $dir"
        fi
    done
    
    message -success "Execution permissions have been set for all specified file types in the directories."
    sleep 0.5
}

function setter_symbolic_links() {
    local ROOT_HOME="/root"
    local CURRENT_SHELL=$(basename "$SHELL")
    local COMMON_FILES=(".profile" ".aliases" ".exports" ".functions")

    message -title "Creating symbolic links in root user directory..."
    sleep 0.5
    
    declare -A SHELL_FILES=(
        ["zsh"]=".zshrc .p10k.zsh"
        ["bash"]=".bashrc .bash_logout"
    )
    
    message -subtitle "Linking common files..."
    sleep 0.5
    for file in "${COMMON_FILES[@]}"; do
        if [[ -f "$HOME/$file" ]]; then
            sudo ln -sfv "$HOME/$file" "$ROOT_HOME/$file" >/dev/null 2>&1
            message -success "Linked $HOME/$file to $ROOT_HOME/$file"
        else
            message -warning "$file not found in $HOME. Skipping."
        fi
    done
    
    case "$CURRENT_SHELL" in
        zsh|bash)
            message -subtitle "Linking [$CURRENT_SHELL] configuration..."
            sleep 0.5
            for file in ${SHELL_FILES[$CURRENT_SHELL]}; do
                if [[ -f "$HOME/$file" ]]; then
                    sudo ln -sfv "$HOME/$file" "$ROOT_HOME/$file" >/dev/null 2>&1
                    message -success "Linked $HOME/$file to $ROOT_HOME/$file"
                else
                    message -warning "$file not found in $HOME. Skipping."
                fi
            done
        ;;
        *)
            message -error "Unknown shell: $CURRENT_SHELL. No shell-specific files were linked."
        ;;
    esac
    
    sleep 0.5
}

#  ███╗   ███╗ █████╗ ██╗███╗   ██╗
#  ████╗ ████║██╔══██╗██║████╗  ██║
#  ██╔████╔██║███████║██║██╔██╗ ██║
#  ██║╚██╔╝██║██╔══██║██║██║╚██╗██║
#  ██║ ╚═╝ ██║██║  ██║██║██║ ╚████║
#  ╚═╝     ╚═╝╚═╝  ╚═╝╚═╝╚═╝  ╚═══╝

while getopts ":s:r:p:t:" opt; do
    case ${opt} in
        s) P_SHELL="$OPTARG"
            [[ "$P_SHELL" =~ ^(bash|zsh)$ ]] || usage
        ;;
        r) P_RESOLUTION="$OPTARG"
            [[ "$P_RESOLUTION" =~ ^(1920x1080|1366x768)$ ]] || usage
        ;;
        p) P_PACKAGES="$OPTARG"
            [[ "$P_PACKAGES" =~ ^(all|dev|hack|games)$ ]] || usage
        ;;
        t) P_THEME="$OPTARG"
            [[ "$P_THEME" =~ ^(a|b|c)$ ]] || usage
        ;;
        *) usage ;;
    esac
done


if [[ -z "$P_SHELL" || -z "$P_RESOLUTION" || -z "$P_PACKAGES" || -z "$P_THEME" ]]; then
    usage
fi


if [ "$UID" -eq 0 ]; then
    message -error "You should not run the script as the root user!"
    exit 1
fi

updating_packages

install_packages
install_fonts
install_pywal

xdg-user-dirs-update

setter_configs
setter_homefiles
setter_permissions
setter_symbolic_links

reboot_system
