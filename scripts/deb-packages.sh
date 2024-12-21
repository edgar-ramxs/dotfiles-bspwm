https://code.visualstudio.com/sha/download?build=stable&os=linux-deb-x64

xrandr | grep "connected primary" | awk 'print $4' | tr -d '\n' | cut -d '+' -f1

for i in {0..15}; do printf "\e[48;5;${i}m => \e[0m ${i}\n"