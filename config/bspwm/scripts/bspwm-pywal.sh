#!/usr/bin/env bash

# Defines the Nitrogen configuration file that saves the current wallpaper.
CONFIG_FILE="$HOME/.config/nitrogen/bg-saved.cfg"

# Extract the path to the wallpaper image file from the configuration file.
# - Find the line containing 'file=' and cut the part after the '=' to get the path to the image.
WALLPAPER=$(grep 'file=' "$CONFIG_FILE" | cut -d '=' -f2)

# Generate and apply a color palette based on the background image using Pywal
wal -i "$WALLPAPER"
