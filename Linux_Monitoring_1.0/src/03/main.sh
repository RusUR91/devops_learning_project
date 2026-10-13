#!/bin/bash

if [ $# -lt 4 ]; then
    echo "Ошибка. Параметров < 4" >&2
    exit 1
elif [ $# -gt 4 ]; then
    echo "Ошибка. Параметров > 4" >&2
    exit 1
fi

if [[ $1 != [1-6] || $2 != [1-6] || $3 != [1-6] || $4 != [1-6] ]]; then
    echo "Ошибка. Параметры - числа от 1 до 6." >&2
    exit 1
fi

if [[ $1 -eq $2 ]]; then
    echo "Ошибка. Цвета не должны совпадать" >&2
    exit 1
fi

if [[ $3 -eq $4 ]]; then
    echo "Ошибка. Цвета не должны совпадать" >&2
    exit 1
fi

if [ -f ./color.sh ]; then
    . ./color.sh
else
    echo "Ошибка. Файл не найден." >&2
    exit 1
fi

if [ -f ./print.sh ]; then
    . ./print.sh
else
    echo "Ошибка. Файл не найден." >&2
    exit 1
fi

print_colored_info $1 $2 $3 $4
