#!/bin/bash

mkdir Battlefield
cd Battlefield
touch Knight.txt
touch Sorcerer.txt
touch rouge.txt

#set -eux - error handling
filename="knight.txt"
if [ -f $filename ];
then
mkdir ../Archive
mv $filename ../Archive
fi

echo "This is the content of Battlfield"
ls ../Battlefield
echo "This is the content of Archive"
ls ../Archive