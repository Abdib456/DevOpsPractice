#!/bin/bash

filename="$1"

if [ -f $filename ];
then
echo "$(cat $filename | wc -l)"
else
echo "No file provided"
fi