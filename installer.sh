#!/usr/bin/env bash

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
P_RESOLUTION=""
P_INSTALLATION=""

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
        "-cancel")      color="\033[0;34m\033[1m";      signal="[!]"; shift; echo -e "\n${color}${signal} $*${RESETC}";;
        "-success")     color="\033[0;32m\033[1m";      signal="[+]"; shift; echo -e "\t${color}${signal} $*${RESETC}";;
        "-warning")     color="\033[0;33m\033[1m";      signal="[&]"; shift; echo -e "\t${color}${signal} $*${RESETC}";;
        "-error")       color="\033[0;31m\033[1m";      signal="[-]"; shift; echo -e "\t${color}${signal} $*${RESETC}";;
        *)              color="$RESETC";                signal=""; shift; echo -e "${color}${signal} $*${RESETC}";;
    esac
}

function usage() {
    message -title "Usage: $0 -s [option] -r [option]"
    message -warning "Parameter     Target  Options                 Description"
    message -success "Shell         -s      [bash|zsh]              Set default shell"
    message -success "Resolution    -r      [1920x1080|1366x768]    Set default screen resolution for wallpapers"
    message -success "Installation  -i      [virtual|native]        Set the default installation level"
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

function reboot_system() {
    local attempts=0
    local max_attempts=3
    message -title "Reboot: It's necessary to restart the system."
    while (( attempts < max_attempts )); do
        message -approval "Do you want to restart the system now? [yes|y] or [no|n]"
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
    case "$DISTRO" in
        debian|ubuntu|kali|linuxmint|parrot)
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
        *)
            message -error "Package manager not supported for this distribution: $DISTRO"
            return 1
        ;;
    esac
    message -success "All packages are up to date."
    sleep 0.5
}

function copy_configs() {
    local DIR_SOURCE="$1"
    local DIR_DEST="$2"
    local TITLE="$3"
    message -subtitle "$TITLE"
    sleep 0.5
    if [ ! -d "$DIR_DEST" ]; then
        mkdir -p "$DIR_DEST"
        message -warning "Target directory $DIR_DEST was created."
    fi
    cp -rf "$DIR_SOURCE"/* "$DIR_DEST"
    message -success "Configurations successfully copied to $DIR_DEST"
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
        debian|ubuntu|kali|linuxmint|parrot)
            local PACKAGES_FILE="$DIR/packages/debian/list-packages.txt"
            message -subtitle "Checking and installing packages for APT-based systems..."
            if [[ ! -f "$PACKAGES_FILE" ]]; then
                message -cancel "There is no file related to your distribution."
                exit 1
            fi
            message -subtitle "File detected. Starting package installation..."
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
            local PACKAGES_FILE="$DIR/packages/arch/list-packages.txt"
            message -subtitle "Checking and installing packages for Pacman-based systems..."
            if [[ ! -f "$PACKAGES_FILE" ]]; then
                message -cancel "There is no file related to your distribution."
                exit 1
            fi
            message -subtitle "File detected. Starting package installation..."
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
            local PACKAGES_FILE="$DIR/packages/fedora/list-packages.txt"
            message -subtitle "Checking and installing packages for DNF-based systems..."
            if [[ ! -f "$PACKAGES_FILE" ]]; then
                message -cancel "There is no file related to your distribution."
                exit 1
            fi
            message -subtitle "File detected. Starting package installation..."
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
        *)
            message -error "Package manager not supported for this distribution: $DISTRO"
            return 1
        ;;
    esac
    message -warning "Package installation completed for $DISTRO."
    sleep 0.5
}

function install_fonts(){
    local FONTS=("FiraCode" "CascadiaCode" "Iosevka" "Hack" "JetBrainsMono" "Meslo" "Mononoki" "RobotoMono" "0xProto") 
    local DIR_FONTS="/usr/share/fonts"
    local DIR_DOWNLOADS="/tmp/fonts_tmp"
    mkdir -p "$DIR_DOWNLOADS"
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
    message -success "Nerd Fonts installation complete!"
    sleep 0.5
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
}

function install_display_manager(){
    local display_manager="sddm"
    local old_display_manager=""
    message -title "Setting up the display manager"
    sleep 0.5
    case $display_manager in 
        lightdm)
            message -subtitle "Installing LightDM..."
            sleep 0.5
            sudo DEBIAN_FRONTEND=noninteractive apt install -y lightdm lightdm-gtk-greeter lightdm-gtk-greeter-settings >/dev/null 2>&1
            check_execution $? "Failed to install LightDM on system" "LightDM installed on the system"
        ;;
        gdm3)
            message -subtitle "Installing minimal GDM3..."
            sleep 0.5
            sudo DEBIAN_FRONTEND=noninteractive apt install -y --no-install-recommends gdm3 >/dev/null 2>&1
            check_execution $? "Failed to install GDM3 on system" "GDM3 installed on the system"
        ;;
        sddm)
            message -subtitle "Installing minimal SDDM..."
            sleep 0.5
            sudo DEBIAN_FRONTEND=noninteractive apt install -y --no-install-recommends sddm >/dev/null 2>&1
            check_execution $? "Failed to install SDDM on system" "SDDM installed on the system"
        ;;
        lxdm)
            message -subtitle "Installing LXDM..."
            sleep 0.5
            sudo DEBIAN_FRONTEND=noninteractive apt install -y --no-install-recommends lxdm >/dev/null 2>&1
            check_execution $? "Failed to install LXDM on system" "LXDM installed on the system"
        ;;
        slim)
            message -subtitle "Installing SLiM..."
            sleep 0.5
            sudo DEBIAN_FRONTEND=noninteractive apt install -y slim >/dev/null 2>&1
            check_execution $? "Failed to install SLiM on system" "SLiM installed on the system"
        ;;
        *)
            message -error "Display manager not supported for this distribution: $DISTRO"
            return 1
        ;;
    esac

    if [ -f /etc/X11/default-display-manager ]; then
        message -subtitle "Replace $old_display_manager with $display_manager as default display manager..."
        sleep 0.5
        old_display_manager="$(cat /etc/X11/default-display-manager | awk -F "/" '{print $4}')"
        sudo systemctl stop "$old_display_manager"
        sudo systemctl disable "$old_display_manager"
        sudo dpkg-reconfigure "$display_manager"
    else
        message -subtitle "Enabling the $display_manager service as the default display manager..."
        sleep 0.5
        sudo systemctl enable "$display_manager"
        continue
    fi
}

#  ███████╗███████╗████████╗████████╗██╗███╗   ██╗ ██████╗ ███████╗
#  ██╔════╝██╔════╝╚══██╔══╝╚══██╔══╝██║████╗  ██║██╔════╝ ██╔════╝
#  ███████╗█████╗     ██║      ██║   ██║██╔██╗ ██║██║  ███╗███████╗
#  ╚════██║██╔══╝     ██║      ██║   ██║██║╚██╗██║██║   ██║╚════██║
#  ███████║███████╗   ██║      ██║   ██║██║ ╚████║╚██████╔╝███████║
#  ╚══════╝╚══════╝   ╚═╝      ╚═╝   ╚═╝╚═╝  ╚═══╝ ╚═════╝ ╚══════╝

function setter_configs() {
    message -title "Installing Configuration"
    copy_configs "$DIR/config" "$HOME/.config" "Setting up .config directory..."
    message -title "Installing Local Files"
    copy_configs "$DIR/local" "$HOME/.local" "Setting up personal files in local..."
    message -title "Installing Wallpapers"
    copy_configs "$DIR/wallpapers/$P_RESOLUTION" "$HOME/.local/wallpapers" "Copying wallpapers to $USER's profile..."
    # # ICONS
    # copy_configs "$DIR_RESOURCES/icons" "/usr/share/icons" "Copying icons to the system"
    # # THEMES
    # copy_configs "$DIR_RESOURCES/themes" "/usr/share/themes" "Copying themes into the system"
    # # GRUB
    # copy_configs "$DIR_RESOURCES/grub" "/boot/grub/themes" "Copying grub themes to the system"
}

function setter_homefiles() {
    message -title "Installing Home Files"
    sleep 0.5
    message -subtitle "Copying Home Files..."
    sleep 0.5
    shopt -s dotglob
    for file in .profile .dmrc .xsessionrc; do
        if [[ -f "$DIR/home/$file" ]]; then
            cp -rf --preserve=mode,ownership "$DIR/home/$file" "$HOME/"
            message -success "Copied $file to $HOME."
        else
            message -error "$file does not exist in $DIR/home. Skipping."
        fi
    done
    shopt -u dotglob
    message -success "Home files installation completed."
    sleep 0.5
}

function setter_shell(){
    message -title "Setting default shell"
    sleep 0.5
    case "$P_SHELL" in
        bash)
            message -subtitle "Changing default shell to bash..."
            sudo chsh -s "$(which bash)" "$USER"
            sudo chsh -s "$(which bash)" "root"
            message -success "bash is now the default shell."

            echo -e "shell bash" > ~/.config/kitty/shell.conf

            shopt -s dotglob 
            copy_configs "$DIR/home/bash" "$HOME" "Copying Bash configuration..."
            shopt -u dotglob 
        ;;
        zsh)
            message -subtitle "Changing default shell to zsh..."
            sudo chsh -s "$(which zsh)" "$USER"
            sudo chsh -s "$(which zsh)" "root"
            message -success "Zsh is now the default shell."
            
            install_oh_my_zsh

            echo -e "shell zsh" > ~/.config/kitty/shell.conf

            shopt -s dotglob 
            copy_configs "$DIR/home/zsh" "$HOME" "Copying Zsh configuration..."
            shopt -u dotglob 
        ;;
        *)
            continue
        ;;
    esac
    
}

function setter_permissions() {
    local EXTENSIONS=("*.sh" "*.py")
    local DIRECTORIES=(
        "$HOME/.config/bspwm/scripts"
        "$HOME/.config/polybar/scripts"
        "$HOME/.config/rofi/htb"
        "$HOME/.config/rofi/scripts"
        "$HOME/.local/bin"
        "$HOME/.local/colorscripts"
    )
    message -title "Setting execution permissions to specified file types"
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
        sleep 1
    done
    message -success "Execution permissions have been set for all specified file types in the directories."
    sleep 0.5
}

function setter_services() {
    message -title "Activate services in the system"
    sleep 0.5
    message -subtitle "Service [avahi-daemon]"
    sudo systemctl enable avahi-daemon >/dev/null 2>&1
    check_execution $? "Service Activation Failed" "Service Activated Successfully"
    message -subtitle "Service [acpid]"
    sudo systemctl enable acpid >/dev/null 2>&1
    check_execution $? "Service Activation Failed" "Service Activated Successfully"
    message -subtitle "Service [bluetooth]"
    sudo systemctl enable bluetooth >/dev/null 2>&1
    check_execution $? "Service Activation Failed" "Service Activated Successfully"
    message -subtitle "Service [cups]"
    sudo systemctl enable cups.service >/dev/null 2>&1
    check_execution $? "Service Activation Failed" "Service Activated Successfully"
}

function setter_symbolic_links() {
    local ROOT_HOME="/root"
    local CURRENT_SHELL=$(basename "$SHELL")
    local COMMON_FILES=(".profile")
    message -title "Creating symbolic links in root user directory"
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

while getopts ":s:r:" opt; do
    case ${opt} in
        s) P_SHELL="$OPTARG"
            [[ "$P_SHELL" =~ ^(bash|zsh)$ ]] || usage
        ;;
        r) P_RESOLUTION="$OPTARG"
            [[ "$P_RESOLUTION" =~ ^(1920x1080|1366x768)$ ]] || usage
        ;;
        # t) P_THEME="$OPTARG"
        #     [[ "$P_THEME" =~ ^(a|b|c)$ ]] || usage
        # ;;
        i) P_INSTALLATION="$OPTARG"
            [[ "$P_INSTALLATION" =~ ^(native|virtual)$ ]] || usage
        ;;
        *) usage ;;
    esac
done

if [[ -z "$P_SHELL" || -z "$P_RESOLUTION" ]]; then
    usage
fi
if [ "$UID" -eq 0 ]; then
    message -error "You should not run the script as the root user!"
    exit 1
fi

sudo -v
updating_packages
install_packages
install_fonts
install_pywal
install_display_manager
xdg-user-dirs-update
setter_configs
setter_homefiles
setter_shell
setter_permissions
setter_services
# setter_symbolic_links
reboot_system
