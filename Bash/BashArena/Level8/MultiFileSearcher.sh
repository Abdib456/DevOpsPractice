#!/bin/bash

#grep -e "ERROR" application.log

#grep -l "ERROR" *.log

#Allows to be reuseable instead of hard-coded 
grep -l "$1" *.log
