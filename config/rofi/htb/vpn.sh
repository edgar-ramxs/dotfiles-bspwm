#!/usr/bin/env bash

IFACE=$(ifconfig | grep tun0 | awk '{print $1}' | tr -d ':')

if [ "$IFACE" = "tun0" ]; then
	echo "󰆧 $(ifconfig tun0 | grep "inet " | awk '{print $2}')"
else
	echo "󱐝 Disconnected"
fi