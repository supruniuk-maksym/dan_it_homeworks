#!/bin/bash

#We check does the file exist.

filename=$1

if [ ! -f "$filename" ]; then
	echo "File did not find"
	exit 1
fi

#We load file into  the  while cicle.

line_count=0 

while IFS= read -r line
do 
	line_count=$(($line_count +1))
done < $filename

echo "The file $filename has $line_count lines."
