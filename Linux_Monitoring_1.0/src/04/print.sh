#!/bin/bash

function print_colored_info {
    local color_name_1="${color_nums[$1]}"
    local color_name_2="${color_nums[$2]}"
    local color_name_3="${color_nums[$3]}"
    local color_name_4="${color_nums[$4]}"
    
    local colors_1="${colors_background[$color_name_1]}"
    local colors_2="${colors_font[$color_name_2]}"
    local colors_3="${colors_background[$color_name_3]}"
    local colors_4="${colors_font[$color_name_4]}"
    
    local vlnc="\033[${colors_1};${colors_2};1m"  
    local vlc="\033[${colors_3};${colors_4};1m"    
    local reset="\033[0m"
    
    local HOSTNAME=$(hostname)
    local TIMEZONE="$(timedatectl show --property=Timezone --value) UTC $(date +%z)"
    local USER=$(whoami)
    local OS=$(lsb_release -d | cut -f2)
    local DATE=$(date "+%d %b %Y %T")
    local UPTIME=$(uptime -p)
    local UPTIME_SEC=$(awk '{print $1}' /proc/uptime)
    local IP=$(ip route get 8.8.8.8 | awk '{print $7}' 2>/dev/null)
    
    local MASK=$(ip -o -f inet addr show | awk '/scope global/ {print $4}' | cut -d/ -f2 | head -1)
    if [ -z "$MASK" ]; then
        MASK=$(ifconfig | grep -A 1 "eth0" | tail -1 | awk '{print $4}' 2>/dev/null || echo "N/A")
    fi
    
    local GATEWAY=$(ip route | grep default | awk '{print $3}' 2>/dev/null || echo "N/A")
    
    local ram_total=$(free -b | grep Mem | awk '{print $2}')
    local ram_used=$(free -b | grep Mem | awk '{print $3}')
    local ram_free=$(free -b | grep Mem | awk '{print $4}')
    
    local RAM_TOTAL="$(echo "scale=3; $ram_total/1073741824" | bc 2>/dev/null | awk '{printf "%.3f", $0}') GB"
    local RAM_USED="$(echo "scale=3; $ram_used/1073741824" | bc 2>/dev/null | awk '{printf "%.3f", $0}') GB"
    local RAM_FREE="$(echo "scale=3; $ram_free/1073741824" | bc 2>/dev/null | awk '{printf "%.3f", $0}') GB"
    
    local space_root=$(df / | awk 'NR==2 {print $2}')
    local space_root_used=$(df / | awk 'NR==2 {print $3}')
    local space_root_free=$(df / | awk 'NR==2 {print $4}')
    
    local SPACE_ROOT="$(echo "scale=2; $space_root/1024" | bc 2>/dev/null | awk '{printf "%.2f", $0}') MB"
    local SPACE_ROOT_USED="$(echo "scale=2; $space_root_used/1024" | bc 2>/dev/null | awk '{printf "%.2f", $0}') MB"
    local SPACE_ROOT_FREE="$(echo "scale=2; $space_root_free/1024" | bc 2>/dev/null | awk '{printf "%.2f", $0}') MB"
    
    echo ""
    echo -e "${vlnc}HOSTNAME = ${vlc}$HOSTNAME${reset}"
    echo -e "${vlnc}TIMEZONE = ${vlc}$TIMEZONE${reset}"
    echo -e "${vlnc}USER = ${vlc}$USER${reset}"
    echo -e "${vlnc}OS = ${vlc}$OS${reset}"
    echo -e "${vlnc}DATE = ${vlc}$DATE${reset}"
    echo -e "${vlnc}UPTIME = ${vlc}$UPTIME${reset}"
    echo -e "${vlnc}UPTIME_SEC = ${vlc}$UPTIME_SEC${reset}"
    echo -e "${vlnc}IP = ${vlc}$IP${reset}"
    echo -e "${vlnc}MASK = ${vlc}$MASK${reset}"
    echo -e "${vlnc}GATEWAY = ${vlc}$GATEWAY${reset}"
    echo -e "${vlnc}RAM_TOTAL = ${vlc}$RAM_TOTAL${reset}"
    echo -e "${vlnc}RAM_USED = ${vlc}$RAM_USED${reset}"
    echo -e "${vlnc}RAM_FREE = ${vlc}$RAM_FREE${reset}"
    echo -e "${vlnc}SPACE_ROOT = ${vlc}$SPACE_ROOT${reset}"
    echo -e "${vlnc}SPACE_ROOT_USED = ${vlc}$SPACE_ROOT_USED${reset}"
    echo -e "${vlnc}SPACE_ROOT_FREE = ${vlc}$SPACE_ROOT_FREE${reset}"
    echo ""
}
