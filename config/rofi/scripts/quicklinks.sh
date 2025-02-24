#!/usr/bin/env bash

icono=$(~/.config/bspwm/scripts/bspwm-distro.sh)
theme="$HOME/.config/rofi/views/applets.rasi"
browser='Firefox'
prompt='Quick Links'
mesg="Using $browser as web browser"
list_col='6'
list_row='1'

# Options
option_1=" "
option_2="󰊫 "
option_3=" "
option_4=" "
option_5=" "
option_6=" "


rofi_cmd() {
	rofi -theme-str "listview {columns: $list_col; lines: $list_row;}" \
		-theme-str "textbox-prompt-colon { str: \" $icono\"; }" \
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
		xdg-open 'https://chatgpt.com/'
	elif [[ "$1" == '--opt2' ]]; then
		xdg-open 'https://mail.google.com/'
	elif [[ "$1" == '--opt3' ]]; then
		xdg-open 'https://www.youtube.com/'
	elif [[ "$1" == '--opt4' ]]; then
		xdg-open 'https://github.com/'
	elif [[ "$1" == '--opt5' ]]; then
		xdg-open 'https://www.reddit.com/'
	elif [[ "$1" == '--opt6' ]]; then
		xdg-open 'https://x.com/'
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
