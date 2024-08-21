#!/bin/bash
#set -x  # Включить отладочный режим

# Создание директории для мониторинга
WATCH_DIR=~/Watch888

mkdir -p "$WATCH_DIR"

# Команда мониторинга файлов
inotifywait -m -e create "$WATCH_DIR" | while read path action file; do
    # Отладочная информация
    echo "Raw input: $path $action $file"

    # Извлекаем чистое название файла
    filename=$(echo "$file" | awk '{print $NF}')
    echo "filename is $filename"

    # Игнорируем временные файлы, создаваемые редакторами
    if [[ "$filename" == .* ]] || [[ "$filename" == *.swp ]] || [[ "$filename" == *.swx ]]; then
        continue
    fi

    file_path="$WATCH_DIR/$filename"
    echo "New file $filename created in $WATCH_DIR"
    echo "Here is the content of the file: $file_path"
    cat "$file_path"
    mv "$file_path" "$file_path.back"
    echo "$file_path was renamed to $file_path.back"
done




