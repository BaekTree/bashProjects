#! /bin/bash

while [ 1 ]
do
    baseMin=20
    base=$(( $baseMin * 60 ))
    var=$(( base / 4 ))
    # variance test
    limitT=$(( $base + $(( $RANDOM % $var )) )) 
    echo $limitT
    ./timer.sh $limitT;   
    echo one is done!
done
