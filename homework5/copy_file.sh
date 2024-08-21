#!/bin/bash

SOURCE=$1
DESTINATION=$2

cp "$SOURCE" "$DESTINATION"

if [ $? -eq 0 ]; then
echo "Success"
fi

