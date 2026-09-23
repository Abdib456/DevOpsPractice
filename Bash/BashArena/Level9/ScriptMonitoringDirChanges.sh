#!/bin/bash

pathDirLog="../Level9Logs/Logs/DirChange.log"
pathOldtxt="../Level9Logs/Logs/Old.txt"
pathNewtxt="../Level9Logs/Logs/New.txt"

# Remove the "total" line from ls -l
OldContents=$(ls -l | tail -n +2)

while true
do
    NewContents=$(ls -l | tail -n +2)

    if [ "$OldContents" = "$NewContents" ]
    then
        : # Do nothing if there is no change
    else
        timestamp=$(date)
        echo "$timestamp" >> "$pathDirLog"

        # Save old and new directory states
        echo "$OldContents" > "$pathOldtxt"
        echo "$NewContents" > "$pathNewtxt"

        # Created
        diff "$pathOldtxt" "$pathNewtxt" |
        grep -EA 1 "[0-9]+a[0-9]+" |
        grep -Ev "[0-9]+a[0-9]+" |
        awk '{print $NF, "has been Created"}' >> "$pathDirLog"

        # Deleted
        diff "$pathOldtxt" "$pathNewtxt" |
        grep -EA 1 "[0-9]+d[0-9]+" |
        grep -Ev "[0-9]+d[0-9]+" |
        awk '{print $NF, "has been Deleted"}' >> "$pathDirLog"

        # Modified
        diff "$pathOldtxt" "$pathNewtxt" |
        grep -EA 1 "[0-9]+c[0-9]+" |
        grep -Ev "[0-9]+c[0-9]+" |
        awk '{print $NF, "has been Modified"}' >> "$pathDirLog"

        # New state becomes the old state for the next check
        OldContents="$NewContents"
    fi

    sleep 5
done