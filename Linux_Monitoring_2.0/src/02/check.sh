#!/bin/bash

function check_arg() {

folders_names=$1
files_names=$2
file_size=$3

IFS='.' read -a array_fi <<< $files_names

if [ "$#" -ne "3" ]; then 
echo -e "\e[91mError. The script must be run with 3 parameters.\e[0m"
exit 1
fi

if [ ${#folders_names} -gt "7" ]; then
echo -e "\e[91mError. Line more than 7 characters: "${#folders_names}"\e[0m"
exit 1
fi

if [[ "$folders_names" =~ [^a-zA-Z]+ ]]; then
echo -e "\e[91mError. Parameter contains invalid characters: "$folders_names"\e[0m"
exit 1
fi

if [[ ! "$files_names" =~ ^[a-zA-Z]{1,7}\.[a-zA-Z]{1,3}$ ]] ; then
echo -e "\e[91mError. Invalid parameters: "$files_names"\e[0m"
exit 1
fi

if [[ ! "$file_size" =~ ^^[1-9][0-9]?Mb$|^100Mb$ ]] ; then
echo -e "\e[91mError. Invalid parameters: "$file_size"\e[0m"
exit 1
else
file_size=${file_size%?}
fi
}
