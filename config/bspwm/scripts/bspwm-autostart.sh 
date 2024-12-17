#!/usr/bin/env bash

#   █████╗ ██╗   ██╗████████╗ ██████╗ ███████╗████████╗ █████╗ ██████╗ ████████╗
#  ██╔══██╗██║   ██║╚══██╔══╝██╔═══██╗██╔════╝╚══██╔══╝██╔══██╗██╔══██╗╚══██╔══╝
#  ███████║██║   ██║   ██║   ██║   ██║███████╗   ██║   ███████║██████╔╝   ██║   
#  ██╔══██║██║   ██║   ██║   ██║   ██║╚════██║   ██║   ██╔══██║██╔══██╗   ██║   
#  ██║  ██║╚██████╔╝   ██║   ╚██████╔╝███████║   ██║   ██║  ██║██║  ██║   ██║   
#  ╚═╝  ╚═╝ ╚═════╝    ╚═╝    ╚═════╝ ╚══════╝   ╚═╝   ╚═╝  ╚═╝╚═╝  ╚═╝   ╚═╝   

wmname LG3D &
vmware-user-suid-wrapper &

# Set the keyboard layout to Latin American Spanish
setxkbmap -layout latam &

# Resetting screen dimensions
xrandr --output Virtual1 --mode 1920x1080 --rate 60.00 &

# Reset wallpaper
nitrogen --restore &

# Run window composer
picom --config $HOME/.config/picom/picom.conf --no-vsync &
sleep 0.5

# Execute taskbars
$HOME/.config/bspwm/scripts/bspwm_polybar.sh &
sleep 0.5

# Reset Pywal color palette
$HOME/.config/bspwm/scripts/bspwm_pywal.sh &
sleep 0.5

# Enable authenticator for rofi
/usr/lib/policykit-1-gnome/polkit-gnome-authentication-agent-1 &

# Block cursor in polybar zones
xsetroot -cursor_name left_ptr &

# Enable xfce battery manager
xfce4-power-manager &

# Enable network manager
nm-applet &

# Enable bluetooth manager
blueman-applet &

sleep 0.5