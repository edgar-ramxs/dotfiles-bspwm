#!/usr/bin/env bash

API_KEY=""

# Obtén la ubicación geográfica de tu IP
LOCATION=$(curl -s https://ipinfo.io/loc)

# Divídelo en latitud y longitud
LAT=$(echo $LOCATION | cut -d',' -f1)
LON=$(echo $LOCATION | cut -d',' -f2)

# Llama a la API de OpenWeather
response=$(curl -s "https://api.openweathermap.org/data/2.5/weather?lat=${LAT}&lon=${LON}&appid=${API_KEY}&units=metric")

# Extrae la temperatura de la respuesta JSON
temperature=$(echo $response | jq '.main.temp' | cut -d'.' -f1)

# Clasifica la temperatura
if (( $(echo "$temperature <= 10" | bc -l) )); then
    classification=""
elif (( $(echo "$temperature > 10 && $temperature <= 25" | bc -l) )); then
    classification=""
else
    classification=""
fi

# Muestra la temperatura y la clasificación
echo "${classification} ${temperature}°C"
