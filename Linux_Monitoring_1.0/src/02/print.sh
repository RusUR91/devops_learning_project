#!/bin/bash

function print_system_info {
    echo "HOSTNAME = $(hostname)"
    echo "TIMEZONE = $(timedatectl show --property=Timezone --value) UTC $(date +%z)"
    echo "USER = $(whoami)"
    echo "OS = $(lsb_release -d | cut -f2)"
    echo "DATE = $(date "+%d %b %Y %T")"
    echo "UPTIME = $(uptime -p)"
    echo "UPTIME_SEC = $(awk '{print $1}' /proc/uptime)"
    echo "IP = $(ip route get 8.8.8.8 | awk '{print $7}')"
    echo "MASK = $(ip -o -f inet addr show | awk '/scope global/ {print $4}' | cut -d/ -f2 | head -1)"
    echo "GATEWAY = $(ip route | grep default | awk '{print $3}')"
    
    ram_total=$(free -b | grep Mem | awk '{print $2}')
    ram_used=$(free -b | grep Mem | awk '{print $3}')
    ram_free=$(free -b | grep Mem | awk '{print $4}')
    
    echo "RAM_TOTAL = $(echo "scale=3; $ram_total/1073741824" | bc | awk '{printf "%.3f", $0}') GB"
    echo "RAM_USED = $(echo "scale=3; $ram_used/1073741824" | bc | awk '{printf "%.3f", $0}') GB"
    echo "RAM_FREE = $(echo "scale=3; $ram_free/1073741824" | bc | awk '{printf "%.3f", $0}') GB"
    
    space_root=$(df / | awk 'NR==2 {print $2}')
    space_root_used=$(df / | awk 'NR==2 {print $3}')
    space_root_free=$(df / | awk 'NR==2 {print $4}')
    
    echo "SPACE_ROOT = $(echo "scale=2; $space_root/1024" | bc | awk '{printf "%.2f", $0}') MB"
    echo "SPACE_ROOT_USED = $(echo "scale=2; $space_root_used/1024" | bc | awk '{printf "%.2f", $0}') MB"
    echo "SPACE_ROOT_FREE = $(echo "scale=2; $space_root_free/1024" | bc | awk '{printf "%.2f", $0}') MB"
}
