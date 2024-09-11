#!/usr/bin/env bash

source functions.sh

DIR_DOWNLOADS="$DIR_REPO/fonts"
DIR_FONTS="/usr/share/fonts"

message -title "Installing and downloading fonts."
sleep 0.5

font_names=("FiraCode" "CascadiaCode" "Iosevka" "Hack")

for font_name in "${font_names[@]}"; do

    curl -L "https://github.com/ryanoasis/nerd-fonts/releases/latest/download/${font_name}.tar.xz" -o "$DIR_DOWNLOADS/${font_name}.tar.xz" >/dev/null 2>&1
    sleep 1

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
