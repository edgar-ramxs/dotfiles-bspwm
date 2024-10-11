#!/usr/bin/env bash

CONFIG_FILE="$HOME/.config/nitrogen/bg-saved.cfg"
WALLPAPER=$(grep 'file=' "$CONFIG_FILE" | cut -d '=' -f2)
wal -i "$WALLPAPER"
