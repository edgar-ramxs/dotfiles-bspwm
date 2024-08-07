#!/usr/bin/env bash

# Obtener direcciones IP para cada interfaz, si existen
wifi=$(ifconfig wlan0 2>/dev/null | grep "inet " | awk '{print $2}')
virtual=$(ifconfig enp0s3 2>/dev/null | grep "inet " | awk '{print $2}')
ethernet=$(ifconfig eth0 2>/dev/null | grep "inet " | awk '{print $2}')

# Verificar y mostrar la IP correspondiente
if [ -n "$wifi" ]; then
    echo "󰈀 $wifi"
elif [ -n "$virtual" ]; then
    echo "󰈀 $virtual"
elif [ -n "$ethernet" ]; then
    echo "󰈀 $ethernet"
else
    echo "󰈀 You're Offline"
fi
