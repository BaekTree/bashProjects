#! /bin/bash




while [ 1 ]
do
    baseMin=60
    base=$(( $baseMin * 60 ))
    var=$(( base / 4 ))
    # variance test
    limitT=$(( $base + $(( $RANDOM % $var )) )) 
    #echo $limitT
    curFile=$0
    if [[ $curFile = *"_up"* ]]
    then
        echo "This is in dev!"
        ./timer_up.sh $limitT;
    else
        ./timer.sh $limitT;
    fi
    echo one is done!
done