#!/usr/bin/env bash

source functions.sh

message -title "ZSH Installation"
sleep 0.5

message -subtitle "Installation of libraries and plugins..."
sudo apt install -y zsh zsh-syntax-highlighting zsh-autosuggestions >/dev/null 2>&1
sleep 0.5

message -subtitle "Setting ZSH as default..."
sudo chsh -s $(which zsh) $USER
sudo chsh -s $(which zsh) root
sleep 0.5

if [ ! -d /usr/share/zsh-sudo ]; then
    message -error "El directorio '/usr/share/zsh-sudo' no existe."
    message -subtitle "Installing ZSH plugins..."
    sudo mkdir -p /usr/share/zsh-sudo
    sudo chown $USER:$USER /usr/share/zsh-sudo/
    sudo wget -q -O /usr/share/zsh-sudo/zsh-sudo.zsh https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/plugins/sudo/sudo.plugin.zsh
    check_execution $? "Failed plugin download" "Plugin download successful"
fi

message -subtitle "Installing Powerlevel10k for user $USER..."
git clone --depth=1 https://github.com/romkatv/powerlevel10k.git ~/.powerlevel10k >/dev/null 2>&1
check_execution $? "Failed powerlevel10k download for $USER" "Completed download of powerlevel10k for the $USER"
sleep 0.5

message -subtitle "Installing Powerlevel10k for root..."
sudo git clone --depth=1 https://github.com/romkatv/powerlevel10k.git /root/.powerlevel10k >/dev/null 2>&1
check_execution $? "Failed powerlevel10k download for root" "Completed download of powerlevel10k for the root"
sleep 0.5
