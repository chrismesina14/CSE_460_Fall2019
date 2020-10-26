#!/bin/bash
#file cond.sh

echo -n "Enter a number: "
read VAR

if (( $VAR > 0 ))
then
        echo "$VAR is greater than 0."
    else
            echo "$VAR is equal or less than 0."
fi
echo

FILE=/etc/resolv1.conf
if [ -f "$FILE" ]
then
        echo "$FILE exists"
    else
            echo "$FILE does not exist"
fi
echo

read WORD
FILE=main.cpp
grep $WORD $FILE

if [ $? == 0 ]
then
        echo "$WORD is in $FILE"
    else
            echo "$WORD is not in $FILE"
fi
echo
