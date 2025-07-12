#!/usr/bin/env bash

if command -v apt >/dev/null 2>&1; then
	count=$(apt list --installed 2>/dev/null | grep -v 'Listing' | wc -l)
	mesg="Installed Packages => $count (apt)"
elif command -v pacman >/dev/null 2>&1; then
	count=$(pacman -Qq | wc -l)
	mesg="Installed Packages => $count (pacman)"
elif command -v dnf >/dev/null 2>&1; then
	count=$(dnf list installed 2>/dev/null | grep -v '^Installed Packages' | wc -l)
	mesg="Installed Packages => $count (dnf)"
elif command -v rpm >/dev/null 2>&1; then
	count=$(rpm -qa | wc -l)
	mesg="Installed Packages => $count (rpm)"
else
	mesg="Cannot detect packages manager."
fi

# Settings
num_cols="6"
num_rows="1"
prompt="Applications"
theme="~/.config/rofi/views/applets.rasi"
distro_icon=$(~/.config/bspwm/scripts/distro.sh)

# Commands
term_cmd="kitty"
text_cmd="geany"
file_cmd="thunar"
web_cmd="firefox"
music_cmd="kitty -e ncmpcpp"
setting_cmd="xfce4-settings-manager"

# Options
option_1=" "
option_2=" "
option_3=" "
option_4="󰈹 "
option_5="󰝚 "
option_6=" "

rofi_cmd() {
	rofi -theme-str "listview {columns: $num_cols; lines: $num_rows;}" \
		-theme-str "textbox-prompt-colon { str: \" $distro_icon\"; }" \
		-dmenu \
		-p "$prompt" \
		-mesg "$mesg" \
		-markup-rows \
		-theme ${theme}
}

run_rofi() {
	echo -e "$option_1\n$option_2\n$option_3\n$option_4\n$option_5\n$option_6" | rofi_cmd
}

run_cmd() {
	if [[ "$1" == '--opt1' ]]; then
		${term_cmd}
	elif [[ "$1" == '--opt2' ]]; then
		${file_cmd}
	elif [[ "$1" == '--opt3' ]]; then
		${text_cmd}
	elif [[ "$1" == '--opt4' ]]; then
		${web_cmd}
	elif [[ "$1" == '--opt5' ]]; then
		${music_cmd}
	elif [[ "$1" == '--opt6' ]]; then
		${setting_cmd}
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
