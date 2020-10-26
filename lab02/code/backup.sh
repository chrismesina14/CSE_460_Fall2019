#!/bin/bash
# file: backup.sh

echo "Please enter a backup directory name: "
read DIR

if [ ! -d "./$DIR" ] 
then
    mkdir $DIR
    echo "A directory named $DIR has been created"
    
    for i in *.cpp 
    do
        cp $i $DIR/$i
        echo "$i has been backed up"
    done
else
    for i in *.cpp
    do
        if cmp -s "$i" "./$DIR/$i"
        then 
            echo "$i has no update"
        else
            cp $i $DIR/$i
            echo "$i has been updated"
        fi
    done
fi
