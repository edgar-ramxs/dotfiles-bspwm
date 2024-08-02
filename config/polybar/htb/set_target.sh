#!/usr/bin/env bash

ip_target=$(cat ~/.config/polybar/htb/htb_target | awk '{print $1}')
name_target=$(cat ~/.config/polybar/htb/htb_target | awk '{print $2}')

if [ $ip_target ] && [ $name_target ]; then
    echo "󰞇  $ip_target - $name_target"
elif [ $(cat ~/.config/polybar/htb/htb_target | wc -w) -eq 1 ]; then
    echo "󱓇  $ip_target"
else
    echo "  No target "
fi
