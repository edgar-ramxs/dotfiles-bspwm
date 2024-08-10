#!/bin/sh

#   █████╗ ██╗   ██╗████████╗ ██████╗ ███████╗████████╗ █████╗ ██████╗ ████████╗
#  ██╔══██╗██║   ██║╚══██╔══╝██╔═══██╗██╔════╝╚══██╔══╝██╔══██╗██╔══██╗╚══██╔══╝
#  ███████║██║   ██║   ██║   ██║   ██║███████╗   ██║   ███████║██████╔╝   ██║   
#  ██╔══██║██║   ██║   ██║   ██║   ██║╚════██║   ██║   ██╔══██║██╔══██╗   ██║   
#  ██║  ██║╚██████╔╝   ██║   ╚██████╔╝███████║   ██║   ██║  ██║██║  ██║   ██║   
#  ╚═╝  ╚═╝ ╚═════╝    ╚═╝    ╚═════╝ ╚══════╝   ╚═╝   ╚═╝  ╚═╝╚═╝  ╚═╝   ╚═╝   
#                                                                               

# Configurar la distribucion del teclado a Español Latinoamericano
setxkbmap -layout latam &

# Reajustar las dimesiones de la pantalla
# xrandr --output Virtual1 --mode 1920x1080 --rate 75.00 &

# Reajustar fondo de pantalla
nitrogen --restore &

# Ejecutar compositor de ventanas
picom --config $HOME/.config/picom/picom.conf &

# Ejecutar barras de tareas
$HOME/.config/bspwm/scripts/polybar.sh &

# Reajustar paleta de colores de Pywal
$HOME/.config/bspwm/scripts/nitrogen.sh &

# Habilitar autenticador para rofi
/usr/lib/policykit-1-gnome/polkit-gnome-authentication-agent-1 &

# Bloquear cursor en zonas del polybar 
xsetroot -cursor_name left_ptr &

# Habilitar gestor de bateria de xfce
xfce4-power-manager &