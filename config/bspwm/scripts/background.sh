#!/bin/bash

# Ruta al archivo de configuración de Nitrogen
CONFIG_FILE="$HOME/.config/nitrogen/bg-saved.cfg"

# Wallpaper
WALLPAPER=$(grep 'file=' "$CONFIG_FILE" | cut -d '=' -f2)

# Establecer paleta de colores del fondo de pantalla
wal -i "$WALLPAPER"