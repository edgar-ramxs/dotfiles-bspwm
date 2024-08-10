#!/usr/bin/env bash

DIR=$(pwd)

# BIN
cp -r $HOME/.local/bin $DIR

# CONFIG
cp -r $HOME/.config/betterlockscreen $DIR/config
cp -r $HOME/.config/bspwm $DIR/config
cp -r $HOME/.config/btop $DIR/config
cp -r $HOME/.config/cava $DIR/config
cp -r $HOME/.config/fastfetch $DIR/config
cp -r $HOME/.config/kitty $DIR/config
cp -r $HOME/.config/neofetch $DIR/config
cp -r $HOME/.config/nitrogen $DIR/config
cp -r $HOME/.config/picom $DIR/config
cp -r $HOME/.config/polybar $DIR/config
cp -r $HOME/.config/rofi $DIR/config
cp -r $HOME/.config/sxhkd $DIR/config

# HOME
cp $HOME/.zshrc $DIR/home/
cp $HOME/.bashrc $DIR/home/
cp $HOME/.profile $DIR/home/
cp $HOME/.p10k.zsh $DIR/home/
cp $HOME/.bash_logout $DIR/home/
cp $HOME/.aliases $DIR/home/
cp $HOME/.functions $DIR/home/
cp $HOME/.variables $DIR/home/

