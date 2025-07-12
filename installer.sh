#!/usr/bin/env bash

#  ██╗   ██╗ █████╗ ██████╗ ██╗ █████╗ ██████╗ ██╗     ███████╗███████╗
#  ██║   ██║██╔══██╗██╔══██╗██║██╔══██╗██╔══██╗██║     ██╔════╝██╔════╝
#  ██║   ██║███████║██████╔╝██║███████║██████╔╝██║     █████╗  ███████╗
#  ╚██╗ ██╔╝██╔══██║██╔══██╗██║██╔══██║██╔══██╗██║     ██╔══╝  ╚════██║
#   ╚████╔╝ ██║  ██║██║  ██║██║██║  ██║██████╔╝███████╗███████╗███████║
#    ╚═══╝  ╚═╝  ╚═╝╚═╝  ╚═╝╚═╝╚═╝  ╚═╝╚═════╝ ╚══════╝╚══════╝╚══════╝

DOT_DIR=$(pwd)
DOT_USER=$(whoami)
DOT_SHELL=""
DOT_DISTRO=$(grep -i '^ID=' /etc/os-release | cut -d= -f2 | tr -d '"' | tr '[:upper:]' '[:lower:]')
DOT_RESOLUTION=""
DOT_INSTALLATION=""

#  ███████╗██╗   ██╗███╗   ██╗ ██████╗████████╗██╗ ██████╗ ███╗   ██╗███████╗
#  ██╔════╝██║   ██║████╗  ██║██╔════╝╚══██╔══╝██║██╔═══██╗████╗  ██║██╔════╝
#  █████╗  ██║   ██║██╔██╗ ██║██║        ██║   ██║██║   ██║██╔██╗ ██║███████╗
#  ██╔══╝  ██║   ██║██║╚██╗██║██║        ██║   ██║██║   ██║██║╚██╗██║╚════██║
#  ██║     ╚██████╔╝██║ ╚████║╚██████╗   ██║   ██║╚██████╔╝██║ ╚████║███████║
#  ╚═╝      ╚═════╝ ╚═╝  ╚═══╝ ╚═════╝   ╚═╝   ╚═╝ ╚═════╝ ╚═╝  ╚═══╝╚══════╝

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

    if [[ -n "$color_msg" ]]; then
        local prefix="\n"
        [[ "$key" == "-success" || "$key" == "-warning" || "$key" == "-error" ]] && prefix="\t"
        echo -e "${prefix}${color_msg} $*${RESETC}"
        case "$key" in
            -title) sleep 0.5 ;;
            -subtitle) sleep 0.3 ;;
            -cancel) sleep 0.5 ;;
        esac
    else
        echo -e "${RESETC}$key $*${RESETC}"
    fi
}

function usage() {
    message -title "Usage: $0 -s [option] -r [option] -i [option]"
    message -warning "Parameter         Target      Options                 Description"
    message -success "Shell             -s          [bash|zsh]              Set default shell"
    message -success "Resolution        -r          [1920x1080|1366x768]    Set default screen resolution for wallpapers"
    message -success "Installation      -i          [virtual|native]        Set the default installation level"
    echo ""
    exit 0
}

trap exiting_script INT
function exiting_script() {
    message -cancel "Exiting...\n"
    exit 1
}

function check_execution() {
    [[ $1 -ne 0 && $1 -ne 130 ]] && message -error "Error: $2" || message -success "Successful: $3"
    sleep 0.5
}

function reboot_system() {
    local attempts=0 max_attempts=3 reboot_cmd
    case "$DOT_DISTRO" in
        debian|ubuntu|kali|linuxmint|parrot) reboot_cmd="sudo reboot";;
        arch|manjaro|fedora) reboot_cmd="systemctl reboot";;
        *) reboot_cmd="sudo reboot";;
    esac

    message -title "Reboot: It's necessary to restart the system."
    while (( attempts < max_attempts )); do
        message -approval "Do you want to restart the system now? [yes|y] or [no|n]"
        read -r REPLY
        REPLY=${REPLY,,}
        case "$REPLY" in
            yes|y)
                message -cancel "Restarting the system..."
                sleep 1
                eval "$reboot_cmd"
                break
                ;;
            no|n)
                message -warning "Remember to restart the system as the environment will fail to reload all configurations."
                message -cancel "Finished!\n"
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
    message -title "Operating System Package Updates ($DOT_DISTRO)"
    case "$DOT_DISTRO" in
        debian|ubuntu|kali|linuxmint|parrot)
            for step in "apt update -y" "apt upgrade -y"; do
                local msg="Updating package list..."
                [[ "$step" == *upgrade* ]] && msg="Upgrading installed packages..."
                message -subtitle "$msg"
                sudo $step >/dev/null 2>&1
                check_execution $? "Failed to run '$step'." "'$step' completed successfully."
            done
            ;;
        arch|manjaro)
            for step in "pacman -Sy --noconfirm" "pacman -Syu --noconfirm"; do
                local msg="Updating package list..."
                [[ "$step" == *Syu* ]] && msg="Upgrading installed packages..."
                message -subtitle "$msg"
                sudo $step >/dev/null 2>&1
                check_execution $? "Failed to run '$step'." "'$step' completed successfully."
            done
            ;;
        fedora)
            message -subtitle "Updating and upgrading packages..."
            sudo dnf upgrade --refresh -y >/dev/null 2>&1
            check_execution $? "Failed to update packages." "Packages upgraded successfully."
            ;;
        *)
            message -cancel "Package manager not supported for this distribution: $DOT_DISTRO"
            exiting_script
            ;;
    esac
    message -success "All packages are up to date."
}

function copy_configs() {
    local DIR_SOURCE="$1"
    local DIR_DEST="$2"
    local SUBTITLE="$3"

    message -subtitle "$SUBTITLE"
    if [[ ! -d "$DIR_SOURCE" ]]; then
        message -error "Source directory $DIR_SOURCE does not exist."
        exiting_script
    fi

    if [[ ! -d "$DIR_DEST" ]]; then
        mkdir -p "$DIR_DEST"
        message -warning "Target directory $DIR_DEST was created."
    fi

    if command -v rsync &>/dev/null; then
        rsync -a --delete "$DIR_SOURCE"/ "$DIR_DEST"/
        check_execution $? "Failed to sync configs to $DIR_DEST" "Configurations synced to $DIR_DEST"
    else
        cp -arf "$DIR_SOURCE"/* "$DIR_DEST"/
        check_execution $? "Failed to copy configs to $DIR_DEST" "Configurations copied to $DIR_DEST"
    fi
}

#  ██╗███╗   ██╗███████╗████████╗ █████╗ ██╗     ██╗     ███████╗██████╗ ███████╗
#  ██║████╗  ██║██╔════╝╚══██╔══╝██╔══██╗██║     ██║     ██╔════╝██╔══██╗██╔════╝
#  ██║██╔██╗ ██║███████╗   ██║   ███████║██║     ██║     █████╗  ██████╔╝███████╗
#  ██║██║╚██╗██║╚════██║   ██║   ██╔══██║██║     ██║     ██╔══╝  ██╔══██╗╚════██║
#  ██║██║ ╚████║███████║   ██║   ██║  ██║███████╗███████╗███████╗██║  ██║███████║
#  ╚═╝╚═╝  ╚═══╝╚══════╝   ╚═╝   ╚═╝  ╚═╝╚══════╝╚══════╝╚══════╝╚═╝  ╚═╝╚══════╝

function install_packages() {
    message -title "Installation of packages for $DOT_DISTRO distribution"
    case "$DOT_DISTRO" in
        debian|ubuntu|kali|linuxmint|parrot)
            local PACKAGES_FILE="$DIR/packages/debian.txt"
            message -subtitle "Checking and installing packages for APT-based systems..."
            if [[ ! -f "$PACKAGES_FILE" ]]; then
                message -cancel "There is no file related to your distribution."
                exiting_script
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
            local PACKAGES_FILE="$DIR/packages/arch.txt"
            message -subtitle "Checking and installing packages for Pacman-based systems..."
            if [[ ! -f "$PACKAGES_FILE" ]]; then
                message -cancel "There is no file related to your distribution."
                exiting_script
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
            local PACKAGES_FILE="$DIR/packages/fedora.txt"
            message -subtitle "Checking and installing packages for DNF-based systems..."
            if [[ ! -f "$PACKAGES_FILE" ]]; then
                message -cancel "There is no file related to your distribution."
                exiting_script
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
            message -cancel "Package manager not supported for this distribution: $DOT_DISTRO"
            exiting_script
        ;;
    esac
    message -warning "Package installation completed for $DOT_DISTRO."
}

function install_fonts(){
    local FONTS=("FiraCode" "CascadiaCode" "Iosevka" "Hack" "JetBrainsMono" "Meslo" "Mononoki" "RobotoMono" "0xProto") 
    local DIR_FONTS="/usr/share/fonts"
    local DIR_DOWNLOADS="/tmp/fonts_tmp"
    
    mkdir -p "$DIR_DOWNLOADS"
    if ! command -v curl &>/dev/null || ! command -v tar &>/dev/null; then
        message -cancel "Dependencies missing: curl and tar are required. Please install them first."
        exiting_script
    fi
    
    message -title "Installing and downloading Nerd Fonts."
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
}

function install_pywal() {
    message -title "Pywal Installation"
    
    local PIP_CMD=""
    if command -v pip &>/dev/null; then
        PIP_CMD="pip"
    elif command -v pip3 &>/dev/null; then
        PIP_CMD="pip3"
    else
        message -cancel "Neither pip3 nor pip is installed. Please install pip3 or pip before proceeding."
        exiting_script
    fi

    message -subtitle "Using $PIP_CMD for installation."
    sudo $PIP_CMD install setuptools --break-system-packages >/dev/null 2>&1
    check_execution $? "Failed to install setuptools. Please check your Python environment." "Setuptools installed successfully."
    
    sudo $PIP_CMD install pywal --break-system-packages >/dev/null 2>&1
    check_execution $? "Failed to install pywal. Please check your Python environment." "Pywal installed successfully."

    if command -v wal &>/dev/null; then
        message -warning "Pywal is installed and ready to use."
    else
        message -cancel "Pywal installation completed, but the 'wal' command is not found. Check your PATH."
        exiting_script
    fi
}

function install_oh_my_zsh() {
    message -title "Installing Oh My Zsh"
    local plugins=(
        "https://github.com/zsh-users/zsh-syntax-highlighting.git"
        "https://github.com/zsh-users/zsh-autosuggestions.git"
    )

    message -subtitle "Checking that there is no .oh-my-zsh directory..."
    if [ -d "$HOME/.oh-my-zsh" ]; then
        message -warning "A previous installation of Oh My Zsh was found. Removing it..."
        rm -rf "$HOME/.oh-my-zsh"
        message -success "Previous installation removed."
    fi

    message -subtitle "Downloading and installing Oh My Zsh..."
    yes | sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" >/dev/null 2>&1
    check_execution $? "Error installing Oh My Zsh" "Oh My Zsh installed successfully."
    
    message -subtitle "Installing Zsh plugins..."
    for plugin in "${plugins[@]}"; do
        local plugin_name=$(basename "$plugin" .git)
        local plugin_path="${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/plugins/$plugin_name"
        message -warning "Installing: $plugin_name"
        git clone "$plugin" "$plugin_path" >/dev/null 2>&1
        check_execution $? "Error installing $plugin_name" "$plugin_name installed correctly."
    done

    message -subtitle "Downloading zsh theme..."
    git clone --depth=1 https://github.com/romkatv/powerlevel10k.git "${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/themes/powerlevel10k" >/dev/null 2>&1
    check_execution $? "Error installing" "installed correctly."
}

function install_display_manager() {
    local DM="lightdm" # lightdm | gdm3 | sddm | lxdm | slim
    message -subtitle "Preparing to set display manager: $DM"
    case "$DOT_DISTRO" in
        debian|ubuntu|kali|linuxmint|parrot)
            if ! dpkg -s "$DM" &>/dev/null; then
                sudo DEBIAN_FRONTEND=noninteractive apt install -y "$DM"
            fi
        ;;
        arch|manjaro|endeavouros)
            if ! pacman -Q "$DM" &>/dev/null; then
                sudo pacman -S --noconfirm "$DM"
            fi
        ;;
        fedora)
            if ! rpm -q "$DM" &>/dev/null; then
                sudo dnf install -y "$DM"
            fi
        ;;
        *)
            message -cancel "Unsupported distribution: $DOT_DISTRO"
            exiting_script
        ;;
    esac

    local CURRENT_DM=$(systemctl get-default | grep graphical.target &>/dev/null && systemctl status display-manager.service 2>/dev/null | grep Loaded | grep -oP '(?<=/)[^/]+(?=\.\w+$)')
    if [[ -n "$CURRENT_DM" && "$CURRENT_DM" != "$DM" ]]; then
        message -subtitle "Disabling current display manager: $CURRENT_DM"
        sudo systemctl disable "$CURRENT_DM" &>/dev/null || true
        sleep 0.5
    fi
    sudo systemctl enable "$DM" &>/dev/null
    sudo systemctl set-default graphical.target
    sudo systemctl restart "$DM" || sudo systemctl start "$DM"
    sleep 0.5
    message -success "$DM has been set as the default display manager."
}

#  ███████╗███████╗████████╗████████╗██╗███╗   ██╗ ██████╗ ███████╗
#  ██╔════╝██╔════╝╚══██╔══╝╚══██╔══╝██║████╗  ██║██╔════╝ ██╔════╝
#  ███████╗█████╗     ██║      ██║   ██║██╔██╗ ██║██║  ███╗███████╗
#  ╚════██║██╔══╝     ██║      ██║   ██║██║╚██╗██║██║   ██║╚════██║
#  ███████║███████╗   ██║      ██║   ██║██║ ╚████║╚██████╔╝███████║
#  ╚══════╝╚══════╝   ╚═╝      ╚═╝   ╚═╝╚═╝  ╚═══╝ ╚═════╝ ╚══════╝

function setter_configs() {
    message -title "Installing Configuration"
    copy_configs "$DOT_DIR/config" "$HOME/.config" "Setting up .config directory..."
    
    message -title "Installing Local Files"
    copy_configs "$DOT_DIR/local" "$HOME/.local" "Setting up personal files in local..."
    
    # # ICONS
    # copy_configs "$DIR_RESOURCES/icons" "/usr/share/icons" "Copying icons to the system"
    
    # # THEMES
    # copy_configs "$DIR_RESOURCES/themes" "/usr/share/themes" "Copying themes into the system"
    
    # # GRUB
    # copy_configs "$DIR_RESOURCES/grub" "/boot/grub/themes" "Copying grub themes to the system"
}

function setter_wallpapers() {
    local base_dir="$HOME/.local/wallpapers"
    local res_dir="${base_dir}/${DOT_RESOLUTION}"

    if [[ ! -d "$res_dir" ]]; then
        message -error "Directory $res_dir does not exist."
        exiting_script
    fi

    mv "${res_dir}/"* "${base_dir}/"
    rmdir "$res_dir"
    message -success "Moved wallpapers from $res_dir to $base_dir and removed $res_dir."
}

function setter_homefiles() {
    message -title "Installing Home Files"

    message -subtitle "Copying Home Files..."
    shopt -s dotglob nullglob
    for file in "$DOT_DIR/home/"*; do
        if [[ -e "$file" ]]; then
            cp -rf --preserve=mode,ownership "$file" "$HOME/"
            check_execution $? "Failed to copy $(basename "$file")" "Copied $(basename "$file") to $HOME"
        else
            message -warning "No files to copy from $DOT_DIR/home."
        fi
    done
    shopt -u dotglob nullglob

    message -success "Home files installation completed."
}

function setter_shell(){
    message -title "Setting default shell"
    case "$DOT_SHELL" in
        bash)
            message -subtitle "Changing default shell to bash..."
            sudo chsh -s "$(which bash)" "$DOT_USER"
            sudo chsh -s "$(which bash)" "root"
            message -success "bash is now the default shell."
            echo -e "shell bash" > ~/.config/kitty/shell.conf
            shopt -s dotglob 
            copy_configs "$DIR/home/bash" "$HOME" "Copying Bash configuration..."
            shopt -u dotglob 
        ;;
        zsh)
            message -subtitle "Changing default shell to zsh..."
            sudo chsh -s "$(which zsh)" "$DOT_USER"
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
        "$HOME/.local/ascii/animations"
        "$HOME/.local/ascii/asciiarts"
        "$HOME/.local/ascii/colorsscripts"
        "$HOME/.local/ascii/fetchinfo"
    )
    message -title "Setting execution permissions to specified file types"
    for dir in "${DIRECTORIES[@]}"; do
        if [[ -d "$dir" ]]; then
            message -subtitle "Processing directory: $dir"
            if [[ "$dir" == "$HOME/.local/bin" ]]; then
                while IFS= read -r file; do
                    chmod +x "$file"
                    message -success "Execution permission set (bin): $file"
                done < <(find "$dir" -type f)
            else
                for ext in "${EXTENSIONS[@]}"; do
                    while IFS= read -r file; do
                        chmod +x "$file"
                        message -success "Execution permission set: $file"
                    done < <(find "$dir" -type f -name "$ext")
                done
            fi
        else
            message -warning "Directory not found: $dir"
        fi
        sleep 0.5
    done
    message -success "Execution permissions have been set for all specified files."
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
    local CONFIG_SHELL_DIR="$HOME/.config/shell"

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
            message -subtitle "Linking [$CURRENT_SHELL] configuration files..."
            sleep 0.5
            for file in ${SHELL_FILES[$CURRENT_SHELL]}; do
                if [[ -f "$HOME/$file" ]]; then
                    sudo ln -sfv "$HOME/$file" "$ROOT_HOME/$file" >/dev/null 2>&1
                    message -success "Linked $HOME/$file to $ROOT_HOME/$file"
                else
                    message -warning "$file not found in $HOME. Skipping."
                fi
            done

            if [[ -d "$CONFIG_SHELL_DIR" ]]; then
                sudo mkdir -p "$ROOT_HOME/.config"
                sudo ln -sfv "$CONFIG_SHELL_DIR" "$ROOT_HOME/.config/shell" >/dev/null 2>&1
                message -success "Linked $CONFIG_SHELL_DIR to $ROOT_HOME/.config/shell"
            else
                message -warning "$CONFIG_SHELL_DIR not found. Skipping config shell directory."
            fi
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

if [ "$UID" -eq 0 ]; then
    message -error "You should not run the script as the root user!"
    exit 1
fi

while getopts ":s:r:i:" opt; do
    case ${opt} in
        s) DOT_SHELL="$OPTARG"
            [[ "$DOT_SHELL" =~ ^(bash|zsh)$ ]] || usage
        ;;
        r) DOT_RESOLUTION="$OPTARG"
            [[ "$DOT_RESOLUTION" =~ ^(1920x1080|1366x768)$ ]] || usage
        ;;
        i) DOT_INSTALLATION="$OPTARG"
            [[ "$DOT_INSTALLATION" =~ ^(native|virtual)$ ]] || usage
        ;;
        *) usage ;;
    esac
done

if [[ -z "$DOT_SHELL" || -z "$DOT_RESOLUTION" || -z "$DOT_INSTALLATION" ]]; then
    usage
fi

sudo -v
updating_packages

install_packages
install_fonts
install_pywal
# install_display_manager

setter_configs
setter_wallpapers
setter_homefiles
setter_shell
setter_permissions
# setter_services
# setter_symbolic_links

reboot_system
