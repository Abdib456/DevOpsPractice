#!/bin/zsh

#filename="hero.txt"
filename="../Arena/Warrior.txt"

if [ -f "$filename" ];
then
echo "Hero found!"
else
echo "Hero missing"
fi