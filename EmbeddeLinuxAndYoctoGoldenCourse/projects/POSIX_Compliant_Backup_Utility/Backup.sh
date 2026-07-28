#!/usr/bin/env sh

#check the args 
if test "$#" -ne 2; then 
    echo "Error: Too few or incorrect number of arguments!"
    exit 1
fi


src=$1 
dist=$2

if test ! -f "$src"; then
    echo "Error: Source file does not exist!"
    exit 1
fi

test -d "$dist"      
if test "$?" -eq 0; then 
    cp "$src" "$dist"
    echo "File copied successfully." 
else 
    echo "Error: The destination directory does not exist!"
    exit 1
fi
