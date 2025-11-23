#!/usr/bin/env bash

#  ███╗   ██╗███████╗██████╗ ██████╗     ███████╗ ██████╗ ███╗   ██╗████████╗███████╗
#  ████╗  ██║██╔════╝██╔══██╗██╔══██╗    ██╔════╝██╔═══██╗████╗  ██║╚══██╔══╝██╔════╝
#  ██╔██╗ ██║█████╗  ██████╔╝██║  ██║    █████╗  ██║   ██║██╔██╗ ██║   ██║   ███████╗
#  ██║╚██╗██║██╔══╝  ██╔══██╗██║  ██║    ██╔══╝  ██║   ██║██║╚██╗██║   ██║   ╚════██║
#  ██║ ╚████║███████╗██║  ██║██████╔╝    ██║     ╚██████╔╝██║ ╚████║   ██║   ███████║
#  ╚═╝  ╚═══╝╚══════╝╚═╝  ╚═╝╚═════╝     ╚═╝      ╚═════╝ ╚═╝  ╚═══╝   ╚═╝   ╚══════╝
# LINK: https://github.com/ryanoasis/nerd-fonts/releases/latest/

# ========== AVAILABLE FONTS ==========
FONTS=(
    "0xProto" "3270" "Agave" "AnonymousPro" "Arimo" "AurulentSansMono"
    "BigBlueTerminal" "BitstreamVeraSansMono" "CascadiaCode" "CascadiaMono"
    "CodeNewRoman" "ComicShannsMono" "CommitMono" "Cousine" "D2Coding"
    "DaddyTimeMono" "DejaVuSansMono" "DroidSansMono" "EnvyCodeR"
    "FantasqueSansMono" "FiraCode" "FiraMono" "GeistMono" "Go-Mono"
    "Gohu" "Hack" "Hasklig" "HeavyData" "Hermit" "iA-Writer" "IBMPlexMono"
    "Inconsolata" "InconsolataGo" "InconsolataLGC" "IntelOneMono" "Iosevka"
    "IosevkaTerm" "IosevkaTermSlab" "JetBrainsMono" "Lekton" "LiberationMono"
    "Lilex" "MartianMono" "Meslo" "Monaspace" "Monofur" "Monoid" "Mononoki"
    "MPlus" "NerdFontsSymbolsOnly" "Noto" "OpenDyslexic" "Overpass"
    "ProFont" "ProggyClean" "Recursive" "RobotoMono" "ShareTechMono"
    "SourceCodePro" "SpaceMono" "Terminus" "Tinos" "Ubuntu" "UbuntuMono"
    "UbuntuSans" "VictorMono" "ZedMono"
)

# ========== HELPER FUNCTIONS ==========
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

trap exiting_script INT
function exiting_script() {
    message -cancel "Exiting...\n"
    exit 1
}

function is_valid_font() {
    local font_name="$1"
    for valid_font in "${FONTS[@]}"; do
        if [[ "$valid_font" == "$font_name" ]]; then
            return 0
        fi
    done
    return 1
}

# ========== MAIN FLOW ==========

# Check dependencies
if ! command -v curl &>/dev/null || ! command -v tar &>/dev/null; then
    message -error "Dependencies missing: curl and tar are required. Please install them first."
    exiting_script
fi

# Check arguments
if [ $# -eq 0 ]; then
    message -error "Error: Provide at least one font name or use --all to install all fonts."
    exiting_script
fi

# Request sudo upfront
sudo -v
message -title "Installing and downloading Nerd Fonts."

DIR_TMP="/tmp/fonts_tmp"
DIR_FONTS="/usr/share/fonts"
mkdir -p "$DIR_TMP"

# Determine which fonts to install
if [[ "$1" == "--all" ]]; then
    SELECTED_FONTS=("${FONTS[@]}")
else
    message -subtitle "Validating selected fonts..."
    SELECTED_FONTS=()
    for arg in "$@"; do
        if is_valid_font "$arg"; then
            SELECTED_FONTS+=("$arg")
        else
            message -error "Invalid font: $arg"
        fi
    done
    message -success "Font validation completed successfully."
fi

# Download and install each font
for font_name in "${SELECTED_FONTS[@]}"; do
    message -subtitle "Downloading $font_name..."

    FONT_URL="https://github.com/ryanoasis/nerd-fonts/releases/latest/download/${font_name}.tar.xz"
    ARCHIVE_PATH="$DIR_TMP/${font_name}.tar.xz"
    FONT_DIR="$DIR_FONTS/${font_name}"

    if curl -L "$FONT_URL" -o "$ARCHIVE_PATH" --silent --fail; then
        [[ -d "$FONT_DIR" ]] && sudo rm -rf "$FONT_DIR"
        sudo mkdir -p "$FONT_DIR"
        if sudo tar -xf "$ARCHIVE_PATH" -C "$FONT_DIR" --wildcards "*.ttf" >/dev/null 2>&1; then
            message -success "Font $font_name installed to $DIR_FONTS."
        else
            message -error "Error extracting $font_name."
        fi
    else
        message -error "Error downloading $font_name."
    fi
done

# Clean up
rm -rf "$DIR_TMP"
message -subtitle "Refreshing font cache..."
sudo fc-cache -fv >/dev/null 2>&1
message -success "Font installation process complete."