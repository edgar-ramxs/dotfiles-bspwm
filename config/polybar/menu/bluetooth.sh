#!/usr/bin/env bash

# Obtener el estado de "Powered" del Bluetooth
bluetooth_status=$(bluetoothctl show | grep "Powered:" | awk '{print $2}')

if [ "$bluetooth_status" = "yes" ]; then
    # Bluetooth está encendido
    # Verificar si hay dispositivos conectados
    device_connected=$(bluetoothctl info | grep 'Connected: yes' | wc -l)
    
    if [ "$device_connected" -gt 0 ]; then
        echo "󰂰"  # Bluetooth está encendido y conectado a un dispositivo
    else
        echo ""  # Bluetooth está encendido pero no hay dispositivos conectados
    fi
else
    # Bluetooth está apagado
    echo "󰂲" 
fi
