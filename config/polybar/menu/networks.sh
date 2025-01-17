#!/usr/bin/env bash

IP_VPN=$(~/.config/polybar/htb/vpn.sh)
IP_VICTIMA=$(~/.config/polybar/htb/target.sh)
IP_RED_LOCAL=$(~/.config/polybar/htb/network.sh)

dir="$HOME/.config/rofi"
theme='menu_networks'
host=$(hostname)

rofi_cmd() {
	rofi -dmenu \
		-p "$host" \
		-theme "${dir}/${theme}.rasi"
}

run_cmd() {
	if [[ $1 == '--vpn' ]]; then
		echo $IP_VPN | awk '{print $2}' | tr -d '\n' | xclip -selection clipboard 
	elif [[ $1 == '--local' ]]; then
		echo $IP_RED_LOCAL | awk '{print $2}' | tr -d '\n' | xclip -selection clipboard 
	elif [[ $1 == '--victima' ]]; then
		echo $IP_VICTIMA | awk '{print $2}' | tr -d '\n' | xclip -selection clipboard
	fi
}

run_rofi() {
	echo -e "$IP_VPN\n$IP_RED_LOCAL\n$IP_VICTIMA" | rofi_cmd
}

chosen="$(run_rofi)"
case ${chosen} in
    $IP_VPN)
		run_cmd --vpn
        ;;
    $IP_RED_LOCAL)
		run_cmd --local
        ;;
    $IP_VICTIMA)
		run_cmd --victima
        ;;
esac

