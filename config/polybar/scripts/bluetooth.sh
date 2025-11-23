#!/usr/bin/env bash

bluetooth_status=$(bluetoothctl show | grep "Powered:" | awk '{print $2}')
if [ "$bluetooth_status" = "yes" ]; then
    device_connected=$(bluetoothctl info | grep 'Connected: yes' | wc -l)

    if [ "$device_connected" -gt 0 ]; then
        echo "󰂰 "
    else
        echo " "
    fi
else
    echo "󰂲 "
fi
