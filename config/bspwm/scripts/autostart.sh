#!/usr/bin/env bash

#   █████╗ ██╗   ██╗████████╗ ██████╗ ███████╗████████╗ █████╗ ██████╗ ████████╗
#  ██╔══██╗██║   ██║╚══██╔══╝██╔═══██╗██╔════╝╚══██╔══╝██╔══██╗██╔══██╗╚══██╔══╝
#  ███████║██║   ██║   ██║   ██║   ██║███████╗   ██║   ███████║██████╔╝   ██║   
#  ██╔══██║██║   ██║   ██║   ██║   ██║╚════██║   ██║   ██╔══██║██╔══██╗   ██║   
#  ██║  ██║╚██████╔╝   ██║   ╚██████╔╝███████║   ██║   ██║  ██║██║  ██║   ██║   
#  ╚═╝  ╚═╝ ╚═════╝    ╚═╝    ╚═════╝ ╚══════╝   ╚═╝   ╚═╝  ╚═╝╚═╝  ╚═╝   ╚═╝   

## Reset screen resolution first
~/.config/bspwm/scripts/monitors.sh &

## Set the keyboard layout to Spanish (Latin American)
setxkbmap -layout latam &

## Start compositor (for transparency and shadows)
picom --config $HOME/.config/picom/picom.conf &

## Restore wallpaper
nitrogen --restore &
sleep 0.5

## Load pywal color palette (may affect polybar colors)
~/.config/bspwm/scripts/pywal.sh &

## Start panel (after colors are loaded)
~/.config/bspwm/scripts/polybar.sh &

## Start keybindings manager
pgrep -x sxhkd > /dev/null || sxhkd &

## Enable background services
nm-applet &
blueman-applet &
xfce4-power-manager &
/usr/lib/policykit-1-gnome/polkit-gnome-authentication-agent-1 &
xsetroot -cursor_name left_ptr &
