#!/usr/bin/env bash

initializeANSI()
{
 esc=""

  blackf="${esc}[30m";   redf="${esc}[31m";    greenf="${esc}[32m"
  yellowf="${esc}[33m"   bluef="${esc}[34m";   purplef="${esc}[35m"
  cyanf="${esc}[36m";    whitef="${esc}[37m"
  
  blackb="${esc}[40m";   redb="${esc}[41m";    greenb="${esc}[42m"
  yellowb="${esc}[43m"   blueb="${esc}[44m";   purpleb="${esc}[45m"
  cyanb="${esc}[46m";    whiteb="${esc}[47m"

  boldon="${esc}[1m";    boldoff="${esc}[22m"
  italicson="${esc}[3m"; italicsoff="${esc}[23m"
  ulon="${esc}[4m";      uloff="${esc}[24m"
  invon="${esc}[7m";     invoff="${esc}[27m"

  reset="${esc}[0m"
}

clear 

initializeANSI

cat << EOF

 ${reset}${redf}▄█▄█▄ ${reset}${boldon}${redf}█ ${reset}${greenf}▄█▄█▄ ${reset}${boldon}${greenf}█ ${reset}${yellowf}▄█▄█▄ ${reset}${boldon}${yellowf}█ ${reset}${bluef}▄█▄█▄ ${reset}${boldon}${bluef}█ ${reset}${purplef}▄█▄█▄ ${reset}${boldon}${purplef}█ ${reset}${cyanf}▄█▄█▄ ${reset}${boldon}${cyanf}█${reset} 
 ${reset}${redf}▄█▄█▄ ${reset}${boldon}${redf}▀ ${reset}${greenf}▄█▄█▄ ${reset}${boldon}${greenf}▀ ${reset}${yellowf}▄█▄█▄ ${reset}${boldon}${yellowf}▀ ${reset}${bluef}▄█▄█▄ ${reset}${boldon}${bluef}▀ ${reset}${purplef}▄█▄█▄ ${reset}${boldon}${purplef}▀ ${reset}${cyanf}▄█▄█▄ ${reset}${boldon}${cyanf}▀${reset}
 ${reset}${redf} ▀ ▀  ${reset}${boldon}${redf}▀ ${reset}${greenf} ▀ ▀  ${reset}${boldon}${greenf}▀ ${reset}${yellowf} ▀ ▀  ${reset}${boldon}${yellowf}▀ ${reset}${bluef} ▀ ▀  ${reset}${boldon}${bluef}▀ ${reset}${purplef} ▀ ▀  ${reset}${boldon}${purplef}▀ ${reset}${cyanf} ▀ ▀  ${reset}${boldon}${cyanf}▀${reset}
EOF