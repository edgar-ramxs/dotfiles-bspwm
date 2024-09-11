#!/usr/bin/env bash

source functions.sh

message -title "Pywal Installation"
sleep 0.5

sudo pip install pywal --break-system-packages >/dev/null 2>&1
check_execution $? "Failed Pywal Installation" "Complete Pywal installation"
sleep 0.5
