#!/usr/bin/env bash

function get_icon() {
  local perc=$1
  local state=$2

  if [[ "$state" == "Charging" ]]; then
    if ((perc >= 90)); then
      echo "󰂅" # 90-100%
    elif ((perc >= 80)); then
      echo "󰂋" # 80-89%
    elif ((perc >= 70)); then
      echo "󰂊" # 70-79%
    elif ((perc >= 60)); then
      echo "󰢞" # 60-69%
    elif ((perc >= 50)); then
      echo "󰂉" # 50-59%
    elif ((perc >= 40)); then
      echo "󰢝" # 40-49%
    elif ((perc >= 30)); then
      echo "󰂈" # 30-39%
    elif ((perc >= 20)); then
      echo "󰂇" # 20-29%
    elif ((perc >= 10)); then
      echo "󰂆" # 10-19%
    else
      echo "󰢜" # 0-9%
    fi
  else
    if ((perc >= 90)); then
      echo "󰁹" # 90-100%
    elif ((perc >= 80)); then
      echo "󰂂" # 80-89%
    elif ((perc >= 70)); then
      echo "󰂁" # 70-79%
    elif ((perc >= 60)); then
      echo "󰂀" # 60-69%
    elif ((perc >= 50)); then
      echo "󰁿" # 50-59%
    elif ((perc >= 40)); then
      echo "󰁾" # 40-49%
    elif ((perc >= 30)); then
      echo "󰁽" # 30-39%
    elif ((perc >= 20)); then
      echo "󰁼" # 20-29%
    elif ((perc >= 10)); then
      echo "󰁻" # 10-19%
    else
      echo "󰁺" # 0-9%
    fi
  fi
}


acpi_output=$(acpi -b)
if [[ -z "$acpi_output" ]]; then
  echo "%{T2}󱟩 %{T-}%{T1}0%%{T-}"
fi

state=$(echo "$acpi_output" | awk -F': ' '{print $2}' | awk -F', ' '{print $1}')
percentage=$(echo "$acpi_output" | awk -F', ' '{print $2}' | tr -d '%')
icon=$(get_icon "$percentage" "$state")

echo "%{T2}$icon%{T-} %{T1}$percentage%%{T-}" 
