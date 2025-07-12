#!/usr/bin/env bash

theme="$HOME/.config/rofi/themes/keybinds.rasi"
awk '/^[a-z]/ && last {print "<small>",$0,"\t",last,"</small>"} {last=""} /^#/{last=$0}' ~/.config/sxhkd/sxhkdrc | \
column -t -s $'\t' | rofi -dmenu -theme "$theme" -i -markup-rows -no-show-icons
