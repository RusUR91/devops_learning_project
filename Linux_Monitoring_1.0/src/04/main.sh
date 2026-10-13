#!/bin/bash

if [ $# != 0 ]; then
    echo "Ошибка: параметры должны отсутствовать" >&2
    exit 1
fi

default_column1_background=6  # black
default_column1_font_color=1   # white
default_column2_background=2   # red
default_column2_font_color=4   # blue

config_file="./config.sh"
if [ -f "$config_file" ]; then
    source "$config_file"
fi

column1_background=${column1_background:-$default_column1_background}
column1_font_color=${column1_font_color:-$default_column1_font_color}
column2_background=${column2_background:-$default_column2_background}
column2_font_color=${column2_font_color:-$default_column2_font_color}

check_value() {
    local value=$1
    local name=$2
    if ! [[ $value =~ ^[1-6]$ ]]; then
        echo "Ошибка: $name - числа от 1 до 6." >&2
        exit 1
    fi
}

check_value "$column1_background" "column1_background"
check_value "$column1_font_color" "column1_font_color"
check_value "$column2_background" "column2_background"
check_value "$column2_font_color" "column2_font_color"

if [ "$column1_background" -eq "$column1_font_color" ]; then
    echo "Ошибка. Цвета не должны совпадать" >&2
    exit 1
fi

if [ "$column2_background" -eq "$column2_font_color" ]; then
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

print_colored_info "$column1_background" "$column1_font_color" "$column2_background" "$column2_font_color"

echo ""
echo "Column 1 background = $column1_background (${color_names[$column1_background]})"
echo "Column 1 font color = $column1_font_color (${color_names[$column1_font_color]})"
echo "Column 2 background = $column2_background (${color_names[$column2_backgrnd]})"
echo "Column 2 font color = $column2_font_color (${color_names[$column2_font_color]})"
