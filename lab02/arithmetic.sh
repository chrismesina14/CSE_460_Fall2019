#!/bin/bash
# file: arithmetic.sh

num1=3
num2=10

echo $num1
echo $num2

res=$((num1+num2))
echo "num1 + num2 = $res"

res2=$((num1*5))
echo "num1 * 5 = $res2"

res2=$((num1%5))
echo "num1 % 5  = $res2"

#Decrement or increment
((res2++))                     #increment operator
# ((res2--))                     #decrement operator

echo $res2

#Logical assignment
mybool=$((!($res2==$res)))

# mybool=$(($res2 > $res))
echo $mybool
