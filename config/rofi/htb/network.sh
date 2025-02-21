#!/usr/bin/env bash

wifi=$(/usr/sbin/ifconfig wlp1s0 2>/dev/null | grep "inet " | awk '{print $2}' | tr -d '\n')
virtual=$(/usr/sbin/ifconfig enp0s3 2>/dev/null | grep "inet " | awk '{print $2}' | tr -d '\n')
ethernet=$(/usr/sbin/ifconfig enp2s0 2>/dev/null | grep "inet " | awk '{print $2}' | tr -d '\n')

if [ -n "$ethernet" ]; then
    echo "󰈀 $ethernet"
elif [ -n "$wifi" ]; then
    echo "󰖩 $wifi"
elif [ -n "$virtual" ]; then
    echo "󰌘 $virtual"
else
    echo " You're Offline"
fi
