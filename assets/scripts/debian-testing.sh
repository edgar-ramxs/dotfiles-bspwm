#!/usr/bin/env bash

#  ██████╗ ███████╗██████╗ ██╗ █████╗ ███╗   ██╗    ████████╗███████╗███████╗████████╗██╗███╗   ██╗ ██████╗ 
#  ██╔══██╗██╔════╝██╔══██╗██║██╔══██╗████╗  ██║    ╚══██╔══╝██╔════╝██╔════╝╚══██╔══╝██║████╗  ██║██╔════╝ 
#  ██║  ██║█████╗  ██████╔╝██║███████║██╔██╗ ██║       ██║   █████╗  ███████╗   ██║   ██║██╔██╗ ██║██║  ███╗
#  ██║  ██║██╔══╝  ██╔══██╗██║██╔══██║██║╚██╗██║       ██║   ██╔══╝  ╚════██║   ██║   ██║██║╚██╗██║██║   ██║
#  ██████╔╝███████╗██████╔╝██║██║  ██║██║ ╚████║       ██║   ███████╗███████║   ██║   ██║██║ ╚████║╚██████╔╝
#  ╚═════╝ ╚══════╝╚═════╝ ╚═╝╚═╝  ╚═╝╚═╝  ╚═══╝       ╚═╝   ╚══════╝╚══════╝   ╚═╝   ╚═╝╚═╝  ╚═══╝ ╚═════╝ 

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

# ========== EXIT HANDLING ==========
trap exiting_script INT
function exiting_script() {
    message -cancel "Exiting..."
    exit 1
}

# ========== SYSTEM PREPARATION ==========
set -e
sudo -v

SOURCE_LIST="/etc/apt/sources.list"
BACKUP_FILE="${SOURCE_LIST}.bak"

message -title "Starting system upgrade to Debian testing..."

# Create backup of current sources.list
message -subtitle "Creating backup of $SOURCE_LIST..."
if [[ ! -f "$BACKUP_FILE" ]]; then
    sudo cp "$SOURCE_LIST" "$BACKUP_FILE"
    message -success "Backup created at $BACKUP_FILE."
else
    message -warning "Backup already exists at $BACKUP_FILE."
fi

# Replace sources.list with testing repositories
message -subtitle "Setting up Debian testing repositories..."
NEW_SOURCES="\
deb http://deb.debian.org/debian testing main contrib non-free non-free-firmware
deb-src http://deb.debian.org/debian testing main contrib non-free non-free-firmware

deb http://security.debian.org/debian-security testing-security main contrib non-free non-free-firmware
deb-src http://security.debian.org/debian-security testing-security main contrib non-free non-free-firmware

deb http://deb.debian.org/debian testing-updates main contrib non-free non-free-firmware
deb-src http://deb.debian.org/debian testing-updates main contrib non-free non-free-firmware
"

echo "$NEW_SOURCES" | sudo tee "$SOURCE_LIST" >/dev/null
if grep -q "testing" "$SOURCE_LIST"; then
    message -success "Sources list successfully updated."
else
    message -error "Failed to update $SOURCE_LIST."
    exit 1
fi

# Update package index
message -subtitle "Updating package index..."
if sudo apt update -y >/dev/null 2>&1; then
    message -success "Package index updated successfully."
else
    message -error "Failed to update package index."
fi

# Upgrade system
message -subtitle "Upgrading installed packages..."
if sudo apt upgrade -y >/dev/null 2>&1; then
    message -success "Packages upgraded successfully."
else
    message -error "Package upgrade failed."
fi

# Full upgrade
message -subtitle "Performing full upgrade..."
if sudo apt full-upgrade -y >/dev/null 2>&1; then
    message -success "Full upgrade completed successfully."
else
    message -error "Full upgrade failed."
fi

# Remove unnecessary packages
message -subtitle "Removing unnecessary packages..."
if sudo apt autoremove --purge -y >/dev/null 2>&1; then
    message -success "Unnecessary packages removed."
else
    message -error "Failed to remove unnecessary packages."
fi

message -approval "The system has been successfully upgraded to Debian testing."
exit 0
