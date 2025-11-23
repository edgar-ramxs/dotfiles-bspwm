#!/usr/bin/env bash

# Settings
num_cols="3"
num_rows="1"
host=`hostname`
prompt="Networks"
mesg="Connections: Networks Module"
uptime="`uptime -p | sed -e 's/up //g'`"
theme="$HOME/.config/rofi/views/powermenu.rasi"
distro_icon=$(~/.config/bspwm/scripts/distro.sh)

# Targets
ip_vpn=$(~/.config/rofi/htb/vpn.sh)
ip_target=$(~/.config/rofi/htb/target.sh)
ip_network=$(~/.config/rofi/htb/network.sh)

rofi_cmd() {
	rofi -theme-str "listview {columns: $num_cols; lines: $num_rows;}" \
		-theme-str "textbox-prompt-colon { str: \" $distro_icon\"; }" \
		-dmenu -p "$prompt" -mesg "$mesg" -theme "$theme"
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
