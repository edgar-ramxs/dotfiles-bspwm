#!/usr/bin/env bash

#   █████╗ ██╗   ██╗████████╗ ██████╗ ███████╗████████╗ █████╗ ██████╗ ████████╗
#  ██╔══██╗██║   ██║╚══██╔══╝██╔═══██╗██╔════╝╚══██╔══╝██╔══██╗██╔══██╗╚══██╔══╝
#  ███████║██║   ██║   ██║   ██║   ██║███████╗   ██║   ███████║██████╔╝   ██║   
#  ██╔══██║██║   ██║   ██║   ██║   ██║╚════██║   ██║   ██╔══██║██╔══██╗   ██║   
#  ██║  ██║╚██████╔╝   ██║   ╚██████╔╝███████║   ██║   ██║  ██║██║  ██║   ██║   
#  ╚═╝  ╚═╝ ╚═════╝    ╚═╝    ╚═════╝ ╚══════╝   ╚═╝   ╚═╝  ╚═╝╚═╝  ╚═╝   ╚═╝   

## Graphics problems with Java applications in certain window managers
# wmname LG3D &
# vmware-user-suid-wrapper &

# Set the keyboard layout to Latin American Spanish
setxkbmap -layout latam &

# Resetting screen dimensions
xrandr --output HDMI-1 --mode 1920x1080 --rate 60.00 &
sleep 0.5

# Reset wallpaper
nitrogen --restore &
sleep 0.5

# Run window composer
picom --config $HOME/.config/picom/picom.conf --no-vsync &
sleep 0.5

# Execute taskbars
$HOME/.config/bspwm/scripts/bspwm-polybar.sh &
sleep 0.5

# Reset Pywal color palette
$HOME/.config/bspwm/scripts/bspwm-pywal.sh &
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
