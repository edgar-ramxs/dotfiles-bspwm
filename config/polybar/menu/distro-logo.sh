#!/usr/bin/env bash

DISTRO=$(grep -i '^ID=' /etc/os-release | cut -d= -f2 | tr -d '""')
case "$DISTRO" in
    kali)
        echo "%{T3}   %{T-}"
        ;;
    linuxmint)
        echo "%{T3} %{T-}"
        ;;
    arch)
        echo "%{T3}  %{T-}"
        ;;
    fedora)
        echo "%{T3}  %{T-}"
        ;;
    parrot)
        echo "%{T3}  %{T-}"
        ;;
    debian)
        echo "%{T3}  %{T-}"
        ;;
    ubuntu)
        echo "%{T3}  %{T-}"
        ;;
    *)
        echo "%{T3}  %{T-}"
        ;;
esac

exit 0