#!/usr/bin/env dash

if bspc query -N -n focused.floating > /dev/null; then
    step=20
else
    step=100
fi

x=0
y=0

case "$1" in
    west)
        dir=right
        falldir=left
        x="-$step"
        ;;
    east)
        dir=right
        falldir=left
        x="$step"
        ;;
    north)
        dir=top
        falldir=bottom
        y="-$step"
        ;;
    south)
        dir=top
        falldir=bottom
        y="$step"
        ;;
esac

bspc node -z "$dir" "$x" "$y" || bspc node -z "$falldir" "$x" "$y"
