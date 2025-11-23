#!/usr/bin/env bash

theme="$HOME/.config/rofi/themes/wifi.rasi"
wifi_list=$(nmcli --fields "SECURITY,SSID" device wifi list | sed 1d | sed 's/  */ /g' | sed -E "s/WPA*.?\S/ /g" | sed "s/^--/ /g" | sed "s/  //g" | sed "/--/d")

connected=$(nmcli -fields WIFI g)
if [[ "$connected" =~ "enabled" ]]; then
    toggle="󰖪  Disable Wi-Fi"
else
    toggle="󰖩  Enable Wi-Fi"
fi

chosen_network=$(echo -e "$toggle\n$wifi_list" | uniq -u | rofi -dmenu -theme ${theme} -i -selected-row 1 -p "Wi-Fi SSID: " )
chosen_id=$(echo "$chosen_network" | awk '{print substr($0, 4)}')

if [ -z "$chosen_network" ]; then
    exit
elif [ "$chosen_network" = "󰖩  Enable Wi-Fi" ]; then
    nmcli radio wifi on
elif [ "$chosen_network" = "󰖪  Disable Wi-Fi" ]; then
    nmcli radio wifi off
else
    success_message="You are now connected to the Wi-Fi network \"$chosen_id\"."
    if nmcli -g NAME connection | grep -qw "$chosen_id"; then
        nmcli connection up id "$chosen_id" && notify-send "Connection Established" "$success_message"
    else
        if [[ "$chosen_network" =~ "" ]]; then
            wifi_password=$(rofi -dmenu -theme ${theme} -p "Password: " )
        fi
        nmcli device wifi connect "$chosen_id" password "$wifi_password" && notify-send "Connection Established" "$success_message"
    fi
fi
