#!/usr/bin/env bash

#  ██████╗ ███████╗██████╗ ██╗ █████╗ ███╗   ██╗    ██╗   ██╗██████╗  ██████╗ ██████╗  █████╗ ██████╗ ███████╗
#  ██╔══██╗██╔════╝██╔══██╗██║██╔══██╗████╗  ██║    ██║   ██║██╔══██╗██╔════╝ ██╔══██╗██╔══██╗██╔══██╗██╔════╝
#  ██║  ██║█████╗  ██████╔╝██║███████║██╔██╗ ██║    ██║   ██║██████╔╝██║  ███╗██████╔╝███████║██║  ██║█████╗  
#  ██║  ██║██╔══╝  ██╔══██╗██║██╔══██║██║╚██╗██║    ██║   ██║██╔═══╝ ██║   ██║██╔══██╗██╔══██║██║  ██║██╔══╝  
#  ██████╔╝███████╗██████╔╝██║██║  ██║██║ ╚████║    ╚██████╔╝██║     ╚██████╔╝██║  ██║██║  ██║██████╔╝███████╗
#  ╚═════╝ ╚══════╝╚═════╝ ╚═╝╚═╝  ╚═╝╚═╝  ╚═══╝     ╚═════╝ ╚═╝      ╚═════╝ ╚═╝  ╚═╝╚═╝  ╚═╝╚═════╝ ╚══════╝

set -e
sudo -v

SOURCE_LIST="/etc/apt/sources.list"
BACKUP_FILE="${SOURCE_LIST}.bak"

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


message -title "Actualizando el sistema actual..."
sudo apt update -y && sudo apt upgrade -y >/dev/null 2>&1
if [[ $? -eq 0 ]]; then
    message -success "Updated packages"
else
    message -error "Could not update packages"
fi


if [[ ! -f "$BACKUP_FILE" ]]; then
    message -subtitle "Creating a backup copy of $SOURCE_LIST..."
    sudo cp "$SOURCE_LIST" "$BACKUP_FILE"
    message -success "Backup created in ${BACKUP_FILE}."
else
    message -warning "The backup already exists in ${BACKUP_FILE}."
fi


message -subtitle "Configurando las nuevas fuentes de Debian testing..."
NEW_SOURCES="\
deb http://deb.debian.org/debian testing main contrib non-free non-free-firmware
deb-src http://deb.debian.org/debian testing main contrib non-free non-free-firmware

deb http://security.debian.org/debian-security testing-security main contrib non-free non-free-firmware
deb-src http://security.debian.org/debian-security testing-security main contrib non-free non-free-firmware

deb http://deb.debian.org/debian testing-updates main contrib non-free non-free-firmware
deb-src http://deb.debian.org/debian testing-updates main contrib non-free non-free-firmware
"


echo "$NEW_SOURCES" | sudo tee "$SOURCE_LIST" > /dev/null
if grep -q "testing" "$SOURCE_LIST"; then
    message -success "New sources correctly configured in $SOURCE_LIST."
else
    message -error "Error updating $SOURCE_LIST. Abort."
    exit 1
fi


message -subtitle "Updating package index with the new repositories..."
sudo apt update -y >/dev/null 2>&1
if [[ $? -eq 0 ]]; then
    message -success "Updated packages"
else
    message -error "Could not update packages"
fi


message -title "Performing the complete upgrade to Debian testing..."
sudo apt upgrade -y >/dev/null 2>&1
sudo apt full-upgrade -y >/dev/null 2>&1
if [[ $? -eq 0 ]]; then
    message -success "Full upgraded packages"
else
    message -error "Could not upgrade packages"
fi


message -subtitle "Eliminando paquetes innecesarios..."
sudo apt autoremove --purge -y >/dev/null 2>&1
if [[ $? -eq 0 ]]; then
    message -success "Unnecessary packages removed."
else
    message -error "Unnecessary packages could not be removed."
fi


message -approval "The system has been successfully upgraded to Debian testing."
exit 1
