#!/bin/bash

if [ $# -ne 1 ] || [[ "$1" != */ ]] || [ ! -d "$1" ]; then
    echo "Ошибка: неверный параметр. $0 /path/to/dir/" >&2
    exit 1
fi

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

if [ ! -f "$SCRIPT_DIR/print.sh" ]; then
    echo "Ошибка. Файл не найден" >&2
    exit 1
fi

[ -x "$SCRIPT_DIR/print.sh" ] || chmod +x "$SCRIPT_DIR/print.sh"
exec "$SCRIPT_DIR/print.sh" "$1"