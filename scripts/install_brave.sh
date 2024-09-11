#!/usr/bin/env bash

source functions.sh

sudo curl -fsSLo /usr/share/keyrings/brave-browser-archive-keyring.gpg https://brave-browser-apt-release.s3.brave.com/brave-browser-archive-keyring.gpg
echo "deb [signed-by=/usr/share/keyrings/brave-browser-archive-keyring.gpg] https://brave-browser-apt-release.s3.brave.com/ stable main" | sudo tee /etc/apt/sources.list.d/brave-browser-release.list

sudo apt update -y >/dev/null 2>&1
check_execution $? "Failed to updating packages" "Update packages"
sleep 0.5

sudo apt install -y brave-browser >/dev/null 2>&1
check_execution $? "Failed to updating packages" "Update packages"
sleep 0.5
