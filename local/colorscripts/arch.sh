#!/usr/bin/env bash

initializeANSI()
{
  esc=""

  redf="${esc}[31m";     greenf="${esc}[32m"
  yellowf="${esc}[33m"   bluef="${esc}[34m";   
  cyanf="${esc}[36m";    purplef="${esc}[35m"   
                      
  boldon="${esc}[1m";    
  reset="${esc}[0m"
}

initializeANSI

cat << EOF 
  
${boldon}${redf}        ■      ${boldon}${greenf}        ■      ${boldon}${yellowf}        ■     ${boldon}${bluef}         ■       ${boldon}${purplef}       ■      ${boldon}${cyanf}        ■   ${reset}
${boldon}${redf}       ■■■     ${boldon}${greenf}       ■■■     ${boldon}${yellowf}       ■■■    ${boldon}${bluef}        ■■■      ${boldon}${purplef}      ■■■     ${boldon}${cyanf}       ■■■  ${reset}
${boldon}${redf}      ■■■■■    ${boldon}${greenf}      ■■■■■    ${boldon}${yellowf}      ■■■■■   ${boldon}${bluef}       ■■■■■     ${boldon}${purplef}     ■■■■■    ${boldon}${cyanf}      ■■■■■ ${reset}
${redf}     ■(   )■   ${greenf}     ■(   )■   ${yellowf}     ■(   )■   ${bluef}     ■(   )■    ${purplef}    ■(   )■   ${cyanf}     ■(   )■   ${reset}
${redf}    ■■■■ ■■■■  ${greenf}    ■■■■ ■■■■  ${yellowf}    ■■■■ ■■■■  ${bluef}    ■■■■ ■■■■   ${purplef}   ■■■■ ■■■■  ${cyanf}    ■■■■ ■■■■  ${reset}
${redf}   ■■       ■■ ${greenf}   ■■       ■■ ${yellowf}   ■■       ■■ ${bluef}   ■■       ■■  ${purplef}  ■■       ■■ ${cyanf}   ■■       ■■ ${reset}
 
EOF