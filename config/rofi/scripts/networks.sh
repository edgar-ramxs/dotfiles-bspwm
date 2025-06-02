#!/usr/bin/env bash

host=`hostname`
uptime="`uptime -p | sed -e 's/up //g'`"
icono=$(~/.config/bspwm/scripts/distro.sh)
theme="$HOME/.config/rofi/views/powermenu.rasi"
list_col='3'
list_row='1'

ip_vpn=$(~/.config/rofi/htb/vpn.sh)
ip_target=$(~/.config/rofi/htb/target.sh)
ip_network=$(~/.config/rofi/htb/network.sh)

rofi_cmd() {
	rofi -theme-str 'window {width: 800px;}' \
		-theme-str "listview {columns: $list_col; lines: $list_row;}" \
		-theme-str "textbox-prompt-colon { str: \" $icono\"; }" \
		-dmenu \
		-p "Networks" \
		-mesg " Connections: Ethical hacking module " \
		-theme "${theme}"
}

run_cmd() {
	if [[ $1 == '--vpn' ]]; then
		echo $ip_vpn | awk '{print $2}' | tr -d '\n' | xclip -selection clipboard 
	elif [[ $1 == '--local' ]]; then
		echo $ip_network | awk '{print $2}' | tr -d '\n' | xclip -selection clipboard 
	elif [[ $1 == '--victima' ]]; then
		echo $ip_target | awk '{print $2}' | tr -d '\n' | xclip -selection clipboard
	fi
}

run_rofi() {
	echo -e "$ip_vpn\n$ip_network\n$ip_target" | rofi_cmd
}

chosen="$(run_rofi)"
case ${chosen} in
    $ip_vpn)
		run_cmd --vpn
        ;;
    $ip_network)
		run_cmd --local
        ;;
    $ip_target)
		run_cmd --victima
        ;;
esac
