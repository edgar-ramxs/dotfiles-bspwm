#!/usr/bin/env bash

# Terminate already running bar instances
killall -q polybar

# Wait until the processes have been shut down
while pgrep -u $UID -x polybar >/dev/null; do sleep 1; done
polybar barra-escritorios -c ~/.config/polybar/config.ini &
polybar barra-metricas -c ~/.config/polybar/config.ini &
polybar barra-aplicaciones -c ~/.config/polybar/config.ini &
