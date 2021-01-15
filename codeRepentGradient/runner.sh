#! /bin/bash

while [ 1 ]
do
    baseMin=15
    base=$(( $baseMin * 60 ))
    var=$(( base / 4 ))
    # variance test
    limitT=$(( $base + $(( $RANDOM % $var )) )) 
    echo $limitT
    ./timer_up.sh $limitT;   
    echo one is done!
done
