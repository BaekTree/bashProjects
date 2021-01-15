
updateVerses(){
    curDir=$(pwd)
    echo move to bible dir
    cd '/Users/baek/OneDrive/사진/삼성 갤러리/Pictures/Bible'
    echo pwd: $(pwd)

    v=$(ls)
    vArr=($v)

    # echo ${vArr[17]}
    numV=${#vArr[@]}

    echo back to cur dir : $curDir
    cd ${curDir}
}

genVerseIDx(){
    idxV=$(( $RANDOM % ${#vArr[@]} ))
}

viewVerse(){
    genVerseIDx
    echo "opening ${vArr[${idxV}]}"
    open -a Preview "/Users/baek/OneDrive/사진/삼성 갤러리/Pictures/Bible/${vArr[${idxV}]}"
    # $(sleep 10 || echo 10 passed!) &
    sleep 0.5
    $(osascript -e "tell application \"Preview\"
	set bounds of front window to {0, 0, 600, 900}
    end tell")

}

hideAll(){
    osascript -e "tell application \"Finder\"
    set visible of every process whose visible is true and name is not \"Finder\" to false
    close every window
    end tell"
}

closeVerse(){
    pids=$(pgrep Preview)   
    if [ -z $pids ]
    then
        echo no pids
    else
        echo preview pids : ${pids}
        echo killing preview $pids
        kill -9 ${pids}
        sleep 0.5
    fi
}


apple_text(){
    res=$(osascript -e "display dialog \"$1\" with title \"Code Repent Gradient\" buttons {\"Yes\", \"No\"} default answer \"\" default button \"No\"")
    closeVerse;
    viewVerse &
    parseBtnAns $res
    parseTxt $res

}


apple_dialog(){
    closeVerse
    viewVerse &
    res=$(osascript -e "display dialog \"$1\" with title \"Code Repent Gradient\" buttons {\"Yes\", \"No\"} default button \"No\"")
    parseBtnAns $res
}


# problematic!
parseBtnAns(){
    priorIFS=$IFS
    IFS=$": "
    local arg=($1)

    # for (( i=0; i<${#arg[@]}; i++ ))
    local i
    for i in ${arg[@]}
    do
        if [ ${i} = "Yes" -o ${i} = "No" ]
        # echo 
        then
            ans=${i}
            echo button answer is $ans
        fi        
    done
    IFS=$priorIFS
}

parseTxt(){
    echo parseTxt
    echo $1
    priorIFS=$IFS
    IFS=$",:"
    local arg=($1)

    local i
    for (( i=0; i<${#arg[@]}; i++ ))
    do
        echo ${arg[i]}
        if [ ${arg[i]} == " text returned" ]
        then
            msg=${arg[(( $i+1 ))]}
            echo txt is $msg
        fi
        
    done
    IFS=$priorIFS
}

#limit alert update
alertUpdate(){
    alrt="YOU ENTERED <"${1}">\nPLEASE ENTER MORE THAN "${2}" CHARS.\n"
}

record(){
    echo -e $1 >> preq.txt
}

<< "READ"

테스트케이스
rule : 을 발견한다 ruleArr에 저장할 것이다.
엔터가 있어도 계쏙 rule에 저장

cont나 ans을 만나면 그때 contArr, ansArr에 넣는다.
빈줄을 만나면 다음 rule으로 넘어간다.

현재 저장할 arr을 명시해둔다. 근데 그게 되나? bash에서?

curArr=$ruleArr
curAA+=

READ



declare -a ruleArr
declare -a contArr
declare -a ansArr
declare -a limitArr

getRules(){
    file='./rules.txt'
    idx=1
    while read line;
    do
        # echo $line
        #check if this line is in rule, cont, or ans
        # if [[ $line == ""]]
        # then
        #     line=" "
        # fi
        if [[ $line == *"rule"* ]]
        then
            # echo no line
            r="RULE${idx} : ${line#"rule : "}"
            ruleArr+=("$r")
            rules+="$r\n\n\n\n"
            idx=$(( idx + 1 ))
        elif [[ $line == *"cont"* ]]
        then
            # echo no cont
            contArr+=("${line#"cont : "}")
        elif [[ $line == *"ans"* ]]
        then
            # echo no ans
            ansArr+=("${line#"ans : "}")
        elif [[ $line == *"limit"* ]]
        then
            limitArr+=("${line#"limit : "}")
        fi

        # echo



    done < $file

    #print Arr
    echo -e "\n\n\nprint all items"
    for (( i=0; i<${#ruleArr[@]}; i++ ))
    do
        
        echo "rule${i} : ${ruleArr[$i]}"
        echo
        echo "cont${i} : ${contArr[$i]}"
        echo
        echo "ans${i} : ${ansArr[$i]}"
        # for (( j=0; j<${#RAC[@]}; j++ ))
        # do
            
        #     # echo ${RAC[$j]}
        #     name=${RAC[$j]}
        #     # echo $name
        #     name=${name}Arr
        #     echo ${name}${i}
        #     echo ${!name[$i]}
        #     # echo
        #     # echo ${${!${RAC[$j]}Arr}[$i]}
        # done
        echo -----
        echo
        echo

    done
}


# getRules2(){
#     file='./rules.txt'

#     RAC=("rule" "cont" "ans")
#     idxRule=1
#     idxRAC=0
#     # IFS=$'\n'
#     while read line;
#     do
#         # echo
#         if [ "$line" = "" ]
#         then   
#             line=" "
#         fi
#         case $idxRAC in

#             0)  
                
#                 echo -e "----------\nrules added : ${RAC[${idxRAC}]^^}${idxRule} : $line"
#                 # ruleArr+=("${RAC[${idxRAC}]^^}${idxRule} : $line")
#                 # rules+="${RAC[${idxRAC}]^^}${idxRule} : $line\n\n\n\n"
#                 ;;

#             1)
#                 echo -e "----------\ncont added : ${RAC[${idxRAC}]^^}${idxRule} : $line"

#                 # contArr+=("${RAC[${idxRAC}]^^}${idxRule} : $line")
#                 # contArr+=($line)
#                 ;;

#             2)
#                 echo -e "----------\nans added : ${RAC[${idxRAC}]^^}${idxRule} : $line"

#                 # ansArr+=("${RAC[${idxRAC}]^^}${idxRule} : $line")
#                 # ansArr+=($line)
#                 ;;
#         esac
#         idxRAC=$(( idxRAC + 1))
#         if [ $idxRAC -gt 2 ]
#         then
#             idxRAC=0
#         fi


#         if [ "$line" = "" ]
#         then   

#             for (( i=idxRAC; i<3; i++ ))
#             do
#                 # echo -e "----------\n${RAC[${i}]^^} added : ${RAC[${i}]^^}${idxRule} :" ""
#                 ruleArr+=("${RAC[${i}]^^}${idxRule} : $line")
#                 # rules+="${RAC[${i}]^^}${idxRule} : $line\n\n\n\n"
#             done
#             idxRule=$(( idxRule + 1 ))
#             idxRAC=0
#         else
#             # contArr+=("${RAC[${1}]^^}${idxRule} : $line")
#             # ansArr+=("${RAC[${2}]^^}${idxRule} : $line")
#             # name=${RAC[${idxRAC}]}
#             # ${name}Arr
#             # r=${name}Arr
#             r=ruleArr
#             # r=${RAC[$idxRAC]}Arr
#             # echo ${r}
#             ${!r}+=("$line")
            
#             # ${RAC[$idxRAC]}Arr+=("$line")
        
#             # echo -e "----------\n${RAC[${idxRAC}]^^} added : ${RAC[${idxRAC}]^^}${idxRule} : $line"
#             idxRAC=$(( idxRAC + 1))
        
#             # echo -e "----------\nrules added : ${RAC[${idxRAC}]^^}${idxRule} : $line"
#             # echo -e "----------\ncont added : ${RAC[${idxRAC}]^^}${idxRule} : $line"
#             # echo -e "----------\nans added : ${RAC[${idxRAC}]^^}${idxRule} : $line"

#             # ruleArr+=("${RAC[${0}]^^}${idxRule} : $line")
#             # rules+="${RAC[${0}]^^}${idxRule} : $line\n\n\n\n"

#             # contArr+=($line)

#             # ansArr+=($line)


#             # r=${RAC[0]}
#             # echo ${r^^}
#             # echo "${RAC[${idxRAC}]} ${idxRule} = ${RAC[${idxRAC}]^^}${idxRule} : $line"
#             # echo "${RAC[${idxRAC}]^^}${idxRule} : $line"
#             # ${!RAC}+="$line\n\n"
#             # echo $line
            




#             # # contArr+=(${!c})

#             # idxInside=$(( idxInside + 1 ))
#         #     echo "$idxInside $line"
#         fi
#         # echo $line
#     done < $file

#     #print Arr
#     # echo -e "\n\n\nprint all items"
#     # for (( i=0; i<${#ruleArr[@]}; i++ ))
#     # do
        
#     #     echo "rule${i} : ${ruleArr[$i]}"
#     #     echo
#     #     echo "cont${i} : ${contArr[$i]}"
#     #     echo
#     #     echo "ans${i} : ${ansArr[$i]}"
#     #     # for (( j=0; j<${#RAC[@]}; j++ ))
#     #     # do
            
#     #     #     # echo ${RAC[$j]}
#     #     #     name=${RAC[$j]}
#     #     #     # echo $name
#     #     #     name=${name}Arr
#     #     #     echo ${name}${i}
#     #     #     echo ${!name[$i]}
#     #     #     # echo
#     #     #     # echo ${${!${RAC[$j]}Arr}[$i]}
#     #     # done
#     #     echo -----
#     #     echo
#     #     echo

#     # done



# }



: << "INIT"
    init main function
INIT


init(){
    updateVerses
    echo ${numV} verses exist.

    IFS=$'\n'



    warn="\nGOD LOVES YOU\nJesus has secrificed himself for you\n\n\n\n\n"


    # priorIFS=$IFS
    # IFS=$'\n'
    # for (( i=0; i<9; i++))
    # do
    # #     idxR=$(( $i+1 ))
    # #     # echo $idxR
    # #     r=rule$idxR
    # #     c=cont$idxR
    # #     # echo ${!r}

    # #     rules+=${!r}"\n\n\n"
    # #     # conts+=${!c}
    # #     ruleArr+=(${!r})
    # #     contArr+=(${!c})
    # done
    # IFS=$priorIFS




<< "GATE"
open the gate with a dialog
GATE
    apple_dialog $rules
    while [ "$ans" = "No" ]
    do
        apple_dialog "${warn}\n\n${rules}"
    done


<< "REPEAT"

REPEAT

    # append time and msg
    record "\n\n\n\n\n\n\n$(date +%a) $(date +%b) $(date +%d) $(date +"%H:%M") $(date +%Y) "


    echo "the number : ${#ruleArr[@]}"
    i
    for (( i=0; i<${#ruleArr[@]}; i++ ))
    do
        echo -e "\n\n\nEnter Rule ${i}"
        echo -e "${ruleArr[${i}]}\n\n"
        echo "${contArr[${i}]}"

        # r=rule${i}
        # c=cont${i}
        # echo "################################${r} ${c}"
        # echo -e "${!r}\n${!c}"

        apple_text "${ruleArr[${i}]}\n\n\n\n${contArr[${i}]}"
        echo $ans
        echo $msg

        limit=10
        while [ "$ans" = "No" -o ${#msg} -lt ${limit} -o "$msg" != "${ansArr[$i]}" ]
        do
            alertUpdate $msg $limit
            apple_text ${alrt}${warn}${ruleArr[${i}]}
        done

        record $msg
    done







    # record "ARE YOU OBSESSED? ${msg}"

    closeVerse

}


<< "WAIT"

WAIT
wait(){


    # baseMin=2
    # base=$(( $baseMin * 60 ))
    # var=$(( base / 4 ))
    # variance test
    limitT=$1

    # baseMin=61
    # limitT=$(( $baseMin * 60 ))
    echo "wait ${limitT} seconds"

    mins=$(( $limitT / 60 ))
    # echo $mins
    hours=$(( ${mins} / 60 ))

    mins=$(( $mins - $hours * 60 ))
    sec=$(( $limitT - $hours * 3600 - $mins * 60 ))

    echo $hours:$mins:$sec left

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
        echo "checkout limitT=$limitT"
    fi

    #MINUTES
    arr=(50 40 30 20 10 5 4 3 2 1)

    for (( i=0; i<${#arr[@]}; i++ ))
    do
        echo i=$i
        if [ $limitT -gt $(( ${arr[$i]} * 60 )) ]
        then
            leftOver=$(( $limitT - $(( ${arr[$i]} * 60 )) ))
            echo leftOver : $leftOver limitT : $limitT
            sleep $leftOver
            echo ${arr[$i]} mins left.
            limitT=$(( $limitT - $leftOver ))
            echo "update limitT : $limitT"
        fi
    done  

    echo "checkout limitT=$limitT"


    #SECONDS
    for (( i=0; i<${#arr[@]}; i++ ))
    do
        if [ $limitT -gt ${arr[$i]} ]
        then
            leftOver=$(( $limitT - ${arr[$i]} ))
            sleep $leftOver
            echo ${arr[$i]} secs left.
            limitT=$(( $limitT - $leftOver ))
        fi
    done   
}





