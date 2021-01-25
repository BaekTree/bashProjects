
debugPrint(){
    if [[ $debug == "-d" ]]
    then
        echo -e "$1"
    fi
}

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
    # closeVerse

    genVerseIDx
    echo "opening ${vArr[${idxV}]}"
    open -a Preview "/Users/baek/OneDrive/사진/삼성 갤러리/Pictures/Bible/${vArr[${idxV}]}"
    # $(sleep 10 || echo 10 passed!) &
    sleep 10
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
    debugPrint "apple_text input : $1"
    res=$(osascript -e "display dialog \"$1\" with title \"Code Repent Gradient\" buttons {\"Yes\", \"No\"} default answer \"\" default button \"No\"")
    # closeVerse;
    parseBtnAns $res
    parseTxt $res
    viewVerse &

}


apple_dialog(){
    # closeVerse
    res=$(osascript -e "display dialog \"$1\" with title \"Code Repent Gradient\" buttons {\"Yes\", \"No\"} default button \"No\"")
    parseBtnAns $res
    viewVerse &
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
    debugPrint parseTxt
    debugPrint $1
    priorIFS=$IFS
    IFS=$",:"
    local arg=($1)

    local i
    for (( i=0; i<${#arg[@]}; i++ ))
    do
        debugPrint ${arg[i]}
        if [ ${arg[i]} == " text returned" ]
        then
            msg=${arg[(( $i+1 ))]}
            debugPrint txt is $msg
        fi
        
    done
    IFS=$priorIFS
}

#limit alert update
# alertUpdate(){
#     alrt="YOU ENTERED <"${1}">\nPLEASE ENTER MORE THAN "${2}" CHARS.\n"
# }

record(){
    echo -e $1 >> preq.txt
}

printArrs(){
    #print Arr
    echo -e "\n\n\nprint all items"
    for (( i=0; i<${#ruleArr[@]}; i++ ))
    do
        
        echo -e "ruleArr${i} : |${ruleArr[$i]}|"
        echo -e "contArr${i} : |${contArr[$i]}|"
        echo -e "ansArr${i} : |${ansArr[$i]}|"
        echo -e "limitArr${i} : |${limitArr[$i]}|"
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


<< "FILL"


FILL

fill_left_over(){
    # 새로운 rule을 만났을 때 넣을 값이 없던 arr들 채운다 : 남아있는 cont ans limit을 빈 값으로 넣는다.
    # limit 값이 있었으면 order = 4, allArr.length = 4가 되어서 그냥 pass.
    local left_over_idx=$1
    local idx_until_this_idx=$2
    debugPrint ----------
    debugPrint "new : from $left_over_idx to $idx_until_this_idx"
    for (( ; left_over_idx<$idx_until_this_idx; left_over_idx++ ))
    do
        local t=${allArr[$left_over_idx]}
        declare -n tmpArr=${t[@]}
        local empty=" "
        # 만약 limit이 빈칸이면 숫자 0을 넣는다. init 함수에서 number을 비교해서 타입 에러가 난다 
        if [ $left_over_idx -eq $lmt_idx ]
        then
            empty=0
        fi
        tmpArr+=($empty)
        # tmpArr+=("emptyNew")
        debugPrint "t=$t, line=\" \""
        debugPrint ${tmpArr[@]}
    done
}

splitSeg(){
    local cur_idx=$1
    local totalStr=$2
    local line_new=$3
    putTxtToArr $cur_idx $totalStr
    totalStr=""
    fill_left_over $(( cur_idx+1 )) ${#allArr[@]}
    local last_rule=${ruleArr[-1]}
}


<< "WRITE"
    
WRITE

putTxtToArr(){
    # 기존에 읽던 arr의 index : arrIdx.
    # 그 arr에 현재까지 내용을 넣는다.
    local arrIdx=$1
    local str=$2
    local arr_by_idx=${allArr[$arrIdx]}
    declare -n refArr=${arr_by_idx[@]}
    debugPrint "$str" | sed -e :a -e '/^\n*$/{$d;N;};/\n$/ba'
    # 앞뒤에 붙어있는 개행과 빈칸을 지운다. 
    str=$(echo -e "$str" | sed -e :a -e '/^\n*$/{$d;N;};/\n$/ba' -e 's/ *$//')
    debugPrint "|$str|"
    # 기존 arr의 누적해왔던 값을 기존 arr에 쓴다.
    splitBaseNum=1000

    if [ ${#str} -gt $splitBaseNum ]
    then
        while [ $(( ${#str} / $splitBaseNum )) -gt  0 ]
        do
            endSeg=${str:$splitBaseNum} # $splitBaseNum자부터 끝까지. 뒷부분이 된다.



            frontSeg=${str%$endSeg}

            refArr+=("$frontSeg")

            fill_left_over $(( arrIdx+1 )) ${#allArr[@]}
            last_rule=${ruleArr[-1]}
            ruleArr+=($last_rule)

            str=$endSeg
        done
    fi
    refArr+=("$str")


<< "SEG"
    
SEG

}



<< "READ"

READ

declare -a ruleArr=()
declare -a contArr=()
declare -a ansArr=()
declare -a limitArr=()

getRules(){
    # 읽은 뒤 쪼갤 때 newline단위로 줄을 구분해야 한다.
    priorIFS=$IFS
    IFS=$'\n'

    curFile=$0

    if [ $debug = "-d" ]
    then
        file='./rulesTest.txt'
    elif [[ $curFile = *"_up"* ]]
    then
        echo "This is in dev!"
        file='./rules_up.txt'
    else
        file='./rules.txt'
    fi

    allArr=( ruleArr contArr ansArr limitArr )
    lenAllArr=${#allArr[@]}

    #findLimitArr idx
    local find_idx
    for (( find_idx=0; find_idx<${#allArr[@]}; find_idx++ ))
    do
        if [ ${allArr[$find_idx]} = "ruleArr" ]
        then
            rule_idx=$find_idx
        elif [ ${allArr[$find_idx]} = "contArr" ]
        then
            cont_idx=$find_idx
        elif [ ${allArr[$find_idx]} = "ansArr" ]
        then
            ans_idx=$find_idx
        elif [ ${allArr[$find_idx]} = "limitArr" ]
        then
            lmt_idx=$find_idx
        fi
    done

    #limit ruleArr idx
    order=${#allArr[@]}
    arrIdx=0

    ruleNum=1
    str=""  
    newline_count=0
    while read line;
    do  
        
        if [[ $line == "" ]]
        then
            str+="\\n"
            newline_count=$(( newline_count+1 ))
            debugPrint "newline_count : meet new line: $newline_count"
            # if [ newline_count -eq 2 ]
            # then

            # fi
            continue
        else
            if [ $newline_count -eq 1 ]
            then
                newline_count=0
            elif [ $newline_count -gt 1 ]
            then
                
                debugPrint "newline_count : now put to text : $newline_count"
                newline_count=0
                debugPrint "newline_count : init : $newline_count"
                putTxtToArr $arrIdx $str
                str=""
                fill_left_over $(( arrIdx+1 )) ${#allArr[@]}
                last_rule=${ruleArr[-1]}

                ## 만약 여러 개행으로 하나의 rule+cont+ans+limit이 끝난다면? 그대로 이어서는 안된다. 새로 추가하도록 내버려 둬야 한다.
                if [[ $line != *"rule : "* ]]
                then
                    ruleArr+=($last_rule)
                fi

<< "SEG2"
   
SEG2

            fi

        fi

        debugPrint "read and acummulate : $line"
        if [[ $line == *"rule : "* ]]
        then
            # 새로 rule을 만났을 때, 입력 중인 내용이 있었으면 넣는다. 없으면 여기서는 pass. 
            # 기존 것을 그 arr에 쓰고 rule을 쓸 준비!
            if [ "$str" != "" ]
            then
                putTxtToArr $arrIdx $str
            fi
            # echo

            # 직전에 쓰고 있던 값에서 rule으로 바뀌었으니 더해준다. 더 이상 기존의 order가 아니다!
            order=$(( order + 1 ))

            arrIdx=$rule_idx
            line="${line#"rule : "}"
            rules+="RULE ${ruleNum} : $line\n\n\n\n"

            #지금 rule이 막 시작했으므로 초기화
            str=""
            str+="RULE ${ruleNum} : $line"\\n""
            ruleNum=$(( ruleNum + 1 ))
            
            # 새로운 rule을 만났을 때 넣을 값이 없던 arr들 채운다 : 남아있는 cont ans limit을 빈 값으로 넣는다.
            # limit 값이 있었으면 order = 4, allArr.length = 4가 되어서 그냥 pass.
            fill_left_over $order $lenAllArr

            # rule부터 다시 새로 시작!
            order=0

            # rule으로 시작하고, 방금 줄은 str에 입력했으니 이제 계속 누적을 하고, rule이 아닌 줄을 만났을 때 ruleArr에 넣는다!
            continue

        # 이 부분의 역할 : 처음 rule cont ans limit을 발견했을 때 모드 전환. 새로운 arr에 저장한다고 인식해야 한다.
        # 기존 arr의 내용을 쓰는 부분
        # 내용 중간의 개행들은 살려두어야 하지만, 마지막 줄 이후에 다른 arr을 만나기까지 딸려오는 개행들은 지워야 한다.
        # sed을 사용 : s/*\n$//이 잘 안된다. sed는 개행을 기준으로 해서. 그래서... sed를 더 깊게... ba 사용.
        elif [[ $line == *"cont : "* ]] || [[ $line == *"ans : "* ]] || [[ $line == *"limit : "* ]]
        then
            # 기존에 읽던 arr의 index : arrIdx.
            # 그 arr에 현재까지 내용을 넣는다.
            putTxtToArr $arrIdx $str

            order=$(( order + 1 ))

             # 새로운 arr을 쓰기 위해 str을 모으기 "시작". 다른 arr가 나올 때 모아둔 str을 저장한다.
            if [[ $line == *"cont : "* ]]
            then
                # 새로운 종류의 arr을 시작하니까 arrIdx을 이 arr의 고유 index으로 다시 설정해준다.
                arrIdx=$cont_idx
                line=("${line#"cont : "}")
            elif [[ $line == *"ans : "* ]] # user input single line as answer.
            then
                arrIdx=$ans_idx
                line=("${line#"ans : "}")
            elif [[ $line == *"limit : "* ]]
            then
                arrIdx=$lmt_idx
                line=("${line#"limit : "}")
            fi

            # 새로 arr에 넣을 str을 초기화. 여기에 계속 누적
            str=""
        fi

        #방금 읽은 줄을 str에 누적해서 추가!
        str+=$line$"\\n"






        # rule, cont, ans, limit 순서인데 건너 뛰었을 때, 중간의 arr들을 빈값으로 넣는다.
        # order을 통해서 현재 순서를 파악한다.
        # arrIdx는 새로운 종류의 arr을 만났을 때 해당 arr의 값을 부여.
        # order과 arrIdx을 비교한다. 새로운 arr을 만날 때마다 order과 arridx을 변화시킨다.
        # 새로운 arr을 만나면 order은 1씩 증가하고, arrIdx는 해당 arr의 index을 부여.
        # 만약 건너뛴게 없다면 order과 arrIdx가 동일하게 1씩 증가. 만약 건너뛰었다면 그만큼 차이가 발생!
        # 그 인덱스들 사이의 arr에 빈값을 부여!
        # echo "----------order : $order and arrIdx : $arrIdx-----------"
        if [ $order -lt $arrIdx ]
        then
            debugPrint "runeNum=$ruleNum"
            debugPrint "skip : from $order to $arrIdx"

            fill_left_over $order $arrIdx
            # 빈 arr들을 채웠으니 다시 order을 arrIdx와 동일하게 맞춰준다!
            order=$arrIdx
        fi


        # if [ $order -gt 3 ]
        # then
        #     order=0
        # fi
    done < $file
    putTxtToArr $arrIdx $str

    # 마지막 오브 마지막 limit은 다른 arr을 만나지 않는다. 마지막 줄 str을 저장해준다.
    fill_left_over $order $lenAllArr

    


    if [ $debug = "-d" ]
    then
            printArrs
    fi
    # echo $rules
    IFS=$priorIFS


}


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

    apple_dialog "Welcome Back to Code Repent Gradient!\n$warn"

    apple_dialog $rules
    while [ "$ans" = "No" ]
    do
        apple_dialog "${warn}\n\n${rules}"
    done


<< "REPEAT"

REPEAT

    # append time and msg
    record "\n\n\n\n\n\n\n$(date +%a) $(date +%b) $(date +%d) $(date +"%H:%M") $(date +%Y) "


    debugPrint "the number : ${#ruleArr[@]}"
    for (( i=0; i<${#ruleArr[@]}; i++ ))
    do
        debugPrint -e "\n\n\nEnter Rule ${i}"
        debugPrint -e "${ruleArr[${i}]}\n\n"
        debugPrint "${contArr[${i}]}"

        # r=rule${i}
        # c=cont${i}
        # echo "################################${r} ${c}"
        # echo -e "${!r}\n${!c}"
        
        correctRes="${ansArr[$i]}"
        debugPrint "correct response : $correctRes"
        resStr="PLEASE TYPE <$correctRes>"

        contents="${ruleArr[${i}]}\n\n${contArr[${i}]}"

        if [[ ${ansArr[$i]} != " " ]]
        then
            contents+="\n$resStr"
        fi
        debugPrint -e "$contents"

        apple_text "$contents"
        debugPrint $ans
        debugPrint $msg

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
            alrt=""
            if [ "$correctRes" != " " -a "${msg^^}" != "$correctRes" ]
            then
                debugPrint "글자가 틀렸다."
                debugPrint "입력한 글자 : ${msg^^}"
                debugPrint "입력해야 하는 글자 : /$correctRes/"
                alrt="YOU ENTERED <$msg>\nPLEASE ENTER <$correctRes>.\n"

                # debugPrint "false : $cond1"
            # fi
            elif [ "$correctRes" = " " -a ${#msg} -lt ${limit} ]
            then
                debugPrint "글자 수 미달"
                debugPrint ${#msg}
                debugPrint ${limit}
                debugPrint "false : $cond2"
                alrt="YOU ENTERED <$msg>\nPLEASE ENTER MORE THAN $limit CHARS.\n"
            fi
            ans=""
            msg=""


            # alertUpdate $msg $limit
            apple_text "${alrt}${warn}${ruleArr[${i}]}\n\nType${ansArr[$i]}"
        done

        if [ -z $debug ]
        then
            record $msg
        fi
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
            (osascript -e "display notification \"${arr[$i]} mins left\" with title \"Code Repent Gradient\" subtitle \"glob arg max U s.t. U(G)\" sound name \"Frog\"")

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
            (osascript -e "display notification \"${arr[$i]} secs left\" with title \"Code Repent Gradient\" subtitle \"glob arg max U s.t. U(G)\" sound name \"Frog\"")
            limitT=$(( $limitT - $leftOver ))
        fi
    done   
}







LANG=ko_KR