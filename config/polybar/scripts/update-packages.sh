#!/usr/bin/env bash

kitty -e bash -c 'sudo apt update -y && sudo apt uprage -y; echo; read -p "Presiona ENTER para cerrar..."'
sleep 1
~/.config/polybar/scripts/packages.sh
polybar-msg hook packages 1
