#!/bin/bash

if [ $# != 0 ]; then
echo -e "\e[91mError. The script must be run with 0 parameters.\e[0m"
exit 1
fi

rm -rf index.html
touch index.html
goaccess ../04/*.log --log-format=COMBINED > index.html