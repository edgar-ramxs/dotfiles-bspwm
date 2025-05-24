#!/usr/bin/env bash

DISTRO=$(grep -i '^ID=' /etc/os-release | cut -d= -f2 | tr -d '""')
case "$DISTRO" in
    kali)           echo " ";;
    arch)           echo " ";;
    fedora)         echo " ";;
    parrot)         echo " ";;
    debian)         echo " ";;
    ubuntu)         echo " ";;
    linuxmint)      echo " ";;
    *)              echo " ";;
esac
exit 0
