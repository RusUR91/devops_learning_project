#!/bin/bash

DIR="${1%/}"
START=$(date +%s%N)

echo "Директория для анализа: $1"

total_folders=$(find "$DIR" -type d 2>/dev/null | wc -l)
echo "Всего папок = $total_folders"

echo "Топ 5 папок:"
du -h --max-depth=5 "$DIR" 2>/dev/null | sort -hr | head -5 | 
    awk '{print NR" - "$2", "$1}' 2>/dev/null || echo "  No data"

total_files=$(find "$DIR" -type f 2>/dev/null | wc -l)
echo "Всего файлов = $total_files"

echo "Кол-во файлов:"
echo "  .conf files = $(find "$DIR" -name '*.conf' -type f 2>/dev/null | wc -l)"
echo "  .txt files = $(find "$DIR" -name '*.txt' -type f 2>/dev/null | wc -l)"
echo "  Executable = $(find "$DIR" -executable -type f 2>/dev/null | wc -l)"
echo "  .log files = $(find "$DIR" -name '*.log' -type f 2>/dev/null | wc -l)"
echo "  Archives = $(find "$DIR" -type f \( -name "*.zip" -o -name "*.tar" -o -name "*.gz" -o -name "*.7z" \) 2>/dev/null | wc -l)"
echo "  Symlinks = $(find "$DIR" -type l 2>/dev/null | wc -l)"

echo "Топ 10 файлов:"
find "$DIR" -type f -exec du -b {} + 2>/dev/null | sort -nr | head -10 |
    while read size file; do
        [ "$size" -gt 1073741824 ] && echo "$(($size/1073741824))G $file" || \
        [ "$size" -gt 1048576 ] && echo "$(($size/1048576))M $file" || \
        [ "$size" -gt 1024 ] && echo "$(($size/1024))K $file" || \
        echo "${size}B $file"
    done | nl -w1 -s'. ' | awk '{print "  "$0}'

echo "Топ 10 исполняемых файлов:"
find "$DIR" -type f -executable -exec du -b {} + 2>/dev/null | sort -nr | head -10 |
    while read size file; do
        md5=$(md5sum "$file" 2>/dev/null | cut -d' ' -f1)
        [ "$size" -gt 1073741824 ] && echo "$(($size/1073741824))G $file $md5" || \
        [ "$size" -gt 1048576 ] && echo "$(($size/1048576))M $file $md5" || \
        [ "$size" -gt 1024 ] && echo "$(($size/1024))K $file $md5" || \
        echo "${size}B $file $md5"
    done | nl -w1 -s'. ' | awk '{print "  "$1" - "$3", "$2", "$4}'

END=$(date +%s%N)
echo "Время выполнения скрипта = $((($END-$START)/1000000)) ms"
