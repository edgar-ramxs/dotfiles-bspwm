#!/usr/bin/env bash

echo "󰈀 $(ifconfig wlan0 | grep "inet " | awk '{print $2}')"