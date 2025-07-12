#!/usr/bin/env bash

CACHE_FILE="/tmp/polybar_speedtest.cache"

if [[ "$1" == "--update" ]]; then
    echo "Testing.." > "$CACHE_FILE"
    polybar-msg hook speedtest 1

    output=$(speedtest-cli --simple 2>/dev/null)
    if [ $? -ne 0 ]; then
        echo "Error" > "$CACHE_FILE"
    else
        ping=$(echo "$output" | grep "Ping" | awk '{print $2}')
        upload=$(echo "$output" | grep "Upload" | awk '{print $2}')
        download=$(echo "$output" | grep "Download" | awk '{print $2}')
        echo "${ping}ms ${download}Mbps ${upload}Mbps" > "$CACHE_FILE"
    fi
    
    polybar-msg hook speedtest 1
    exit 0
fi

if [[ -f "$CACHE_FILE" ]]; then
    cat "$CACHE_FILE"
else
    cat "0ms 0Mbps 0Mbps"
fi
