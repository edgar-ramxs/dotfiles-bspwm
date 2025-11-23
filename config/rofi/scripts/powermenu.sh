#!/usr/bin/env bash

# Settings
distro_icon=$(~/.config/bspwm/scripts/distro.sh)
theme="$HOME/.config/rofi/views/powermenu.rasi"
uptime="`uptime -p | sed -e 's/up //g'`"
host=`hostname`
num_cols="5"
num_rows="1"

# Options
lock='  Lock'
reboot='  Reboot'
logout='󰗽  Logout'
suspend='󰒲  Suspend'
shutdown='  Shutdown'

# Confirmation Options
option_no='󰜺  No'
option_yes='  Yes'


rofi_cmd() {
	rofi -theme-str "listview {columns: $num_cols; lines: $num_rows;}" \
		-theme-str "textbox-prompt-colon { str: \" $distro_icon\"; }" \
		-dmenu -p "$host" -mesg "Uptime: $uptime" -theme "${theme}"
}

confirm_cmd() {
	rofi \
		-theme-str 'window {location: center; anchor: center; fullscreen: false; width: 250px;}' \
		-theme-str 'mainbox {children: [ "message", "listview" ];}' \
		-theme-str 'listview {columns: 2; lines: 1;}' \
		-theme-str 'element-text {horizontal-align: 0.5;}' \
		-theme-str 'textbox {horizontal-align: 0.5;}' \
		-dmenu -p 'Confirmation' -mesg 'Are you Sure?' \
		-theme ${theme}
}

confirm_exit() {
	echo -e "$option_yes\n$option_no" | confirm_cmd
}

run_rofi() {
	echo -e "$lock\n$suspend\n$logout\n$reboot\n$shutdown" | rofi_cmd
}

run_cmd() {
	selected="$(confirm_exit)"
	if [[ "$selected" == "$option_yes" ]]; then
		if [[ $1 == '--shutdown' ]]; then
			systemctl poweroff
		elif [[ $1 == '--reboot' ]]; then
			systemctl reboot
		elif [[ $1 == '--suspend' ]]; then
			mpc -q pause
			amixer set Master mute
			systemctl suspend
		elif [[ $1 == '--logout' ]]; then
			if [[ "$DESKTOP_SESSION" == 'openbox' ]]; then
				openbox --exit
			elif [[ "$DESKTOP_SESSION" == 'bspwm' ]]; then
				bspc quit
			elif [[ "$DESKTOP_SESSION" == 'i3' ]]; then
				i3-msg exit
			elif [[ "$DESKTOP_SESSION" == 'plasma' ]]; then
				qdbus org.kde.ksmserver /KSMServer logout 0 0 0
			fi
		fi
	else
		exit 0
	fi
}

chosen="$(run_rofi)"
case ${chosen} in
    $shutdown)
		run_cmd --shutdown
        ;;
    $reboot)
		run_cmd --reboot
        ;;
    $lock)
		if [[ -x '/usr/bin/betterlockscreen' ]]; then
			betterlockscreen -l
		elif [[ -x '/usr/bin/i3lock' ]]; then
			i3lock
		fi
        ;;
    $suspend)
		run_cmd --suspend
        ;;
    $logout)
		run_cmd --logout
        ;;
esac
