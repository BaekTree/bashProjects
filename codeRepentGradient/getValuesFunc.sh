source ./log.sh
# export LANG="ko_KR.UTF-8" #없으면 간혹 sed: RE error: illegal byte sequence 무한반복?
# export LC_ALL=C.UTF-8

SPLIT_BASE_LEN=1000
# READ_BASE_LEN=$(( $SPLIT_BASE_LEN / 10 ))
READ_BASE_LEN=$SPLIT_BASE_LEN

SPLIT_BASE_LEN=1000

if [[ -z allArr  ]] || [[ ${#allArr[@]} -lt 1 ]]
then
    echo "ERROR. declare allArr variables before import getValuesFunc.sh"
    exit 0
fi

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
    echo "size of ruleArr : ${#ruleArr[@]}"
    echo "size of contArr : ${#contArr[@]}"
    echo "size of ansArr : ${#ansArr[@]}"
    echo "size of limitArr : ${#limitArr[@]}"
    echo "size of completeArr : ${#completeArr[@]}"
    echo "size of uniqueRuleIdxArr : number of unique rules : "${#uniqueRuleIdxArr[@]}""
    
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
        local targetArrName=${allArr[$left_over_idx]}
        declare -n refArr=${targetArrName[@]}
        local empty=" "
        # 만약 limit이 빈칸이면 숫자 0을 넣는다. init 함수에서 number을 비교해서 타입 에러가 난다 
        if [ $left_over_idx -eq $lmt_idx ]
        then
            empty=0
        fi
        log "[fillMissingArrayFromTo] cur rule : $RULE_NUM, array to be filled : $targetArrName, line=\" \""
        refArr+=($empty)
        # refArr+=("emptyNew")
        log "[fillMissingArrayFromTo] array append : |${refArr[*]}|"
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

cleanseStr(){
    local -n str_ref="$1"
    if [[ ! -z $str_ref ]]
    then
        # log "[cleanseStr] : original : |$str_ref|"
        # #     # {
        # #         # echo -e "$str_ref" | iconv -f UTF-8 | sed -e :a -e '/^\n*$/{$d;N;};/\n$/ba' >> /dev/null
        # #     # } || {
        # #     #     echo "iconv fail"
        # #     #     echo "$str_ref"
        # #     # }

        # #     # https://stackoverflow.com/questions/11287564/getting-sed-error-illegal-byte-sequence-in-bash
            # str_ref=$(echo -e "$str_ref" | sed -e :a -e '/^\n*$/{$d;N;};/\n$/ba' 2>/dev/null) # 이렇게 하면 간혹 잘려서... dialog에서 화면이 깨진다. 

        # log "[cleanseStr] : remove end newlines done : |$str_ref|"

        local getCurReadArrIdx="$(getCurReadArrIdx)"

        if [[ $getCurReadArrIdx == $ans_idx ]]
        then
                str_ref=$(echo -e "$str_ref" | sed -e :a -e '/^\n*$/{$d;N;};/\n$/ba' 2>/dev/null) # 이렇게 하면 간혹 잘려서... dialog에서 화면이 깨진다. 
                str_ref=$(echo -e "$str_ref" | sed -e 's/ *$//' 2>/dev/null)
        fi


            # str=$(echo -e "$str_ref" | sed -e 's/ $//' 2> /dev/null) # 이렇게 하면 간혹 잘려서... dialog에서 화면이 깨진다. 
            # str="${str%%" "}"


        # #     # str=$(LC_CTYPE=C echo -e "$str_ref" | iconv -f UTF-8 | sed -e :a -e '/^\n*$/{$d;N;};/\n$/ba') # 이렇게 하면 간혹 잘려서... dialog에서 화면이 깨진다. 
        # str=${str%% *}

        log  "[cleanseStr] : final string : |$str_ref|"


        # str=$(echo -e "$str" | iconv -f UTF-8 | sed -e :a -e '/^\n*$/{$d;N;};/\n$/ba'); # 이렇게 하면 간혹 잘려서... dialog에서 화면이 깨진다. 
        # # str=${str%% *}
        # log "[saveStrCollectionToCurStageArr] : |$str|"
    fi
}

saveStrCollectionToCurStageArr(){
    # 기존에 읽던 arr의 index : curStageArrIdx.
    # 그 arr에 현재까지 내용을 넣는다.
    # priorIFS=$IFS
    # IFS=$origin_IFS
    local str="$getStrCollection"
    local getCurReadArrIdx="$(getCurReadArrIdx)"
    cleanseStr "str"

    local curArr=${allArr[$getCurReadArrIdx]}
    log "[saveStrCollectionToCurStageArr]--------------------------------------|"
    log "                                                                      |"
    log "[saveStrCollectionToCurStageArr] : current array index: $curArr"
    # log "[saveStrCollectionToCurStageArr] : $str" | sed -e :a -e '/^\n*$/{$d;N;};/\n$/ba'
    # 앞뒤에 붙어있는 개행과 빈칸을 지운다. 
    # str="$(echo -e "$str" | sed '/^$/d')"
    # str=${str%%\\n*}# 작동 안함
    # str=$(echo -e "$str" | sed -e 's/ *$//g') # 뒤에 빈칸 지우기.
    # str="$(echo -e "$str" | sed -e :a -e '/^\n*$/{$d;N;};/\n$/ba')"
    # str=$(echo -e "$str" | iconv -f UTF-8 | sed -e :a -e '/^\n*$/{$d;N;};/\n$/ba'); # 이렇게 하면 간혹 잘려서... dialog에서 화면이 깨진다. 
    # # str=${str%% *}
    log "[saveStrCollectionToCurStageArr] : str : |$str|"
    # 기존 arr의 누적해왔던 값을 기존 arr에 쓴다.
    # SPLIT_BASE_LEN=$SPLIT_BASE_LEN

    # echo "$str"
    # echo "${#str}"

# if isLargeStr "$str";
    # then
#         # echo $(( ${#str} / $SPLIT_BASE_LEN ))
        # splitLargeStrAndStore "$str" "$curArr"
# else
    # cleanseStrAndStore "$str" "$curArr"
# fi
    
    log "[saveStrCollectionToCurStageArr] : curArr : |$curArr|"

    declare -n refArr=$curArr
    

   
    log "[saveStrCollectionToCurStageArr] : arr : |${refArr[*]}|"
    refArr+=("$str")
    # log "[saveStrCollectionToCurStageArr] : array append result : |${refArr[*]}|"
    # refArr+=("$str")


    # IFS=$priorIFS

    log "                                                                      |"
    log "----------------------------------------------------------------------|\n"

    clearStrCollection
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

initializeReadVars(){
    assignEachcurStagecurStageArrIdx
    
    CUR_READ_STAGE=$lenAllArr
    CUR_READ_ARR_IDX=0
    clearStrCollection

    RULE_NUM=1
    NEW_LINE_COUNT=0
}



isLineTransToNextStage(){
    local -n line_ref="$1"
    log "[isLineTransToNextStage] : input : |$line_ref|"

    if [[ $line_ref == *"Rule : "* ]] || [[ $line_ref == *"Cont : "* ]] || [[ $line_ref == *"Ans : "* ]] || [[ $line_ref == *"Limit : "* ]]
    then
        line_ref=${line_ref,}
    fi


    if [[ $line_ref == *"rule : "* ]] || [[ $line_ref == *"cont : "* ]] || [[ $line_ref == *"ans : "* ]] || [[ $line_ref == *"limit : "* ]]
    then
        return 0
    else
        return 1
    fi
}


isValidLine(){
    # local strCollection="$getStrCollection"
    local strCollection="$1"
    if [[ ! -z $strCollection ]] || [[ "$strCollection" != "" ]]
    then
        return 0
    else
        return 1
    fi
}



clearStrCollection(){
    STR_COLLECTION=""
}

# getStrCollection(){
#     printf "$STR_COLLECTION"
# }
# subshell으로 strCollection을 불러오면... 한글이라서 그런지 내용이 길어서 그런지 간간히... 예측할 수 없이... 꼭 몇글자만... 깨져서 반환된다.
# 뭐가 유발하는지 모르겠음. 동일한 조건에서 여러번 반복해서 실행하면 간혹... 이 현상이 나타남.
# 같은 자리에서 나올 때까지 50번 하면 1번 나올 때도 있고, 갑자기 3번 연속으로 나올 때도 있음...
# global 을 안쓰려고 했으나 어쩔 수가 없음...
# 그래서 그냥 함수 모양의 name ref을 사용해서...

declare -n getStrCollection=STR_COLLECTION

appendStrCollection(){
    local s="$1"
    log "new string : $1"
    STR_COLLECTION+="$s"
    log "total string : $STR_COLLECTION"
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
        log "[configLineAndInitNewStage] runeNum=$RULE_NUM"
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
        rules+="RULE ${RULE_NUM} : $line_ref\n\n"

        #지금 rule이 막 시작했으므로 초기화
        line_ref="RULE ${RULE_NUM} : $line_ref"
        RULE_NUM=$(( RULE_NUM + 1 ))

        # echo ${#ruleArr[@]}
        uniqueRuleIdxArr+=($((${#ruleArr[@]})))
        log "-----------------------------------------NEW STAGE START : $RULE_NUM----------------------------------------------"
        log "o                                                                                                                o"
        log "o                                                                                                                o"
        log "o                                                                                                                o"
        log "o                                                                                                                o"
        log "o                                                                                                                o"
        log "o                                                                                                                o"
        log "o                                                                                                                o"
        log "o                                                                                                                o"
        log "------------------------------------------------------------------------------------------------------------------"

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



appendCurLineToStrCollection(){
    local line="$1"
    # log "[appendCurLineToStrCollection] priorAppendStr input : $priorAppendStr"

        
    # echo "result : |$line|"
    # echo "$line"
        # rule으로 시작하고, 방금 줄은 str에 입력했으니 이제 계속 누적을 하고, rule이 아닌 줄을 만났을 때 ruleArr에 넣는다!
        # return

    # 이 부분의 역할 : 처음 rule cont ans limit을 발견했을 때 모드 전환. 새로운 arr에 저장한다고 인식해야 한다.
    # 기존 arr의 내용을 쓰는 부분
    # 내용 중간의 개행들은 살려두어야 하지만, 마지막 줄 이후에 다른 arr을 만나기까지 딸려오는 개행들은 지워야 한다.
    # sed을 사용 : s/*\n$//이 잘 안된다. sed는 개행을 기준으로 해서. 그래서... sed를 더 깊게... ba 사용.
    log "[appendCurLineToStrCollection] : running append"

    local strClt="$getStrCollection"

    local lenStrClt=${#strClt}
    # echo $lenStrClt
    local lenLine=${#line}
    # echo $lenLine
    local sum=$(( $lenStrClt + $lenLine ))

    if [ $sum -gt $SPLIT_BASE_LEN ]
    then
        # echo overflow!
        # echo "sum : $sum"
        # echo "strCollction : $lenStrClt"
        # echo "line : $lenLine"
        saveStrCollectionToCurStageArr


        # updateNextCurReadStage
        local curReadStage="$(getCurReadStage)"
        # echo "curReadStage : $curReadStage"
        fillMissingArrayFromTo $(($curReadStage+1)) $lenAllArr
        copyCurStageRuleArr
    fi

    #방금 읽은 줄을 priorAppendStr에 누적해서 추가!


<< "newline"
    500글자로 끊은 줄이라면
        개행을 붙이면 안된다.
    모든 string에서는 마지막에 붙은 개행을 빼야한다.
    500글자로 끊은게 아니라면 개행을 붙여야 한다.

    개행이 한줄짜리는 개행을 붙여야 한다.

newline

    # if [ ${#line} -lt $READ_BASE_LEN ]
    # then
    #     line="$line\n"
    # fi
    appendStrCollection "$line\n"    


}

setZeroStageInDebugOption(){

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

    
    # local strCollection="$getStrCollection"
    log "[getRules] reading done. fill left over"
    saveStrCollectionToCurStageArr

    # 마지막 오브 마지막 limit은 다른 arr을 만나지 않는다. 마지막 줄 str을 저장해준다.
    # 새로운 arr을 만나야 업데이트를 해준다. 그런데 만나지 못하고 읽기가 끝나서 업데이트를 수동으로 해줘야 한다.
    updateNextCurReadStage
    local curReadStage="$(getCurReadStage)"
    fillMissingArrayFromTo $curReadStage $lenAllArr
}


copyCurStageRuleArr(){

        last_rule=${ruleArr[-1]}
        ruleArr+=($last_rule)
}



savePrghAndClearStrCollection(){
    
    # local line="$1"
    # if ! isLineTransToNextStage "line";
    # then
        log "[savePrghAndClearStrCollection] : not transition to new arr."
        saveStrCollectionToCurStageArr
        copyCurStageRuleArr
        
        local curReadStage="$(getCurReadStage)"
        fillMissingArrayFromTo $(( curReadStage+1 )) $lenAllArr
    # fi
    # else, just move the next stage!
    # 새로운 단락을 판단하는 기준은 여러 줄의 개행이 연속되어 나오다가 개행이 아닌 줄을 만났을 때이다.
    # 새로 만난 줄이 새로운 단계라면 그냥 그대로 새로운 단계를 시작하면 된다.

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

isMeetContinuousNewline(){
    if [ $NEW_LINE_COUNT -gt 1 ]
    then
        return 0
    else
        return 1
    fi
}


isLineParagraph(){
    local -n line_ref="$1"
    if isMeetNewline "$line_ref";
    then
            NEW_LINE_COUNT=$(( NEW_LINE_COUNT + 1))
            log "[isLineParagraph] : NEW_LINE_COUNT : meet new line: $NEW_LINE_COUNT"
            return 1
    else
        if [ $NEW_LINE_COUNT -eq 1 ] # 한줄의 개행을 만나다가 개행이 아닌 줄을 만났을 때
        then
            NEW_LINE_COUNT=0
            # line_ref+="\n"
            return 1
        elif [[ $NEW_LINE_COUNT -gt 1 ]] &&  ! isLineTransToNextStage "line"; # 연속된 개행이 쌓이다가 개행이 아닌 줄을 만났을 때
        then
            log "[isLineParagraph] : face a paragraph : detected continuous newlines : $NEW_LINE_COUNT and next line is not new stage" 
            NEW_LINE_COUNT=0
            return 0
        else # 연속되지도 않은 그냥 일반적인 줄. 
            # 혹은 1줄 보다 큰데 다음 stage을 만난 줄. 이 경우 연속된 줄 초기화를 해줘야 한다.
            NEW_LINE_COUNT=0  
            return 1
        fi


    fi
}
saveStrCollectionAndStartNewStage(){
    # saveStrCollectionAndStartNewStage
    # 기존에 읽던 arr의 index : curStageArrIdx.
    # 그 arr에 현재까지 내용을 넣는다.
    log "[saveStrCollectionAndStartNewStage] : face new stage : pause : line until flush the strCollection"
    
    local strCollection="$getStrCollection"
    #invalid when first line of txt. strCollection contains nothing, so empty string is put to ruleArr.
    if isValidLine "$strCollection";
    then
        saveStrCollectionToCurStageArr
    fi
    updateNextCurReadStage
    configLineAndInitNewStage "line"
}


getRules(){
    # 읽은 뒤 쪼갤 때 newline단위로 줄을 구분해야 한다.
    priorIFS=$IFS
    IFS=$'\n'

    initializeReadVars
    # c 기준으로 텍스트는 개행문자로 끝이 나야 한다. 그게 아니면 에러를 발생시키고 마지막 while을 실행하지 않는다.
    # https://stackoverflow.com/questions/12916352/shell-script-read-missing-last-line
    # 보장하기 위해서 마지막 줄을 읽는 명령어를 추가.


    while read -rn$READ_BASE_LEN line || [ -n "$line" ]; do

    # while read -r line
    # do

        log "[getRules] read and acummulate : $line"
        if isLineParagraph "line";
        then
            savePrghAndClearStrCollection
        fi

        
        if  isLineTransToNextStage "line";
        then    
           saveStrCollectionAndStartNewStage
        fi

        if isMeetContinuousNewline;
        then
            continue
        fi
        


        
        appendCurLineToStrCollection "$line"

        
    done < $file

    # 다음 stage arr을 만났을 때야 저장한다. 마지막 줄은 다른 stage arr을 만나지 않고 끝난다. 
    # 따라서 명시적으로 다시 저장해주어야 한다.
    completeLastLine
    
    setZeroStageInDebugOption

    IFS=$priorIFS


}



# cleanseStrAndStore(){
#     local str="$1"
#     local curArr="$2"
#     log "[cleanseStrAndStore] : curArr : |$curArr|"


#     declare -n refArr=$curArr
#     log "[cleanseStrAndStore] : original : |$str|"
   
   
#     # local -n refArr="$2"
#     # local str="$1"
#     # local refArr="$2"
#     if [[ ! -z $str ]]
#     then
#     # #     # {
#     # #         # echo -e "$str" | iconv -f UTF-8 | sed -e :a -e '/^\n*$/{$d;N;};/\n$/ba' >> /dev/null
#     # #     # } || {
#     # #     #     echo "iconv fail"
#     # #     #     echo "$str"
#     # #     # }

#     # #     # https://stackoverflow.com/questions/11287564/getting-sed-error-illegal-byte-sequence-in-bash
#         str=$(echo -e "$str" | sed -e :a -e '/^\n*$/{$d;N;};/\n$/ba' 2>/dev/null) # 이렇게 하면 간혹 잘려서... dialog에서 화면이 깨진다. 
#         str=$(echo -e "$str" | sed -e 's/ *$//' 2>/dev/null)
#     #     # str=$(echo -e "$str" | sed -e 's/ $//' 2> /dev/null) # 이렇게 하면 간혹 잘려서... dialog에서 화면이 깨진다. 
#         # str="${str%%" "}"


#     # #     # str=$(LC_CTYPE=C echo -e "$str" | iconv -f UTF-8 | sed -e :a -e '/^\n*$/{$d;N;};/\n$/ba') # 이렇게 하면 간혹 잘려서... dialog에서 화면이 깨진다. 
    
#     fi
#     # str=${str%% *}
#     log "[cleanseStrAndStore] : final string : |$str|"
#     log "[cleanseStrAndStore] : arr : |${refArr[*]}|"
#     refArr+=("$str")
#     log "[cleanseStrAndStore] : array append result : |${refArr[*]}|"
# }

# splitLargeStrAndStore(){
#     local str="$1"
#     local curArr="$2"
#     while [ $(( ${#str} / $SPLIT_BASE_LEN )) -gt  0 ]
#     do
#         # echo $(( ${#str} / $SPLIT_BASE_LEN ))
#         log "[target] : |$str|"
#         # 구원자!!
#         # https://forum.ubuntu-kr.org/viewtopic.php?t=25616
#         # frontSeg="$(echo $str | cut -b -$SPLIT_BASE_LEN | iconv 2>/dev/null)"
#         frontSeg="$(echo $str | cut -b -$SPLIT_BASE_LEN)"

#         # frontSeg="${str:0:$SPLIT_BASE_LEN}"
#         log "[frontSeg] : |$frontSeg|"
#         endSeg="${str#"$frontSeg"}"
#         # endSeg="${str#$frontSeg}" # 제대로 잘라내지 못한다. 중간에 껴있는 space나 개행 때문에 통으로 인식하지 못한다. 숫자는 {}을 붙이고 문자는 ""을 붙여라!
#         log "[endSeg] : |$endSeg|"
#         # exit 0
#         ### 
#         # endSeg=${str:$SPLIT_BASE_LEN} # $SPLIT_BASE_LEN자부터 끝까지. 뒷부분이 된다.



#         # frontSeg=${str%$endSeg}
#         log "[splitLargeStrAndStore] : cut $SPLIT_BASE_LEN chars : |$frontSeg|"

#         cleanseStrAndStore "$frontSeg" "$curArr"

#         # cleanStr=$(echo -e "$frontSeg" | iconv -f UTF-8 | sed -e :a -e '/^\n*$/{$d;N;};/\n$/ba'); # 이렇게 하면 간혹 잘려서... dialog에서 화면이 깨진다. 
#         # # str=${str%% *}
#         # log "[splitLargeStrAndStore] :cleanStr: |$cleanStr|"

        
#         local curReadStage="$(getCurReadStage)"

#         fillMissingArrayFromTo $(( curReadStage+1 )) $lenAllArr

#         copyCurStageRuleArr




#         str="$endSeg"
#     done
#     cleanseStrAndStore "$str" "$curArr"

# }
