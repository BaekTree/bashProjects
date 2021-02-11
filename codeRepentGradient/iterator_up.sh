#! /bin/bash





baseSecArg=$1
if [ -z $baseSecArg ]
then
	baseSec=4500
elif [[ ! $baseSecArg =~ ^[0-9]*$ ]]; then 
    echo -e "usage : iterator_up.sh <minutes>\n\tminutes here is the base minutes. \n\tThe shell adds random minutes 1/4 of the base minutes"
    exit 0
else
    baseSec=$baseSecArg
fi

while [ 1 ]
do
    echo -e "$(date +%a) $(date +%b) $(date +%d) $(date +"%H:%M") $(date +%Y)" 

    var=$(( baseSec / 4 ))
    if [[ $var == 0 ]]
    then
        var=1
    fi

    # variance test
    limitT=$(( $baseSec + $(( $RANDOM % $var )) )) 

    echo "wait ${limitT} seconds"

    mins=$(( $limitT / 60 ))

    hours=$(( $mins / 60 ))

    mins=$(( $mins - $hours * 60 ))
    sec=$(( $limitT - $hours * 3600 - $mins * 60 ))

    echo $hours:$mins:$sec left
    (osascript -e "display notification \"$hours:$mins:$sec left\" with title \"Code Repent Gradient\" subtitle \"glob arg max U s.t. U(G)\" sound name \"Frog\"")

    if [ $limitT -gt 3600 ]
    then
        fewHours=$(( $limitT / 3600 ))
        leftOver=$(( $limitT % 3600 ))
        sleep $leftOver
        echo $fewHours hours left.

        while [ $fewHours -gt 1 ]
        do
            sleep 3600
            $(( fewHours-- ))
            echo $fewHours hours left.
        done

        limitT=$(( $fewHours * 3600 ))
    fi

    #MINUTES
    arr=(50 40 30 20 10 5 4 3 2 1)

    for (( i=0; i<${#arr[@]}; i++ ))
    do
        if [ $limitT -gt $(( ${arr[$i]} * 60 )) ]
        then
            leftOver=$(( $limitT - $(( ${arr[$i]} * 60 )) ))
            echo leftOver : $leftOver limitT : $limitT
            sleep $leftOver
            echo ${arr[$i]} mins left.
            (osascript -e "display notification \"${arr[$i]} mins left\" with title \"Code Repent Gradient\" subtitle \"glob arg max U s.t. U(G)\" sound name \"Frog\"")

            limitT=$(( $limitT - $leftOver ))
        fi
    done  



    #SECONDS
    for (( i=0; i<${#arr[@]}; i++ ))
    do
        if [ $limitT -gt ${arr[$i]} ]
        then
            leftOver=$(( $limitT - ${arr[$i]} ))
            sleep $leftOver
            echo ${arr[$i]} secs left.
            (osascript -e "display notification \"${arr[$i]} secs left\" with title \"Code Repent Gradient\" subtitle \"glob arg max U s.t. U(G)\" sound name \"Frog\"")
            limitT=$(( $limitT - $leftOver ))
        fi
    done   
    # ./main.sh -l -f test_short.txt;   
    ./main.sh -f rules_up_only_kor.txt;   

    echo one is done!
done
