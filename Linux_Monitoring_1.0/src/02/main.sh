#!/bin/bash

if [ $# != 0 ]; then
    echo "Ошибка: отсутствуют параметры" >&2
    exit 1
fi

. ./print.sh

print_system_info

read -p "Сохранить данные в файл? (Y/N) " answer

if [[ $answer = "y" || $answer = "Y" ]]; then
    filename=$(date "+%d_%m_%y_%H_%M_%S").status
    print_system_info > "$filename"
    echo "Данные сохранены в $filename"
else
    exit 0
fi
