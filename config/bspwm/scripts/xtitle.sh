#!/usr/bin/env bash

bspc subcribe node_focus | while -r _; do
    polybar-msg hook title 1
done
