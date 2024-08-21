#!/bin/bash
#

#Enter a file name
	echo "Write a filename: "
	read filename

#Check file in the directory
	if [ -e  "$filename" ]; then
		echo "$filename exists"
	else
		echo "There is no the  $filename file"
	fi
