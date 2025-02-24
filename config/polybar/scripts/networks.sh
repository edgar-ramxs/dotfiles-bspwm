#!/usr/bin/env bash

INFO=$(nmcli -t -f DEVICE,TYPE,STATE,CONNECTION device status)
DEVICE_ETHE=$(echo "$INFO" | grep -E "^enp2s0:ethernet:" | awk -F ':' '{print $3}')
DEVICE_WIFI=$(echo "$INFO" | grep -E "^wlp1s0:wifi:" | awk -F ':' '{print $3}')


if [ "$DEVICE_ETHE" = "unavailable" ] && [ "$DEVICE_WIFI" = "disconnected" ]; then 
    echo "󱚼 "
elif [ "$DEVICE_ETHE" = "unavailable" ] && [ "$DEVICE_WIFI" = "connected" ]; then 
    echo "󱚽 "
else 
    echo "󱛁 "
fi

# 󰖩
# 󱚵
# 󱚼
# 󱚽
# 󱚾
# 󱚿
# 󱛁
# 󰖪
# 󱛀


# wifi_list=$(nmcli -t -f SSID,SIGNAL device wifi list | sed '/^:/d' | awk -F ':' '{print $1}' | sort | uniq | wc -l)
# connection=$(nmcli -t -f NAME,TYPE,DEVICE connection show --active | grep "wlp1s0" | awk -F ":" '{print $1}')

# echo $DEVICE_ETHE
# echo $DEVICE_WIFI


# nmcli device status       => obtener información completa sobre dispositivos conocidos 
# nmcli connection show     => obtener un resumen de los perfiles de las conexiones activas.
# nmcli device wifi list    => 

# CONECTADO AL ETHERNET
# no hay redes disponibles, no hay conexion ninguna 
# hay redes disponibles, no esta conectado 󰖩
# hay redes disponibles, estoy conectado 

# nmcli -t -f DEVICE,STATE device status
# nmcli connection show --active
# nmcli dev wifi | grep "*"

# nmcli con up "Flexiando wifi"