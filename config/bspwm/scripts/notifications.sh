#!/bin/sh

[ -f "$HOME/.cache/wal/colors.sh" ] && . "$HOME/.cache/wal/colors.sh"

pidof dunst && killall dunst

DUNST_FILE=~/.config/dunst/dunstrc

sed -i '/background = /s/.*/    background = "'$background'"/' $DUNST_FILE
sed -i '/foreground = /s/.*/    background = "'$foreground'"/' $DUNST_FILE
sed -i '/frame_color = /s/.*/    background = "'$foreground'"/' $DUNST_FILE

dunst -config ~/.config/dunst/dunstrc > /dev/null 2>&1 &
