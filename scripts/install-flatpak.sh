#!/usr/bin/env bash

# Instalar Flatpak
sudo apt update
sudo apt install -y flatpak
sudo flatpak remote-add --if-not-exists flathub https://dl.flathub.org/repo/flathub.flatpakrepo

# Instalar aplicaciones desde Flatpak
flatpak install flathub org.gimp.GIMP
flatpak install flathub org.libreoffice.LibreOffice
flatpak install flathub org.gnome.gitlab.somas.Apostrophe
flatpak install flathub org.gnome.Loupe
flatpak install flathub org.gnome.Boxes
flatpak install flathub org.kde.kdenlive
flatpak install flathub com.bitwarden.desktop
flatpak install flathub com.obsproject.Studio
flatpak install flathub com.github.tchx84.Flatseal
flatpak install flathub com.github.k4zmu2a.spacecadetpinball
flatpak install flathub io.github.amit9838.mousam
flatpak install flathub io.beekeeperstudio.Studio
flatpak install flathub us.zoom.Zoom
