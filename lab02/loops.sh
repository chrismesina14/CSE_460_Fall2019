#!/bin/bash
#file: loops.sh
FILE='./main.cpp'

#A while loop with user input
     echo "Enter a letter or x to quit "
     read var1

     while [ $var1 != "x" ]
     do
            echo "Enter a letter or x to quit "
               read var1
           done

           #A for loop echoing the contents of file
           if [ ! -f $FILE ]
           then
                   echo "$FILE is not found."
                       exit 1
                   else
                           for var2 in `cat $FILE`
                                   do
                                               echo $var2
                                                   done
           fi
