#!/usr/bin/env bash

wifi=$(ifconfig wlan0 2>/dev/null | grep "inet " | awk '{print $2}' | tr -d '\n')
virtual=$(ifconfig enp0s3 2>/dev/null | grep "inet " | awk '{print $2}' | tr -d '\n')
ethernet=$(ifconfig eth0 2>/dev/null | grep "inet " | awk '{print $2}' | tr -d '\n')

if [ -n "$wifi" ]; then
    echo "󰈀 $wifi"
elif [ -n "$virtual" ]; then
    echo "󰈀 $virtual"
elif [ -n "$ethernet" ]; then
    echo "󰈀 $ethernet"
else
    echo "󰈀 You're Offline"
fi
