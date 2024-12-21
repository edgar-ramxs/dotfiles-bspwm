#!/usr/bin/env bash

ip_target=$(cat ~/.config/polybar/htb/mark-name | awk '{print $1}')
name_target=$(cat ~/.config/polybar/htb/mark-name | awk '{print $2}')

if [ $ip_target ] && [ $name_target ]; then
    echo "󰞇 $ip_target - $name_target"
elif [ $(cat ~/.config/polybar/htb/mark-name | wc -w) -eq 1 ]; then
    echo "󱓇 $ip_target"
else
    echo " No target "
fi
