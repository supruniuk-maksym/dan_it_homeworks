#!/bin/bash
#set -x 

# Создание директории для мониторинга
WATCH_DIR=~/Watch

mkdir -p "$WATCH_DIR"

# Start of files creation monitoring
inotifywait -m -e create "$WATCH_DIR" | while read path action file; do
    

    # Fix inotifywait bag. Cut extra information from var "File"
    filename=$(echo "$file" | awk '{print $NF}')

    # Ignor temporary files
    if [[ "$filename" == .* ]] || [[ "$filename" == *.swp ]] || [[ "$filename" == *.swx ]]; then
        continue
    fi

    file_path="$WATCH_DIR/$filename"
    echo "1) New file: $filename created in $WATCH_DIR"
    echo "2) Here is the content of the file: $file_path"
    cat "$file_path"
    mv "$file_path" "$file_path.back"
    echo "3) File: $file_path was renamed to $file_path.back"
done



