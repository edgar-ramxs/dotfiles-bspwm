#!/usr/bin/env bash

active_window=$(xdotool getactivewindow 2>/dev/null)
[ -z "$active_window" ] && exit

wn_class=$(xprop -id "$active_window" WM_CLASS 2>/dev/null)
if [[ "$wn_class" =~ \"([^\"]+)\,\ \"([^\"]+)\" ]], then
    app="${BASH_REMATCH[2]}"
else
    exit 0
fi

case "$app" in
    firefox|Firefox|firefox-esr)        echo "Firefox";;
    Alacritty)                          echo "Alacritty";;
    code|Code)                          echo "VsCode";;
    Thunar)                             echo "Thunar";;
    mpv)                                echo "mpv";;
    TelegramDesktop)                    echo "Telegram";;
    *)                                  echo "$app";;
esac
