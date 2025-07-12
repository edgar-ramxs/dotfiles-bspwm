#!/bin/sh

for output in $(xrandr | grep " connected" | cut -d" " -f1); do
    case "$output" in
        Virtual1)
            xrandr --output Virtual1 --mode 1920x1080 --rate 60.00 &
            ;;
        HDMI-1)
            xrandr --output HDMI-1 --mode 1920x1080 --rate 60.00 &
            ;;
        eDP-1)
            xrandr --output eDP-1 --mode 1366x768 --rate 60.00 &
            ;;
        *)  
            xrandr --output "$output" --auto &
            ;;
    esac
done
