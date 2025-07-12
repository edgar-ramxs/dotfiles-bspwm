#!/usr/bin/env bash

# Settings
num_cols="6"
num_rows="1"
prompt="Music"
theme="$HOME/.config/rofi/views/applets.rasi"
distro_icon=$(~/.config/bspwm/scripts/distro.sh)

# Theme Elements
status="`mpc status`"
if [[ -z "$status" ]]; then
	mesg="MPD is Offline"
else
	mesg="`mpc -f "%title%" current` :: `mpc status | grep "#" | awk '{print $3}'`"
fi

# Options
if [[ ${status} == *"[playing]"* ]]; then
	option_1="󰐊 "
else
	option_1="󰐎 " 
fi
option_2="󰏤 "
option_3="󰒮 "
option_4="󰒭 "
option_5="󰑖 "
option_6=" "

rofi_cmd() {
	rofi -theme-str "listview {columns: $num_cols; lines: $num_rows;}" \
		-theme-str "textbox-prompt-colon { str: \" $distro_icon\"; }" \
		-dmenu -p "$prompt" -mesg "$mesg" -markup-rows -theme ${theme}
}

run_rofi() {
	echo -e "$option_1\n$option_2\n$option_3\n$option_4\n$option_5\n$option_6" | rofi_cmd
}

run_cmd() {
	if [[ "$1" == '--opt1' ]]; then
		mpc -q toggle && notify-send -u low -t 1000 " `mpc current`"
	elif [[ "$1" == '--opt2' ]]; then
		mpc -q stop
	elif [[ "$1" == '--opt3' ]]; then
		mpc -q prev && notify-send -u low -t 1000 " `mpc current`"
	elif [[ "$1" == '--opt4' ]]; then
		mpc -q next && notify-send -u low -t 1000 " `mpc current`"
	elif [[ "$1" == '--opt5' ]]; then
		mpc -q repeat
	elif [[ "$1" == '--opt6' ]]; then
		mpc -q random
	fi
}

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
    $option_6)
		run_cmd --opt6
        ;;
esac
