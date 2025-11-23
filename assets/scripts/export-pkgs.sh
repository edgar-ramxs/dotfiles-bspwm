#!/usr/bin/env bash

#  ██████╗  █████╗  ██████╗██╗  ██╗ █████╗  ██████╗ ███████╗███████╗
#  ██╔══██╗██╔══██╗██╔════╝██║ ██╔╝██╔══██╗██╔════╝ ██╔════╝██╔════╝
#  ██████╔╝███████║██║     █████╔╝ ███████║██║  ███╗█████╗  ███████╗
#  ██╔═══╝ ██╔══██║██║     ██╔═██╗ ██╔══██║██║   ██║██╔══╝  ╚════██║
#  ██║     ██║  ██║╚██████╗██║  ██╗██║  ██║╚██████╔╝███████╗███████║
#  ╚═╝     ╚═╝  ╚═╝ ╚═════╝╚═╝  ╚═╝╚═╝  ╚═╝ ╚═════╝ ╚══════╝╚══════╝

# ========== MESSAGES ==========
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
}

trap exiting_script INT
function exiting_script() {
    message -cancel "Exiting..."
    exit 1
}

# ========== EXPORT FUNCTION ==========
function export_packages() {
    local output_file="$1"
    local distro=""

    if command -v pacman &>/dev/null; then
        distro="arch"
        pacman -Qe | awk '{print $1}' > "$output_file"
    elif command -v apt &>/dev/null; then
        distro="debian"
        comm -23 \
            <(dpkg --get-selections | awk '{print $1}' | sort) \
            <(grep -vE '^Package|^$' /var/lib/dpkg/status | awk '/^Package:/ {print $2}' | sort -u) \
            > "$output_file"
    elif command -v dnf &>/dev/null; then
        distro="fedora"
        dnf list installed --quiet | awk 'NR>1 {print $1}' > "$output_file"
    elif command -v zypper &>/dev/null; then
        distro="suse"
        zypper se --installed-only | awk 'NR>2 {print $3}' > "$output_file"
    else
        message -error "Unsupported distribution. Cannot determine package manager."
        exit 1
    fi

    message -success "[$distro] Package list exported to: $output_file"
}

# ========== MAIN ==========
output_path="$1"

# Default output path if none given
if [[ -z "$output_path" ]]; then
    output_path="$HOME/.packages_list.pkgs"
fi

# Ensure parent directory exists
mkdir -p "$(dirname "$output_path")"

export_packages "$output_path"
