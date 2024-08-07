#!/usr/bin/env bash


#  ██╗   ██╗ █████╗ ██████╗ ██╗ █████╗ ██████╗ ██╗     ███████╗███████╗
#  ██║   ██║██╔══██╗██╔══██╗██║██╔══██╗██╔══██╗██║     ██╔════╝██╔════╝
#  ██║   ██║███████║██████╔╝██║███████║██████╔╝██║     █████╗  ███████╗
#  ╚██╗ ██╔╝██╔══██║██╔══██╗██║██╔══██║██╔══██╗██║     ██╔══╝  ╚════██║
#   ╚████╔╝ ██║  ██║██║  ██║██║██║  ██║██████╔╝███████╗███████╗███████║
#    ╚═══╝  ╚═╝  ╚═╝╚═╝  ╚═╝╚═╝╚═╝  ╚═╝╚═════╝ ╚══════╝╚══════╝╚══════╝
#                                                                      

DIR=$(pwd)
USER=$(whoami)
DISTRO=$(lsb_release -is)

#   ██████╗ ██████╗ ██╗      ██████╗ ██████╗ ███████╗
#  ██╔════╝██╔═══██╗██║     ██╔═══██╗██╔══██╗██╔════╝
#  ██║     ██║   ██║██║     ██║   ██║██████╔╝███████╗
#  ██║     ██║   ██║██║     ██║   ██║██╔══██╗╚════██║
#  ╚██████╗╚██████╔╝███████╗╚██████╔╝██║  ██║███████║
#   ╚═════╝ ╚═════╝ ╚══════╝ ╚═════╝ ╚═╝  ╚═╝╚══════╝
#                                                    

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
#                                                                            

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
        exit 1
    else
        message -success "Done."
        sleep 1.5
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
    sudo apt update -y >/dev/null 2>&1
    check_execution $? "Failed to updating packages."
    sleep 1
    message -subtitle "Upgrading packages..."
    sudo apt upgrade -y >/dev/null 2>&1
    check_execution $? "Failed to Upgrading packages."
    sleep 1
}

#  ██╗███╗   ██╗███████╗████████╗ █████╗ ██╗     ██╗     ███████╗██████╗ ███████╗
#  ██║████╗  ██║██╔════╝╚══██╔══╝██╔══██╗██║     ██║     ██╔════╝██╔══██╗██╔════╝
#  ██║██╔██╗ ██║███████╗   ██║   ███████║██║     ██║     █████╗  ██████╔╝███████╗
#  ██║██║╚██╗██║╚════██║   ██║   ██╔══██║██║     ██║     ██╔══╝  ██╔══██╗╚════██║
#  ██║██║ ╚████║███████║   ██║   ██║  ██║███████╗███████╗███████╗██║  ██║███████║
#  ╚═╝╚═╝  ╚═══╝╚══════╝   ╚═╝   ╚═╝  ╚═╝╚══════╝╚══════╝╚══════╝╚═╝  ╚═╝╚══════╝
#                                                                                

function install_packages() {
    message -title "Installing necessary packages for the environment."
    sleep 0.5
    sudo apt install -y "$@" >/dev/null 2>&1
    check_execution $? "Failed to install some packages."
    sleep 1
}

function install_dependencies() {
    message -title "Installing necessary dependencies for $1."
    sleep 0.5
    sudo apt install -y "${@:2}" >/dev/null 2>&1
    check_execution $? "Failed to install some dependencies for $1!"
    sleep 1
}

function install_fonts() {
    local DIR_DOWNLOADS="$DIR/fonts"
    local DIR_FONTS="/usr/share/fonts"
    message -title "Installing and downloading fonts."
    font_names=("FiraCode" "CascadiaCode" "Iosevka" "Hack")
    for font_name in "${font_names[@]}"; do
        curl -L "https://github.com/ryanoasis/nerd-fonts/releases/latest/download/${font_name}.tar.xz" -o "$DIR_DOWNLOADS/${font_name}.tar.xz" >/dev/null 2>&1
        sleep 1.5
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
    message -warning "Nerd Fonts installation complete!. Reloading fonts..."
    fc-cache -fv >/dev/null 2>&1
    sleep 1
}

function install_zsh() {
    message -title "ZSH Installation"
    sleep 0.5
    message -subtitle "Installation of libraries and plugins..."
    sudo apt install -y zsh zsh-syntax-highlighting zsh-autosuggestions >/dev/null 2>&1
    sleep 1
    message -subtitle "Setting ZSH as default..."
    sudo chsh -s $(which zsh) $USER
    sudo chsh -s $(which zsh) root
    sleep 1
    if [ ! -d /usr/share/zsh-sudo ]; then
        message -error "El directorio '/usr/share/zsh-sudo' no existe."
        message -subtitle "Installing ZSH plugins..."
        sudo mkdir -p /usr/share/zsh-sudo
        sudo chown $USER:$USER /usr/share/zsh-sudo/
        sudo wget -q -O /usr/share/zsh-sudo/zsh-sudo.zsh https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/plugins/sudo/sudo.plugin.zsh
        check_execution $? "Failed plugin download."
    fi
    message -subtitle "Installing Powerlevel10k for user $USER..."
    git clone --depth=1 https://github.com/romkatv/powerlevel10k.git ~/.powerlevel10k >/dev/null 2>&1
    check_execution $? "Failed powerlevel10k download for user."
    sleep 1
    message -subtitle "Installing Powerlevel10k for root..."
    sudo git clone --depth=1 https://github.com/romkatv/powerlevel10k.git /root/.powerlevel10k >/dev/null 2>&1
    check_execution $? "Failed powerlevel10k download for root."
    sleep 1
}

function install_pywal() {
    message -title "Pywal Installation"
    sleep 0.5
    sudo pip3 install pywal --break-system-packages >/dev/null 2>&1
    check_execution $? "Failed Pywal Installation"
    sleep 1
}

function install_brave() {
    sudo curl -fsSLo /usr/share/keyrings/brave-browser-archive-keyring.gpg https://brave-browser-apt-release.s3.brave.com/brave-browser-archive-keyring.gpg
    echo "deb [signed-by=/usr/share/keyrings/brave-browser-archive-keyring.gpg] https://brave-browser-apt-release.s3.brave.com/ stable main" | sudo tee /etc/apt/sources.list.d/brave-browser-release.list
    sudo apt update
    sudo apt install brave-browser  
}

function install_flatpak() {
    # Instalar Flatpak
    sudo apt update
    sudo apt install -y flatpak
    sudo flatpak remote-add --if-not-exists flathub https://dl.flathub.org/repo/flathub.flatpakrepo

}


#  ███████╗███████╗████████╗████████╗██╗███╗   ██╗ ██████╗ ███████╗
#  ██╔════╝██╔════╝╚══██╔══╝╚══██╔══╝██║████╗  ██║██╔════╝ ██╔════╝
#  ███████╗█████╗     ██║      ██║   ██║██╔██╗ ██║██║  ███╗███████╗
#  ╚════██║██╔══╝     ██║      ██║   ██║██║╚██╗██║██║   ██║╚════██║
#  ███████║███████╗   ██║      ██║   ██║██║ ╚████║╚██████╔╝███████║
#  ╚══════╝╚══════╝   ╚═╝      ╚═╝   ╚═╝╚═╝  ╚═══╝ ╚═════╝ ╚══════╝
#                                                                  

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
    check_execution $? "Failed Resources download for user."
    sleep 1.0

    if [ ! -d "$DIR_WALLS_DES" ]; then
        mkdir -p "$DIR_WALLS_DES"
        message -subtitle "Target directory $DIR_WALLS_DES was created."
    fi
    sleep 0.5
    if [ ! -d "$DIR_ICONS_DES" ]; then
        mkdir -p "$DIR_ICONS_DES"
        message -subtitle "Target directory $DIR_ICONS_DES was created."
    fi
    sleep 0.5

    message -subtitle "Copying resources.."
    cp -rf "$DIR_WALLS_SOU"/* "$DIR_WALLS_DES"
    message -success "Resources successfully copied to $DIR_WALLS_DES"
    sleep 1.0
    cp -rf "$DIR_ICONS_SOU"/* "$DIR_ICONS_DES"
    message -success "Resources successfully copied to $DIR_ICONS_DES"
    sleep 1.0
}

function setter_symbolic_links() {
    message -title "Symbolic link of root..."
    sleep 0.5
    sudo ln -sfv /home/$USER/.zshrc /root/.zshrc
    sudo ln -sfv /home/$USER/.profile /root/.profile
    sudo ln -sfv /home/$USER/.p10k.zsh /root/.p10k.zsh
    sleep 1
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

#  ███╗   ███╗ █████╗ ██╗███╗   ██╗
#  ████╗ ████║██╔══██╗██║████╗  ██║
#  ██╔████╔██║███████║██║██╔██╗ ██║
#  ██║╚██╔╝██║██╔══██║██║██║╚██╗██║
#  ██║ ╚═╝ ██║██║  ██║██║██║ ╚████║
#  ╚═╝     ╚═╝╚═╝  ╚═╝╚═╝╚═╝  ╚═══╝
#                                  

function main() {
    # Verificación del usuario root
    if [ "$UID" -eq 0 ]; then
        message -error "You should not run the script as the root user!"
        exit 1
    else
        # Actualizacion de paquetes y repositorios del sistema
        updating_packages

        # Entorno
        install_dependencies "ENTORNO" xorg xserver-xorg xutils xinit xinput \
        bspwm sxhkd picom polybar rofi pulseaudio pavucontrol firefox-esr kitty \
        nitrogen papirus-icon-theme policykit-1-gnome flameshot ranger thunar \
        lxappearance x11-xserver-utils

        # HERRAMIENTAS
        install_dependencies "HERRAMIENTAS" wget curl zip unzip tar rar unrar \
        p7zip-full jq bat locate xclip lsd cmake make gcc build-essential \
        python3 python3-pip xdg-user-dirs imagemagick btop cava tree neofetch \
        fastfetch net-tools

        # PROGRAMAS
        install_dependencies "PROGRAMAS" synaptic font-manager network-manager \
        xfce4-power-manager brightnessctl bluetooth lightdm lightdm-gtk-greeter \
        lightdm-gtk-greeter-settings

        # Creacion de directorios
        xdg-user-dirs-update
    
        # Instalacion de fuentes de Nerd Fonts
        install_fonts

        # Instalacion de ZSH (con plugins)
        install_zsh

        # Instalacion de Pywal
        install_pywal
        
        # Configuraciones
        setter_binaries
        setter_configs
        setter_homefiles
        setter_resources
        setter_permissions
        setter_symbolic_links
        
        sleep 1
    fi

    reboot_system
    exit 0
}

#  ███████╗██╗  ██╗███████╗ ██████╗██╗   ██╗████████╗██╗ ██████╗ ███╗   ██╗
#  ██╔════╝╚██╗██╔╝██╔════╝██╔════╝██║   ██║╚══██╔══╝██║██╔═══██╗████╗  ██║
#  █████╗   ╚███╔╝ █████╗  ██║     ██║   ██║   ██║   ██║██║   ██║██╔██╗ ██║
#  ██╔══╝   ██╔██╗ ██╔══╝  ██║     ██║   ██║   ██║   ██║██║   ██║██║╚██╗██║
#  ███████╗██╔╝ ██╗███████╗╚██████╗╚██████╔╝   ██║   ██║╚██████╔╝██║ ╚████║
#  ╚══════╝╚═╝  ╚═╝╚══════╝ ╚═════╝ ╚═════╝    ╚═╝   ╚═╝ ╚═════╝ ╚═╝  ╚═══╝
#                                                                          

main $@
