#!/bin/bash
#

#Check does the file exist.

filename=$1

if [ ! -f $filename ]; then
	echo "Error: file $filename  doesn't exist"
	exit 1
else 
	echo "Contents of the file $filename: "
	cat $filename 

fi

#

