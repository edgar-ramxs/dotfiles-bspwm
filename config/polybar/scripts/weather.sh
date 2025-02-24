#!/usr/bin/env bash

if [ -z "$WEATHER_KEY" ]; then
	echo "%{T2}󱞐 %{T-}%{T1}API%{T-}"
	exit 1
fi

LOCATION=$(curl -s https://ipinfo.io/loc)

LAT=$(echo $LOCATION | cut -d',' -f1)
LON=$(echo $LOCATION | cut -d',' -f2)

response=$(curl -s "https://api.openweathermap.org/data/2.5/weather?lat=${LAT}&lon=${LON}&appid=${WEATHER_KEY}&units=metric")

temperature=$(echo $response | jq '.main.temp' | cut -d'.' -f1)
if [ $? -ne 0 ] || [ -z "$temperature" ]; then
	echo "%{T2}󱞐 %{T-}%{T1}JSON%{T-}"
	exit 1
fi

if [ "$temperature" -le 10 ]; then
	classification=""
elif [ "$temperature" -le 25 ]; then
	classification=""
else
	classification=""
fi

echo "%{T2}${classification}%{T-} %{T1}${temperature}°C%{T-}"
