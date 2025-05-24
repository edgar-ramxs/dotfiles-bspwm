#!/usr/bin/env bash

#   █████╗ ██╗   ██╗████████╗ ██████╗ ███████╗████████╗ █████╗ ██████╗ ████████╗
#  ██╔══██╗██║   ██║╚══██╔══╝██╔═══██╗██╔════╝╚══██╔══╝██╔══██╗██╔══██╗╚══██╔══╝
#  ███████║██║   ██║   ██║   ██║   ██║███████╗   ██║   ███████║██████╔╝   ██║   
#  ██╔══██║██║   ██║   ██║   ██║   ██║╚════██║   ██║   ██╔══██║██╔══██╗   ██║   
#  ██║  ██║╚██████╔╝   ██║   ╚██████╔╝███████║   ██║   ██║  ██║██║  ██║   ██║   
#  ╚═╝  ╚═╝ ╚═════╝    ╚═╝    ╚═════╝ ╚══════╝   ╚═╝   ╚═╝  ╚═╝╚═╝  ╚═╝   ╚═╝   

## Set the keyboard layout to Latin American Spanish
setxkbmap -layout latam &

## Resetting screen dimensions
xrandr --output Virtual1 --mode 1920x1080 --rate 60.00 &
sleep 0.5

## Reset wallpaper
nitrogen --restore &
sleep 0.5

## Run window composer
picom --config $HOME/.config/picom/picom.conf &
sleep 0.5

## Reset Pywal color palette
$HOME/.config/bspwm/scripts/bspwm-pywal.sh &
sleep 0.5

## Execute taskbars
$HOME/.config/bspwm/scripts/bspwm-polybar.sh &
sleep 0.5

## Enable toolkits and applications
/usr/lib/policykit-1-gnome/polkit-gnome-authentication-agent-1 &
xsetroot -cursor_name left_ptr &
xfce4-power-manager &
nm-applet &
blueman-applet &
dunst -conf $HOME/.config/dunst/dunstrc &
sleep 0.5
