
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

printArrs(){
    #print Arr
    echo -e "\n\n\nprint all items"
    for (( i=0; i<${#ruleArr[@]}; i++ ))
    do
        
        echo -e "ruleArr${i} : ${ruleArr[$i]}"
        echo
        echo -e "contArr${i} : ${contArr[$i]}"
        echo
        echo -e "ansArr${i} : ${ansArr[$i]}"
        echo
        echo -e "limitArr${i} : ${limitArr[$i]}"
        echo -e "-----\n\n\n"
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
    done
    echo size of ruleArr : ${#ruleArr[@]}
    echo size of contArr : ${#contArr[@]}
    echo size of ansArr : ${#ansArr[@]}
    echo size of limitArr : ${#limitArr[@]}

    echo
}

<< "READ"

테스트케이스
rule : 을 발견한다 ruleArr에 저장할 것이다.
엔터가 있어도 계쏙 rule에 저장

cont나 ans을 만나면 그때 contArr, ansArr에 넣는다.
빈줄을 만나면 다음 rule으로 넘어간다.

현재 저장할 arr을 명시해둔다. 근데 그게 되나? bash에서?

curArr=$ruleArr
curAA+=...

---

전통적인 시도
테스트케이스
rule을 만난다. 
빈칸이나 cont가 있거나 ans가 있지 않으면 모두 ruleArr[i]에 저장한다.
ruleArr+='\n'nextLine

만약 빈줄을 만났는데, 현재 arr이 rule이었다면
cont, ans, limit arr을 모두 저장해야 한다. 

if curArr=rule
    fill cont
    fill ans
    fill limit
if curArr=cont
    fill ans
    fill limit

만약 array을 넣거나 nameref을 넣을 수 있다면?
---


i=0
order=0
while read line
    line을 읽는다
    if line = empty line
        for idx = order to len RAC
            tempArr=RAC[idx] arr
            tempArr+=" "
        order=0
        continue

    is rule, cont, ans, limit?
    if rule
        i=0
        curArr[rule]
        curArr+=(line)
    if cont
        i=1
        curArr[cont]
        curArr+=(line)
    if ans
        i=2
        curArr[ans]
        curArr+=(line)
    if limit
        i=3
        curArr[limit]
        curArr+=(line)
    

    if order < i
        for idx = order to i
            tempArr=RAC[idx] arr
            tempArr+=" "
        order = i

    order++

    if order > 2
        order = -1
    


done

---

declare -a ruleArr
declare -a contArr
declare -a ansArr
declare -a limitArr

allArr=( ruleArr contArr ansArr limitArr )
arrIdx=0
while read line
do
    if [ line = "" ]
        local read_i
        for (( read_i=$arrIdx; read_i<${#allArr[@]}; read_i++ ))
        do
            t=${allArr[$read_i]}
            declare -n tmpArr=${t[@]}
            tempArr+=(" ")
        done
        arrIdx=0
        continue

    t=${allArr[$arrIdx]}
    declare -n tmpArr=${t[@]}
    tempArr+=(line)
    arrIdx=$(( arrIdx + 1 ))
    if [ arrIdx \gt 2 ]
    then
        arrIdx=0
    fi
done


---

A : ( rule cont ans limit )
for i in A
if curArr[i] = rule
    idx=i
    break

for i=idx to A.len
    fill A[i]

---
검색
https://unix.stackexchange.com/questions/545502/bash-array-of-arrays


declare -a ruleArr
declare -a contArr
declare -a ansArr
declare -a limitArr
arr=( ruleArr contArr ansArr limitArr )

for i in $arr
do
    declare -n temtArr=$i

    for j in $tempArr
        j+=(...)
done

이것을 적용하면...

while read line
do
    if line = empty line
        declare -n arr=
done





READ


# fillArr(){
#     declare -n arr=$1
#     arr+=($2)
# }
declare -a ruleArr=()
declare -a contArr=()
declare -a ansArr=()
declare -a limitArr=()

getRules(){
    file='./rules.txt'
    allArr=( ruleArr contArr ansArr limitArr )

    order=${#allArr[@]}
    arrIdx=0

    ruleNum=1

    while read line;
    do  
        # echo
        # echo
        # echo "line${line}line"
        # echo
        # echo
        if [[ $line == "" ]]
        then
            echo newline
            continue
        fi

        if [[ $line == *"rule"* ]]
        then
            echo
            arrIdx=0
            r="${line#"rule : "}"
            # echo "get rule $r"
            # tmpArr+=("$r")
            rules+="RULE ${ruleNum} : $r\n\n\n\n"
            ruleNum=$(( ruleNum + 1 ))
            
            t=${allArr[$arrIdx]}
            declare -n tmpArr=${t[@]}
            tmpArr+=("$r")
            echo "t=$t, r=$r"
            echo ${tmpArr[@]}
            
            # 새로운 빈줄을 만났을 때 남아있는 cont ans limit을 초기화한다.
            local read_i
            # echo ----------

            echo "new : from $order to ${#allArr[@]}"
            for (( read_i=$order; read_i<${#allArr[@]}; read_i++ ))
            do
                t=${allArr[$read_i]}
                declare -n tmpArr=${t[@]}
                tmpArr+=(" ")
                echo "t=$t, r=\" \""
                echo ${tmpArr[@]}
            done
            order=1

            continue
        fi
        
        


        if [[ $line == *"cont"* ]]
        then
            # echo "get cont $line"
            arrIdx=1
            r=("${line#"cont : "}")
            # echo $r
        elif [[ $line == *"ans"* ]]
        then
            # echo "get ans $line"
            arrIdx=2
            r=("${line#"ans : "}")
            # echo $r
        elif [[ $line == *"limit"* ]]
        then
            # echo "Get limit $line"
            arrIdx=3
            r=("${line#"limit : "}")
            # echo $r
        fi

        # echo order=$order
        t=${allArr[$arrIdx]}
        declare -n tmpArr=${t[@]}
        tmpArr+=("$r")
        echo "t=$t, r=$r"
        echo ${tmpArr[@]}


        # echo tmpArr=$tmpArr
        # echo line=$line
        # tmpArr+=("$line")


        # echo "----------order : $order and arrIdx : $arrIdx-----------"
        if [ $order -lt $arrIdx ]
        then
            # echo "runeNum=$ruleNum"
            # echo ruleArr
            echo "skip : from $order to $arrIdx"

            local read_i
            for (( read_i=$order; read_i<$arrIdx; read_i++ ))
            do
                t=${allArr[$read_i]}
                # echo "target array : $t = \" \""
                declare -n tmpArr=${t[@]}
                # echo "temp arr : $tmpArr"
                tmpArr+=(" ")
            done
            order=$arrIdx
        fi

        order=$(( order + 1 ))

        # if [ $order -gt 3 ]
        # then
        #     order=0
        # fi
    done < $file

    printArrs
    # echo $rules
    

}


getRules2(){
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
    for (( i=0; i<${#ruleArr[@]}; i++ ))
    do
        echo -e "\n\n\nEnter Rule ${i}"
        echo -e "${ruleArr[${i}]}\n\n"
        echo "${contArr[${i}]}"

        # r=rule${i}
        # c=cont${i}
        # echo "################################${r} ${c}"
        # echo -e "${!r}\n${!c}"
        
        correctRes="${ansArr[$i]}"
        echo "correct response : $correctRes"
        resStr="PLEASE TYPE <$correctRes>\n\nDO NOT FORGET CPAS LOCK.\nDO NOT FORGET PERIOD."

        apple_text "${ruleArr[${i}]}\n\n\n\n${contArr[${i}]}\n\n\n$resStr"
        echo $ans
        echo $msg

        if [ ${limitArr[$i]} = " " ]
        then
            limit=0
        else
            limit=${limitArr[$i]}
        fi


<< "PSEUDO"
 while (ans[i] != " " -a msg != ans[i]) -o (ans[i] = " " -a limit > #msg)
        repeat

질문의 종류 3가지
입력해야 하는 문구를 정확히 입력해야 한다.
내용을 입력해야 하되, 정해진 글자 수를 넘어야 한다
그냥 버튼만 누르면 된다.

각 경우에 따라 조건을 만족하지 않으면 같은 화면이 반복되어서 출력
버튼을 No을 누르거나, 입력해야 하는 문구가 있을 때 틀렸거나, 입력해야 하는 문구는 없어서 자유롭게 입력할 수 있는데 글자 수를 채우지 못했을 때
반복!

여기에 msg가 대문자이든 소문자이든 맞도록 하기 위해서 입력받은 문구를 대문자로 변환
msg^^

PSEUDO

    # cond1="$correctRes" != " " -a "${msg^^}" != "$correctRes"
    # cond2="$correctRes" = " " -a ${#msg} -lt ${limit}

    while [ "$ans" = "No" -o \( "$correctRes" != " " -a "${msg^^}" != "$correctRes" \) -o \( "$correctRes" = " " -a ${#msg} -lt ${limit} \) ]
        # while [ "$ans" = "No" -o ${#msg} -lt ${limit} -o "$msg" != "${ansArr[$i]}" ]
        do
            if [ "$correctRes" != " " -a "${msg^^}" != "$correctRes" ]
            then
                echo "글자가 틀렸다."
                echo ${msg^^}
                echo $correctRes
            #     echo "false : $cond1"
            # fi
            elif [ "$correctRes" = " " -a ${#msg} -lt ${limit} ]
            then
                echo "글자 수 미달"
                echo ${#msg}
                echo ${limit}
            #     echo "false : $cond2"
            fi
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
        # echo "checkout limitT=$limitT"
    fi

    #MINUTES
    arr=(50 40 30 20 10 5 4 3 2 1)

    for (( i=0; i<${#arr[@]}; i++ ))
    do
        # echo i=$i
        if [ $limitT -gt $(( ${arr[$i]} * 60 )) ]
        then
            leftOver=$(( $limitT - $(( ${arr[$i]} * 60 )) ))
            echo leftOver : $leftOver limitT : $limitT
            sleep $leftOver
            echo ${arr[$i]} mins left.
            limitT=$(( $limitT - $leftOver ))
            # echo "update limitT : $limitT"
        fi
    done  

    # echo "checkout limitT=$limitT"


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





