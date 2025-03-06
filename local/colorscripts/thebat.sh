#!/usr/bin/env bash

f=3 b=4
for j in f b; do
  for i in {0..7}; do
    printf -v $j$i %b "\e[${!j}${i}m"
  done
done
bld=$'\e[1m'
rst=$'\e[0m'
inv=$'\e[7m'

cat << EOF
 
   $f3       ██████████████████████████████████████       
   $f3     ██████████████████████████████████████████     
   $f3   ██████   ████████████████████████████   ██████   
   $f3 █████    ████████████  ████  ████████████    █████ 
   $f3 ███      ████████████        ████████████      ███ 
   $f3 ███                                            ███ 
   $f3 ███                                            ███ 
   $f3 ███      █████████  ████  ████  █████████      ███ 
   $f3 █████    ███████████████  ███████████████    █████ 
   $f3   ██████   ████████████████████████████   ██████   
   $f3     ██████████████████████████████████████████     
   $f3       ██████████████████████████████████████       
   $rst
EOF