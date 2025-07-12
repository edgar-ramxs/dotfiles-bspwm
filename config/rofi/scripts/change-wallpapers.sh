#!/usr/bin/env bash

WALLPAPERS_DIR="$HOME/.local/wallpapers"
SELECTED_WALLPAPER=$(find "$WALLPAPERS_DIR" -type f \( -iname "*.jpg" -o -iname "*.png" \) | sort | rofi -dmenu -i -p "Elige fondo: ")

if [[ -n "$SELECTED_WALLPAPER" ]]; the
    sxiv -t -b -g 800x450+300+200 "$SELECTED_WALLPAPER" &
    CONFIRM=$(echo -e "SI\NO" | rofi -dmenu -p "¿Aplicar fondo?")
    pkill sxiv

    if[[ "$CONFIRM" == "SI" ]]; then
        feh --bg-scale "$SELECTED_WALLPAPER"
        echo "$SELECTED_WALLPAPER" > ~/.config/feh/current_wallpaper
    fi
fi
