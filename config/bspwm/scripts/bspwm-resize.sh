#!/usr/bin/env dash

# Defines the step size depending on whether the window is floating or not.
if bspc query -N -n focused.floating > /dev/null; then
    step=20
else
    step=100
fi

# Initializes address variables
x=0
y=0

# Sets the direction and values of x and y according to the argument
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

# Moves the window in the specified direction or, if unsuccessful, in the opposite direction
bspc node -z "$dir" "$x" "$y" || bspc node -z "$falldir" "$x" "$y"
