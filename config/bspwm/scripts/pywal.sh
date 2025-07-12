#!/usr/bin/env bash

FILE_WALLPAPER="$HOME/.config/nitrogen/bg-saved.cfg"
KITTY_COLORS="$HOME/.cache/wal/colors-kitty.conf"
KITTY_THEME="$HOME/.config/kitty/theme.conf"

WALLPAPER=$(grep 'file=' "$FILE_WALLPAPER" | cut -d '=' -f2)
wal -i "$WALLPAPER" -o "$HOME/.config/bspwm/scripts/notifications.sh"

FG_COLOR=$(grep '^foreground' "$KITTY_COLORS" | awk '{print $2}')
BG_COLOR=$(grep '^background' "$KITTY_COLORS" | awk '{print $2}')

sed -i \
    -e "s/^cursor_text_color.*/cursor_text_color        $BG_COLOR/" \
    -e "s/^active_border_color.*/active_border_color        $BG_COLOR/" \
    -e "s/^inactive__border_color.*/inactive__border_color        $BG_COLOR/" \
    -e "s/^active_tab_foreground.*/active_tab_foreground        $BG_COLOR/" \
    -e "s/^active_tab_background.*/active_tab_background        $BG_COLOR/" \
    -e "s/^inactive_tab_foreground.*/inactive_tab_foreground        $BG_COLOR/" \
    -e "s/^inactive_tab_background.*/inactive_tab_background        $BG_COLOR/" \
    "$KITTY_THEME"

kitty @ set-colors --configured "$HOME/.config/kitty/kitty.conf"
