#!/usr/bin/env bash

# Terminate already running bar instances
killall -q polybar

## Wait until the processes have been shut down
while pgrep -u $UID -x polybar >/dev/null; do sleep 1; done

polybar logo -c ~/.config/polybar/config.ini &
polybar fecha -c ~/.config/polybar/config.ini &
polybar redes -c ~/.config/polybar/config.ini &
# polybar wifi -c ~/.config/polybar/config.ini &
polybar escritorios -c ~/.config/polybar/config.ini &
# polybar temperatura -c ~/.config/polybar/config.ini &
# polybar bluetooth -c ~/.config/polybar/config.ini &
# polybar bateria -c ~/.config/polybar/config.ini &
# polybar audio -c ~/.config/polybar/config.ini &
# polybar brillo -c ~/.config/polybar/config.ini &
