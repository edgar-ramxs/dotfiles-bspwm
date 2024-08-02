#!/usr/bin/env bash

#   █████╗ ██╗   ██╗████████╗ ██████╗ ███████╗████████╗ █████╗ ██████╗ ████████╗
#  ██╔══██╗██║   ██║╚══██╔══╝██╔═══██╗██╔════╝╚══██╔══╝██╔══██╗██╔══██╗╚══██╔══╝
#  ███████║██║   ██║   ██║   ██║   ██║███████╗   ██║   ███████║██████╔╝   ██║   
#  ██╔══██║██║   ██║   ██║   ██║   ██║╚════██║   ██║   ██╔══██║██╔══██╗   ██║   
#  ██║  ██║╚██████╔╝   ██║   ╚██████╔╝███████║   ██║   ██║  ██║██║  ██║   ██║   
#  ╚═╝  ╚═╝ ╚═════╝    ╚═╝    ╚═════╝ ╚══════╝   ╚═╝   ╚═╝  ╚═╝╚═╝  ╚═╝   ╚═╝   
#                                                                               

# Configurar la distribucion del teclado a Español Latinoamericano
setxkbmap -layout latam &

# Reajustar fondo de pantalla
sleep 0.5
nitrogen --restore &

# Ejecutar compositor de ventanas
picom &

# Ejecutar barras de tareas
sleep 0.5
$HOME/.config/polybar/launch.sh &

# Reajustar paleta de colores de Pywal
sleep 0.5
$HOME/.config/bspwm/scripts/background.sh &

# Habilitar autenticador para rofi
/usr/lib/policykit-1-gnome/polkit-gnome-authentication-agent-1 &

# Bloquear cursor en zonas del polybar 
xsetroot -cursor_name left_ptr &

# Habilitar gestor de bateria de xfce
xfce4-power-manager &

