#!/usr/bin/env bash

LOCATION=$(curl -s https://ipinfo.io/loc)

LAT=$(echo $LOCATION | cut -d',' -f1)
LON=$(echo $LOCATION | cut -d',' -f2)

response=$(curl -s "https://api.openweathermap.org/data/2.5/weather?lat=${LAT}&lon=${LON}&appid=${WEATHER_KEY}&units=metric")

temperature=$(echo $response | jq '.main.temp' | cut -d'.' -f1)

if (( $(echo "$temperature <= 10" | bc -l) )); then
    classification=""
elif (( $(echo "$temperature > 10 && $temperature <= 25" | bc -l) )); then
    classification=""
else
    classification=""
fi

echo "${classification} ${temperature}°C"
