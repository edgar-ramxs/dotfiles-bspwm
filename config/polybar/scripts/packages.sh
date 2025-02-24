#!/usr/bin/env bash

DISTRO=$(grep -i '^ID=' /etc/os-release | cut -d= -f2 | tr -d '""')
case "$DISTRO" in
    kali|linuxmint|parrot|debian|ubuntu)
        UPGRADABLE=$(apt list --upgradable 2>/dev/null | grep -v 'Listing' | wc -l)
        echo "$UPGRADABLE"
        ;;
    *)
        echo "0"
        ;;
esac
