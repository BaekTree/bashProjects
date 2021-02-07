# origin_IFS=$IFS
declare -a ruleArr=()
declare -a contArr=()
declare -a ansArr=()
declare -a limitArr=()
declare -a completeArr=()
declare -a msgArr=()

allArr=( ruleArr contArr ansArr limitArr completeArr)
lenAllArr=${#allArr[@]}

SPLIT_BASE_LEN=500


log(){
    if [[ $log == "-l" ]]
    then
        echo -e "$1"
    fi
}

updateVerses(){
    curDir=$(pwd)
    log "[updateVerses] : move to bible dir"
    cd '/Users/baek/OneDrive/사진/삼성 갤러리/Pictures/Bible'
    log "[updateVerses] : pwd: $(pwd)"

    v=$(ls)
    vArr=($v)

    numV=${#vArr[@]}

    log "[updateVerses] : back to cur dir : $curDir"
    cd ${curDir}
}

genVerseIDx(){
    idxV=$(( $RANDOM % ${#vArr[@]} ))
}

viewVerse(){
    # closeVerse

    genVerseIDx
    log "[viewVerse] opening ${vArr[${idxV}]}"
    open -a Preview "/Users/baek/OneDrive/사진/삼성 갤러리/Pictures/Bible/${vArr[${idxV}]}";
    # $(sleep 10 || log 10 passed!) &
    osascript -e "tell application \"Preview\"
	set bounds of front window to {768, 0, 1536, 960}
    end tell"

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
        log "[closeVerse] : no pids"
    else
        log "[closeVerse] : preview pids : ${pids}"
        log "[closeVerse] : killing preview $pids"
        kill -9 ${pids}
        sleep 0.5
    fi
}


apple_dialog(){
    local mode=$1
    local dlg_arg=$@

    if [ "$mode" = "text" ]
    then
        apple_dialog_text "$dlg_arg"
    elif [ "$mode" = "show" ]
    then
        apple_dialog_show "$dlg_arg" "$@"
    else
        echo "ERROR in APPLE DIALOG MODE!"
        exit 0
    fi
}

apple_dialog_text(){
    log "[apple_dialog_text input]----------------------------------------:\n$1\n----------------------------------------\n"
    res=$(osascript -e "display dialog \"$1\" with title \"Code Repent Gradient\" buttons {\"Submit To God\", \"Back\"} default answer \"\" default button \"Submit To God\"")
    # closeVerse;
    parseBtnAns $res
    parseTxt $res
    viewVerse &

}


apple_dialog_show(){
    # closeVerse
    local shw_arg=$2
    # local shw_i
    local btn_txt
    # for shw_i in $shw_arg
    # do
        if [[ ! -z $shw_arg ]] && [[ $shw_arg = "single" ]]
        then
            btn_txt="buttons {\"Next\"}"
        else
            btn_txt="buttons {\"Next\",\"Back\"}"
        fi
    # done


    # res=$(osascript -e "display dialog \"$1\" with title \"Code Repent Gradient\" $btn_txt default button \"Next\"")
    res=$(osascript -e "display dialog \"$1\" with title \"Code Repent Gradient\" $btn_txt")

    parseBtnAns $res
    viewVerse &
}


# problematic!
parseBtnAns(){
    priorIFS=$IFS
    IFS=$":,"
    local arg=($1)
    log "[parseBtnAns] ARG : ${arg[@]}"

    local a
    for a in ${arg[@]}
    do
        log "[parseBtnAns] : arg array element : $a"
        if [ ${a} = "Submit To God" -o ${a} = "Next" -o ${a} = "Back" ]
        then
            ans=${a}
            log "[parseBtnAns] : ----------button answer is $ans----------"
        fi        
    done
    IFS=$priorIFS
}

parseTxt(){
    log "[parseTxt] parseTxt function init."
    log "[parseTxt] input arg : $1"
    priorIFS=$IFS
    IFS=$",:"
    local arg=($1)

    local i
    for (( i=0; i<${#arg[@]}; i++ ))
    do
        log "[parseTxt] arg element : ${arg[i]}"
        if [ ${arg[i]} == " text returned" ]
        then
            msg=${arg[(( $i+1 ))]}
            log "[parseTxt] : txt is $msg"
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
    echo -e "\n\n\n------------------------------------------------------------------------------------------------------print all items------------------------------------------------------------------------------------------------------"
    for (( i=0; i<${#ruleArr[@]}; i++ ))
    do
        
        echo -e "ruleArr${i} : |${ruleArr[$i]}|"
        echo -e "contArr${i} : |${contArr[$i]}|"
        echo -e "ansArr${i} : |${ansArr[$i]}|"
        echo -e "limitArr${i} : |${limitArr[$i]}|"
        echo -e "completeArr${i} : |${completeArr[$i]}|"

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
    echo size of completeArr : ${#completeArr[@]}
    
    echo 
    echo $(date)

}


<< "FILL"


FILL

fillMissingArrayFromTo(){
    # 새로운 rule을 만났을 때 넣을 값이 없던 arr들 채운다 : 남아있는 cont ans limit을 빈 값으로 넣는다.
    local left_over_idx=$1
    local idx_until_this_idx=$2
    log "[fillMissingArrayFromTo] fill array index : from $left_over_idx to $idx_until_this_idx"
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
        log "[fillMissingArrayFromTo] cur rule : $ruleNum, array to be filled : $t, line=\" \""
        tmpArr+=($empty)
        # tmpArr+=("emptyNew")
        log "[fillMissingArrayFromTo] array append : |${tmpArr[*]}|"
    done
}

isLargeStr(){
    local str=$1

    if [ ${#str} -gt $SPLIT_BASE_LEN ]
    then
        return 0
    else
        return 1
    fi
}

cleanseStrAndStore(){
    local str="$1"
    local curArr="$2"
    log "[cleanseStrAndStore] : curArr : |$curArr|"


    declare -n refArr=$curArr
    log "[cleanseStrAndStore] : original : |$str|"
   
   
    # local -n refArr="$2"
    # local str="$1"
    # local refArr="$2"
    str=$(echo -e "$str" | iconv -f UTF-8 | sed -e :a -e '/^\n*$/{$d;N;};/\n$/ba'); # 이렇게 하면 간혹 잘려서... dialog에서 화면이 깨진다. 
    # str=${str%% *}
    log "[cleanseStrAndStore] : final string : |$str|"
    log "[cleanseStrAndStore] : arr : |${refArr[*]}|"
    refArr+=("$str")
    log "[cleanseStrAndStore] : array append result : |${refArr[*]}|"
}

splitLargeStrAndStore(){
    local str="$1"
    local curArr="$2"
    while [ $(( ${#str} / $SPLIT_BASE_LEN )) -gt  0 ]
    do
        # echo $(( ${#str} / $SPLIT_BASE_LEN ))
        log "[target] : |$str|"
        frontSeg="${str:0:$SPLIT_BASE_LEN}"
        log "[frontSeg] : |$frontSeg|"
        endSeg="${str#"$frontSeg"}"
        # endSeg="${str#$frontSeg}" # 제대로 잘라내지 못한다. 중간에 껴있는 space나 개행 때문에 통으로 인식하지 못한다. 숫자는 {}을 붙이고 문자는 ""을 붙여라!
        log "[endSeg] : |$endSeg|"
        # exit 0
        ### 
        # endSeg=${str:$SPLIT_BASE_LEN} # $SPLIT_BASE_LEN자부터 끝까지. 뒷부분이 된다.



        # frontSeg=${str%$endSeg}
        log "[splitLargeStrAndStore] : cut $SPLIT_BASE_LEN chars : |$frontSeg|"

        cleanseStrAndStore "$frontSeg" "$curArr"

        # cleanStr=$(echo -e "$frontSeg" | iconv -f UTF-8 | sed -e :a -e '/^\n*$/{$d;N;};/\n$/ba'); # 이렇게 하면 간혹 잘려서... dialog에서 화면이 깨진다. 
        # # str=${str%% *}
        # log "[splitLargeStrAndStore] :cleanStr: |$cleanStr|"

        
        local curReadStage="$(getCurReadStage)"

        fillMissingArrayFromTo $(( curReadStage+1 )) $lenAllArr
        last_rule=${ruleArr[-1]}
        ruleArr+=($last_rule)

        str="$endSeg"
    done
    cleanseStrAndStore "$str" "$curArr"

}

saveApdStrToCurStageArr(){
    # 기존에 읽던 arr의 index : curStageArrIdx.
    # 그 arr에 현재까지 내용을 넣는다.
    # priorIFS=$IFS
    # IFS=$origin_IFS
    local getCurReadArrIdx="$(getCurReadArrIdx)"
    local str="$1"
    local curArr=${allArr[$getCurReadArrIdx]}
    log "\n[saveApdStrToCurStageArr]-------------------------------------------|"
    log "                                                                      |"
    log "[saveApdStrToCurStageArr] : current array index: $curArr"
    # log "[saveApdStrToCurStageArr] : $str" | sed -e :a -e '/^\n*$/{$d;N;};/\n$/ba'
    # 앞뒤에 붙어있는 개행과 빈칸을 지운다. 
    # str="$(echo -e "$str" | sed '/^$/d')"
    # str=${str%%\\n*}# 작동 안함
    # str=$(echo -e "$str" | sed -e 's/ *$//g') # 뒤에 빈칸 지우기.
    # str="$(echo -e "$str" | sed -e :a -e '/^\n*$/{$d;N;};/\n$/ba')"
    # str=$(echo -e "$str" | iconv -f UTF-8 | sed -e :a -e '/^\n*$/{$d;N;};/\n$/ba'); # 이렇게 하면 간혹 잘려서... dialog에서 화면이 깨진다. 
    # # str=${str%% *}
    log "[saveApdStrToCurStageArr] : str : |$str|"
    # 기존 arr의 누적해왔던 값을 기존 arr에 쓴다.
    # SPLIT_BASE_LEN=500

    # echo "$str"
    # echo "${#str}"

    if isLargeStr "$str";
    then
        # echo $(( ${#str} / $SPLIT_BASE_LEN ))
        splitLargeStrAndStore "$str" "$curArr"
    else
        cleanseStrAndStore "$str" "$curArr"
    fi

    # str=$(echo -e "$str" | iconv -f UTF-8 | sed -e :a -e '/^\n*$/{$d;N;};/\n$/ba'); # 이렇게 하면 간혹 잘려서... dialog에서 화면이 깨진다. 
    # # str=${str%% *}
    # log "[saveApdStrToCurStageArr] : |$str|"
    # refArr+=("$str")


    # IFS=$priorIFS

    log "                                                                      |"
    log "----------------------------------------------------------------------|\n"

    clearApdStr
}



<< "READ"

READ







assignEachcurStagecurStageArrIdx(){
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
}

CUR_READ_STAGE=${#allArr[@]}
CUR_READ_ARR_IDX=0

getCurReadStage(){
    echo "$CUR_READ_STAGE"
}

setCurReadStage(){
    local st="$1"
    CUR_READ_STAGE="$st"
    log "[setCurReadStage] : update CUR_READ_STAGE : $CUR_READ_STAGE"
}

updateNextCurReadStage(){
    CUR_READ_STAGE=$(( CUR_READ_STAGE + 1 ))
    log "[setCurReadStage] : update CUR_READ_STAGE : $CUR_READ_STAGE"

}

getCurReadArrIdx(){
    echo "$CUR_READ_ARR_IDX"
}

setCurReadArrIdx(){
    local idx="$1"
    CUR_READ_ARR_IDX=$idx
}

initializeReading(){
    assignEachcurStagecurStageArrIdx
    
    ruleNum=1
    newLineCount=0
}



isTransitionNextArr(){
    local line="$1"
    log "[isTransitionNextArr] : input : |$line|"
    if [[ $line == *"rule : "* ]] || [[ $line == *"cont : "* ]] || [[ $line == *"ans : "* ]] || [[ $line == *"limit : "* ]]
    then
        return 0
    else
        return 1
    fi
}


isValidLine(){
    local apdStr="$1"
    if [[ ! -z $apdStr ]] || [[ "$apdStr" != "" ]]
    then
        return 0
    else
        return 1
    fi
}


APD_STR=""

clearApdStr(){
    APD_STR=""
}

getApdStr(){
    echo "$APD_STR"
}

appendApdStr(){
    local s="$1"
    APD_STR+="$s"
}

checkMissingStageAndFillArr(){
    # rule, cont, ans, limit 순서인데 건너 뛰었을 때, 중간의 arr들을 빈값으로 넣는다.
    # currentStage을 통해서 현재 순서를 파악한다.
    # curStageArrIdx는 새로운 종류의 arr을 만났을 때 해당 arr의 값을 부여.
    # currentStage과 curStageArrIdx을 비교한다. 새로운 arr을 만날 때마다 currentStage과 curStageArrIdx을 변화시킨다.
    # 새로운 arr을 만나면 currentStage은 1씩 증가하고, curStageArrIdx는 해당 arr의 index을 부여.
    # 만약 건너뛴게 없다면 currentStage과 curStageArrIdx가 동일하게 1씩 증가. 만약 건너뛰었다면 그만큼 차이가 발생!
    # 그 인덱스들 사이의 arr에 빈값을 부여!
    # echo "----------currentStage : $currentStage and curStageArrIdx : $curStageArrIdx-----------"

    local curReadStage="$(getCurReadStage)"
    local curReadArrIdx="$(getCurReadArrIdx)"

    if [ $curReadStage -lt $curReadArrIdx ]
    then
        log "[configLineAndInitNewStage] runeNum=$ruleNum"
        log "[configLineAndInitNewStage] skip : from $curReadStage to $curReadArrIdx"

        fillMissingArrayFromTo $curReadStage $curReadArrIdx
        # 빈 arr들을 채웠으니 다시 currentStage을 curStageArrIdx와 동일하게 맞춰준다!
        setCurReadStage $curReadArrIdx
    fi
}

configLineAndInitNewStage(){


    if [[ line_ref == $1 ]]
    then
        echo "-----------------------------------------ERROR-----------------------------------------"
        echo "configLineAndInitNewStage name ref circular error. "
        echo "local name ref has the same name of input"
        echo "---------------------------------------------------------------------------------------"

        exit 1
    fi
    local -n line_ref="$1"

    # 새로운 arr을 쓰기 위해 priorAppendStr을 모으기 "시작". 다른 arr가 나올 때 모아둔 priorAppendStr을 저장한다.
    if [[ $line_ref == *"rule : "* ]]
    then
        # startNewRuleArrStage
        local curReadStage="$(getCurReadStage)"
        local curReadArrIdx="$(getCurReadArrIdx)"
        fillMissingArrayFromTo $curReadStage $lenAllArr

        setCurReadArrIdx $rule_idx
        setCurReadStage 0 # rule부터 다시 새로 시작!
        
        line_ref="${line_ref#"rule : "}"
        rules+="RULE ${ruleNum} : $line_ref\n\n"

        #지금 rule이 막 시작했으므로 초기화
        line_ref="RULE ${ruleNum} : $line_ref"
        ruleNum=$(( ruleNum + 1 ))

    else
        if [[ $line_ref == *"cont : "* ]]
        then
                # 새로운 종류의 arr을 시작하니까 setCurReadArrIdx  이 arr의 고유 index으로 다시 설정해준다.
                setCurReadArrIdx $cont_idx
                line_ref=("${line_ref#"cont : "}")
        elif [[ $line_ref == *"ans : "* ]] # user input single line_ref as answer.
        then
                setCurReadArrIdx $ans_idx
                line_ref=("${line_ref#"ans : "}")
        elif [[ $line_ref == *"limit : "* ]]
        then
                setCurReadArrIdx $lmt_idx
                line_ref=("${line_ref#"limit : "}")
        fi

        checkMissingStageAndFillArr
    fi


    






}

finishOneStage(){
    local apdStr="$(getApdStr)"
    if isValidLine "$apdStr";#invalid when first line of txt. apdStr contains nothing, so empty string is put to ruleArr.
    then
        saveApdStrToCurStageArr "$apdStr"
    fi
}

appendEachLineAndSave(){
    local line="$1"
    # log "[appendEachLineAndSave] priorAppendStr input : $priorAppendStr"

        

        # rule으로 시작하고, 방금 줄은 str에 입력했으니 이제 계속 누적을 하고, rule이 아닌 줄을 만났을 때 ruleArr에 넣는다!
        # return

    # 이 부분의 역할 : 처음 rule cont ans limit을 발견했을 때 모드 전환. 새로운 arr에 저장한다고 인식해야 한다.
    # 기존 arr의 내용을 쓰는 부분
    # 내용 중간의 개행들은 살려두어야 하지만, 마지막 줄 이후에 다른 arr을 만나기까지 딸려오는 개행들은 지워야 한다.
    # sed을 사용 : s/*\n$//이 잘 안된다. sed는 개행을 기준으로 해서. 그래서... sed를 더 깊게... ba 사용.
    if isTransitionNextArr "$line";
    then
        # 기존에 읽던 arr의 index : curStageArrIdx.
        # 그 arr에 현재까지 내용을 넣는다.
        log "[appendEachLineAndSave] : face new stage : pause : line until flush the apdStr"
        
        finishOneStage

        updateNextCurReadStage
        configLineAndInitNewStage "line"
    fi

    #방금 읽은 줄을 priorAppendStr에 누적해서 추가!
    appendApdStr "$line\n"


}

logResultOption(){

    if [[ ! -z $debug ]] && [[ $debug = "-df" ]]
    then
        for (( lim_i=0; lim_i < ${#limitArr[@]}; lim_i++ ))
        do
            log "[getRules] : init limitArr."
            limitArr[$lim_i]=0
        done
        for (( lim_i=0; lim_i < ${#ansArr[@]}; lim_i++ ))
        do
            log "[getRules] : init ansArr."
            ansArr[$lim_i]=" "
        done
    fi

    if [[ ! -z $log ]] && [[ $log = "-l" ]]
    then
        printArrs
    fi
}

completeLastLine(){

    
    local apdStr="$(getApdStr)"
    log "[getRules] reading done. fill left over"
    saveApdStrToCurStageArr "$apdStr"

    # 마지막 오브 마지막 limit은 다른 arr을 만나지 않는다. 마지막 줄 str을 저장해준다.
    # 새로운 arr을 만나야 업데이트를 해준다. 그런데 만나지 못하고 읽기가 끝나서 업데이트를 수동으로 해줘야 한다.
    updateNextCurReadStage
    local curReadStage="$(getCurReadStage)"
    fillMissingArrayFromTo $curReadStage $lenAllArr
}


copyRuleForNextPrgp(){

        last_rule=${ruleArr[-1]}
        
        ## 만약 여러 개행으로 하나의 rule+cont+ans+limit이 끝난다면? 그대로 이어서는 안된다. 새로 추가하도록 내버려 둬야 한다.
        if [[ $line != *"rule : "* ]]
        then
            ruleArr+=($last_rule)
        fi
}



splitPrgh(){
    
    local line="$1"
    if ! isTransitionNextArr "$line";
    then
        log "[splitPrgh] : not transition to new arr."
        finishOneStage
        copyRuleForNextPrgp
        local curReadStage="$(getCurReadStage)"
        fillMissingArrayFromTo $(( curReadStage+1 )) $lenAllArr
    fi

}
isMeetNewline(){
    local line=$1

    if [[ $line == "" ]]
    then
        return 0
    else
        return 1
    fi
}


isParagraphThenSplitAndSave(){
    local line="$1"
    if isMeetNewline "$line";
    then
            newLineCount=$(( newLineCount + 1))
            log "[isParagraphThenSplitAndSave] : newLineCount : meet new line: $newLineCount"
    else
        if [ $newLineCount -eq 1 ]
        then
            newLineCount=0
        elif [ $newLineCount -gt 1 ]
        then
            log "[isParagraphThenSplitAndSave] : face a paragraph : detected continuous newlines : $newLineCount"

            splitPrgh "$line"
            newLineCount=0
        fi
    fi
}

getRules(){
    # 읽은 뒤 쪼갤 때 newline단위로 줄을 구분해야 한다.
    priorIFS=$IFS
    IFS=$'\n'

    initializeReading

    while read -r line || [ -n "$line" ]; do
        log "[getRules] read and acummulate : $line"

        isParagraphThenSplitAndSave "$line"
        
        appendEachLineAndSave "$line"

        
    done < $file

    # shell에서 마지막 줄을 읽지 않는다. 
    # c 기준으로 텍스트는 개행문자로 끝이 나야 한다. 그게 아니면 에러를 발생시키고 마지막 while을 실행하지 않는다.
    # https://stackoverflow.com/questions/12916352/shell-script-read-missing-last-line
    # 그래서... 
    completeLastLine
    
    logResultOption

    IFS=$priorIFS


}


: << "INIT"
    init main function
INIT


init(){
    updateVerses
    log "[init] ${numV} verses exist."

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

    apple_dialog_show "--------------------------------------------------------------
Code Repent Gradient : 마음을 돌이켜 하나님에게로 돌아가자.

Max glob arg_me U(G, me) s.t. U(me) <= U(G)
--------------------------------------------------------------
Welcome Back to Code Repent Gradient!\n$warn" "single"

    apple_dialog_show $rules "single"
    while [ "$ans" = "No" ]
    do
        apple_dialog_show "${warn}\n\n${rules}" "single"
    done


<< "REPEAT"

REPEAT

    # append time and msg
    record "\n\n\n\n\n\n\n$(date +%a) $(date +%b) $(date +%d) $(date +"%H:%M") $(date +%Y) "


    log "[init] the number of rules : ${#ruleArr[@]}"
    local i
    for (( i=0; i<${#ruleArr[@]}; i++ ))
    do



        log "----------------------------------------\n[init] Enter Rule ${i}"
        log "[init] rules : ${ruleArr[${i}]}\n\n"
        log "[init] cont : ${contArr[${i}]}"

        # r=rule${i}
        # c=cont${i}
        # echo "################################${r} ${c}"
        # echo -e "${!r}\n${!c}"
        
        correctRes="${ansArr[$i]}"
        log "correct response : $correctRes"
        resStr="PLEASE TYPE <$correctRes>"

        contents="${ruleArr[${i}]}\n\n${contArr[${i}]}"
 
        limit=${limitArr[$i]}


        if [ $limit -gt 0 ]
        then
            contents+="\nPlease Type more than $limit letters."
        fi  

        if [[ $correctRes != " " ]]
        then
            contents+="\n$resStr"
        fi
        log "[init] contents : $contents\n----------------------------------------"


        

        if [ ${completeArr[$i]} = " " ]
        then
            backFlag=0
            log "[init] current dialog pass stat : ------------------------false------------------------"
            apple_dialog_text "$contents"
            log "[init] parsed button from user : $ans"
            log "[init] parsed answer from user : $msg"

            if [ "$ans" = "Back" ]
            then
                log "[init] button stat------------------------pressBack------------------------"
                i=$(( i-2 ))
                if [ $i -lt 0 ]
                then
                    i=-1
                fi
                continue
            fi

            # if [ ${limitArr[$i]} = " " ]
            # then
            #     limit=0
            # else
            #     limit=${limitArr[$i]}
            # fi        

            while [ \( "$correctRes" != " " -a "${msg^^}" != "$correctRes" \) -o \( "$correctRes" = " " -a ${#msg} -lt ${limit} \) ]
            # while [ "$ans" = "No" -o ${#msg} -lt ${limit} -o "$msg" != "$correctRes" ]
            do
                    alrt=""
                    if [ "$correctRes" != " " -a "${msg^^}" != "$correctRes" ]
                    then
                        log "[init] while loop stat : 글자가 틀렸다."
                        log "[init] while loop stat : 입력한 글자 : ${msg^^}"
                        log "[init] while loop stat : 입력해야 하는 글자 : /$correctRes/"
                        alrt="YOU ENTERED <$msg>\nPLEASE ENTER <$correctRes>.\n"

                        # log "[init] while loop stat : false : $cond1"
                    # fi
                    elif [ "$correctRes" = " " -a ${#msg} -lt ${limit} ]
                    then
                        log "[init] while loop stat : 글자 수 미달"
                        log "[init] while loop stat : ${#msg}"
                        log "[init] while loop stat : ${limit}"
                        log "[init] while loop stat : false : $cond2"
                        alrt="YOU ENTERED <$msg>\nPLEASE ENTER MORE THAN $limit CHARS.\n"
                    fi
                    ans=""
                    msg=""


                    # alertUpdate $msg $limit
                    apple_dialog_text "${alrt}${warn}${ruleArr[${i}]}\n\nType$correctRes"
                    if [ "$ans" = "Back" ]
                    then
                        log "[init] button stat : ------------------------pressBack------------------------"
                        i=$(( i-2 ))
                        if [ $i -lt 0 ]
                        then
                            i=-1
                        fi
                        
                        backFlag=1

                        break
                    fi
            done

            if [[ $backFlag == 0 ]]
            then
                completeArr[$i]="true"
                log "[init] current dialog stat : ------------------------complete ${i}!------------------------"
                log "[init] dialog stat update: ${completeArr[@]}"
                msgArr[$i]=$msg
            fi

            # if [ -z $debug ]
            # then
            record $msg
            # fi
        else # if already submit answers to God.
            log "[init] current dialog stat : ------------------------true : show mode------------------------"

            contents+="\nAnswer : ${msgArr[$i]}"

            if [ $i -eq 0 ]
            then
                apple_dialog_show "$contents" "single"
            else
                apple_dialog_show "$contents"
            fi

            if [ "$ans" = "Back" ]
            then
                log "[init] current button stat : ------------------------pressBack------------------------"
                i=$(( i-2 ))
                if [ $i -lt 0 ]
                then
                    i=-1
                fi
            else # when press Next
                log "[init] current button stat : ------------------------pressNext------------------------"
                continue
            fi

        fi
        
<< "COMP"
        for i = 1 to allArr.len
            if comArr[i] = false # 여기 seg fault 안뜰까? ㅋㅋ
                apple_dialog text contents

                while ans = no or msg = false or msgLen < limit
                    applie_dialog text contents

                    if ans = back
                        i--
                        break
        else
            aple_dialog show contents
COMP
        




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







# LANG=ko_KR
# export LANG