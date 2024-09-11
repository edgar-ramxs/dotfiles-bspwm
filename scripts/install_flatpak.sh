#!/usr/bin/env bash

source functions.sh

sudo apt install -y flatpak >/dev/null 2>&1
check_execution $? "Failed to updating packages" "Update packages"
sleep 0.5

sudo apt install -y gnome-software-plugin-flatpak >/dev/null 2>&1
check_execution $? "Failed to updating packages" "Update packages"
sleep 0.5

sudo flatpak remote-add --if-not-exists flathub https://dl.flathub.org/repo/flathub.flatpakrepo
check_execution $? "Failed to updating packages" "Update packages"
sleep 0.5
