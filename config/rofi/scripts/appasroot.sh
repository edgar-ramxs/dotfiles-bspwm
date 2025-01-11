#!/usr/bin/env bash

# Import Current Theme
theme="$HOME/.config/rofi/views/applets.rasi"

# Theme Elements
prompt='Applications'
mesg='Run Applications as Root'
list_col='5'
list_row='1'
win_width='700px'

# Options
option_1=" "
option_2=" "
option_3=" "
option_4="󰈹 "
option_5=" "

# Rofi CMD
rofi_cmd() {
	rofi -theme-str "window {width: $win_width;}" \
		-theme-str "listview {columns: $list_col; lines: $list_row;}" \
		-theme-str 'textbox-prompt-colon {str: "";}' \
		-dmenu \
		-p "$prompt" \
		-mesg "$mesg" \
		-markup-rows \
		-theme ${theme}
}

# Pass variables to rofi dmenu
run_rofi() {
	echo -e "$option_1\n$option_2\n$option_3\n$option_4\n$option_5" | rofi_cmd
}

# Execute Command
run_cmd() {
	polkit_cmd="pkexec env PATH=$PATH DISPLAY=$DISPLAY XAUTHORITY=$XAUTHORITY"
	if [[ "$1" == '--opt1' ]]; then
		${polkit_cmd} alacritty
	elif [[ "$1" == '--opt2' ]]; then
		${polkit_cmd} dbus-run-session thunar
	elif [[ "$1" == '--opt3' ]]; then
		${polkit_cmd} geany
	elif [[ "$1" == '--opt4' ]]; then
		${polkit_cmd} alacritty -e ranger
	elif [[ "$1" == '--opt5' ]]; then
		${polkit_cmd} alacritty -e vim
	fi
}

# Actions
chosen="$(run_rofi)"
case ${chosen} in
    $option_1)
		run_cmd --opt1
        ;;
    $option_2)
		run_cmd --opt2
        ;;
    $option_3)
		run_cmd --opt3
        ;;
    $option_4)
		run_cmd --opt4
        ;;
    $option_5)
		run_cmd --opt5
        ;;
esac

