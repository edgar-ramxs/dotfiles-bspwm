#!/usr/bin/env bash

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
        "-title")
            color="\033[0;37m\033[1m"
            signal="[$]"
            shift
            echo -e "\n${color}${signal} $*${RESETC}"
            ;;
        "-subtitle")
            color="\033[0;35m\033[1m"
            signal="[*]"
            shift
            echo -e "\n${color}${signal} $*${RESETC}"
            ;;
        "-approval")
            color="\033[38;5;208m\033[1m"
            signal="[?]"
            shift
            echo -e "\n${color}${signal} $*${RESETC}"
            ;;
        "-success")
            color="\033[0;32m\033[1m"
            signal="[+]"
            shift
            echo -e "\t${color}${signal} $*${RESETC}"
            ;;
        "-warning")
            color="\033[0;33m\033[1m"
            signal="[&]"
            shift
            echo -e "\t${color}${signal} $*${RESETC}"
            ;;
        "-error")
            color="\033[0;31m\033[1m"
            signal="[-]"
            shift
            echo -e "\t${color}${signal} $*${RESETC}"
            ;;
        "-cancel")
            color="\033[0;34m\033[1m"
            signal="[!]"
            shift
            echo -e "\n${color}${signal} $*${RESETC}\n"
            ;;
        *)
            color="$RESETC"
            signal=""
            shift
            echo -e "${color}${signal} $*${RESETC}"
            ;;
    esac
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

function detect_distro() {
    if [ -f /etc/os-release ]; then
        . /etc/os-release
        echo $ID
    else
        echo "unknown"
    fi
}

function reboot_system() {
    message -title "Reboot: It's necessary to restart the system."
    while true; do
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
    local NAME_DISTRO=$(detect_distro)
    message -title "Operating system package updates ($DISTRO)"
    sleep 1

    message -subtitle "Updating packages..."
    case "$NAME_DISTRO" in
        "debian"|"kali"|"ubuntu")
            # Update
            sudo apt update -y >/dev/null 2>&1
            check_execution $? "Failed to update packages" "Update packages"
            sleep 0.5

            # Upgrade
            sudo apt upgrade -y >/dev/null 2>&1
            check_execution $? "Failed to upgrade packages" "Upgrade packages"
            sleep 0.5
            ;;
        *)
            message -error "Package manager not supported for this distribution: $DISTRO"
            sleep 0.5
            ;;
    esac
    sleep 1
}

#  ██╗███╗   ██╗███████╗████████╗ █████╗ ██╗     ██╗     ███████╗██████╗ ███████╗
#  ██║████╗  ██║██╔════╝╚══██╔══╝██╔══██╗██║     ██║     ██╔════╝██╔══██╗██╔════╝
#  ██║██╔██╗ ██║███████╗   ██║   ███████║██║     ██║     █████╗  ██████╔╝███████╗
#  ██║██║╚██╗██║╚════██║   ██║   ██╔══██║██║     ██║     ██╔══╝  ██╔══██╗╚════██║
#  ██║██║ ╚████║███████║   ██║   ██║  ██║███████╗███████╗███████╗██║  ██║███████║
#  ╚═╝╚═╝  ╚═══╝╚══════╝   ╚═╝   ╚═╝  ╚═╝╚══════╝╚══════╝╚══════╝╚═╝  ╚═╝╚══════╝

function install_packages() {
    local NAME_DISTRO=$(detect_distro)
    message -title "Installation of packages for $NAME_DISTRO distribution"
    sleep 0.5

    case "$NAME_DISTRO" in
        "debian"|"kali"|"ubuntu")
            local PACKAGES="$DIR/packages/debian.txt"

            if [[ -f "$PACKAGES" ]]; then
                message -subtitle "File detection completed. Loading packages..."

                while IFS= read -r package || [[ -n "$package" ]]; do
                    if [[ ! -z "$package" && "$package" != \#* ]]; then
                        if apt-cache show "$package" &> /dev/null; then
                            # message -success "(available) $package"
                            sudo apt install -y "$package" >/dev/null 2>&1
                            check_execution $? "(not installed) $package" "(installed) $package"
                        else
                            message -error "(not available) $package"
                        fi
                    fi
                done < "$PACKAGES"

            else
                message -cancel "There is no file related to your distribution."
                sleep 0.5
                exit 1
            fi
            ;;
        *)
            message -cancel "The package manager is not supported for this distribution: $NAME_DISTRO"
            sleep 0.5
            exit 1
            ;;
    esac
}

function install_fonts() {
    DIR_DOWNLOADS="$DIR/fonts"
    DIR_FONTS="/usr/share/fonts"
    FONTS=("FiraCode" "CascadiaCode" "Iosevka" "Hack")

    message -title "Installing and downloading fonts."
    sleep 0.5

    for font_name in "${FONTS[@]}"; do

        curl -L "https://github.com/ryanoasis/nerd-fonts/releases/latest/download/${font_name}.tar.xz" -o "$DIR_DOWNLOADS/${font_name}.tar.xz" >/dev/null 2>&1
        sleep 0.5

        if [ -f "$DIR_DOWNLOADS/${font_name}.tar.xz" ]; then
            if tar -tf "$DIR_DOWNLOADS/${font_name}.tar.xz" &>/dev/null; then
                if [ -d "$DIR_FONTS/${font_name}" ]; then
                    message -subtitle "The ${font_name} font folder already exists. Replacing..."
                    sudo rm -rf "$DIR_FONTS/${font_name}"
                fi

                sudo mkdir -p "$DIR_FONTS/${font_name}"
                sudo tar -xf "$DIR_DOWNLOADS/${font_name}.tar.xz" -C "$DIR_FONTS/${font_name}" --wildcards "*.ttf" >/dev/null 2>&1
                
                message -success "${font_name} downloaded and installed."
                sleep 0.5
                
                rm "$DIR_DOWNLOADS/${font_name}.tar.xz"
                sleep 0.5
            else
                message -cancel "Error: ${font_name} is not a valid tar archive."
                rm "$DIR_DOWNLOADS/${font_name}.tar.xz"
                continue
            fi
        else
            message -error "Error: ${font_name} could not be downloaded."
            continue
        fi
    done

    message -warning "Nerd Fonts installation complete! Reloading fonts..."
    sudo fc-cache -fv >/dev/null 2>&1
    sleep 1
}

function install_zsh() {
    message -title "ZSH Installation"
    sleep 0.5

    message -subtitle "Setting ZSH as default..."
    sudo chsh -s $(which zsh) $USER
    sudo chsh -s $(which zsh) root
    sleep 0.5

    if [ ! -d /usr/share/zsh-sudo ]; then
        message -error "El directorio '/usr/share/zsh-sudo' no existe."
        sleep 0.5
        
        message -subtitle "Installing ZSH plugins..."
        sudo mkdir -p /usr/share/zsh-sudo
        sudo chown $USER:$USER /usr/share/zsh-sudo/
        sudo wget -q -O /usr/share/zsh-sudo/zsh-sudo.zsh https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/plugins/sudo/sudo.plugin.zsh
        check_execution $? "Failed plugin download" "Plugin download successful"
        sleep 0.5
    fi

    message -subtitle "Installing Powerlevel10k for user $USER..."
    git clone --depth=1 https://github.com/romkatv/powerlevel10k.git ~/.powerlevel10k >/dev/null 2>&1
    check_execution $? "Failed powerlevel10k download for $USER" "Completed download of powerlevel10k for the $USER"
    sleep 0.5

    message -subtitle "Installing Powerlevel10k for root..."
    sudo git clone --depth=1 https://github.com/romkatv/powerlevel10k.git /root/.powerlevel10k >/dev/null 2>&1
    check_execution $? "Failed powerlevel10k download for root" "Completed download of powerlevel10k for the root"
    sleep 0.5
}

function install_pywal() {
    message -title "Pywal Installation"
    sleep 0.5

    sudo pip3 install setuptools --break-system-packages >/dev/null 2>&1
    check_execution $? "Failed Setuptools Installation." "Complete Setuptools installation."
    sleep 0.5

    sudo pip3 install pywal --break-system-packages >/dev/null 2>&1
    check_execution $? "Failed Pywal Installation." "Complete Pywal installation."
    sleep 0.5
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
    sleep 0.5

    if [ ! -d "$DIR_DEST" ]; then
        mkdir -p "$DIR_DEST"
        message -warning "Target directory $DIR_DEST was created."
    fi

    cp -rf "$DIR_SOURCE"/* "$DIR_DEST"
    message -success "Configurations successfully copied to $DIR_DEST"
}

function setter_binaries() {
    message -title "Installing Binaries"
    copy_configs "$DIR/bin" "$HOME/.local/bin" "Settings of the personal bin directory"
}

function setter_configs() {
    message -title "Installing Configs"
    copy_configs "$DIR/config" "$HOME/.config" "Settings of the .config directory"
}

function setter_homefiles() {
    local current_shell=$(basename "$SHELL")

    message -title "Installing Home files"
    sleep 0.5
    
    shopt -s dotglob

    cp -rf "$DIR/home/.profile" "$HOME"
    cp -rf "$DIR/home/.aliases" "$HOME"
    cp -rf "$DIR/home/.functions" "$HOME"
    
    case "$current_shell" in
        bash)
            copy_configs "$DIR/home/bash" "$HOME" "Copying Bash configuration"
            ;;
        zsh)
            copy_configs "$DIR/home/zsh" "$HOME" "Copying Zsh configuration"
            ;;
        *)
            message -subtitle "Unknown shell: $current_shell. Skipping shell-specific files."
            ;;
    esac
    
    shopt -u dotglob

    message -success "Installed Home files"
    sleep 1
}

function setter_visual_resources() {
    local DIR_RESOURCES="$DIR/resources"
    local RESOLUTION=$(xrandr | grep '*' | awk '{print $1}')

    message -title "Installing Resources"

    if [ -d "$DIR_RESOURCES" ]; then
        rm -rf "$DIR_RESOURCES"
    fi
    
    git clone https://github.com/edgar-ramxs/dotfiles-resources.git $DIR/resources >/dev/null 2>&1
    check_execution $? "Failed Resources download for $USER" "Complete download of $USER resources"
    sleep 0.5

    # ICONS
    copy_configs "$DIR_RESOURCES/icons" "/usr/share/icons" "Copying icons to the system"

    # THEMES
    copy_configs "$DIR_RESOURCES/themes" "/usr/share/themes" "Copying themes into the system"

    # GRUB
    copy_configs "$DIR_RESOURCES/grub" "/boot/grub/themes" "Copying grub themes to the system"
    
    # WALLPAPERS
    copy_configs "$DIR_RESOURCES/wallpapers/$RESOLUTION" "$HOME/.wallpapers" "Copying wallpapers to $USER's profile"

    sleep 1
    rm -rf "$DIR_RESOURCES"
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


