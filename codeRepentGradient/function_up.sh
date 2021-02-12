# export LANG="ko_KR.UTF-8" #없으면 간혹 sed: RE error: illegal byte sequence 무한반복?



source dir.sh

source ./imageFunc.sh
# source ./getValuesFuncR.sh






log(){
    if [[ $log == "-l" ]]
    then
        echo -e "$1"
    fi
}


hideAll(){
    osascript -e "tell application \"Finder\"
    set visible of every process whose visible is true and name is not \"Finder\" to false
    close every window
    end tell"
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
    # closePreview;
    parseBtnAns $res
    parseTxt $res
    showImg &

}


apple_dialog_show(){
    # closePreview
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
    showImg &
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
    log "[parseTxt] parseTxt function startValueReminder."
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



: << "startValueReminder"
    startValueReminder main function
startValueReminder


startValueReminder(){
    updateImgList
    log "[startValueReminder] ${numV} verses exist."

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


    log "[startValueReminder] the number of rules : ${#ruleArr[@]}"
    
    

    # local is_rnd_arg=0
    if [[ ! -z $is_rnd_arg ]] && [[ $is_rnd_arg = 1 ]]
    then
        {
            local -a ruleArrR=()
            local -a contArrR=()
            local -a ansArrR=()
            local -a limitArrR=()
            local -a completeArrR=()
            local -a msgArrR=()
                # local randRuleIdx=$(( $RANDOM % $ruleNum ))
                # local i = ${uniqueRuleIdxArr[$randRuleIdx]}

            local fixRuleNum=$rnd_first_arg
            local numRandPick=$rnd_second_arg


            local ruleNum=${#uniqueRuleIdxArr[@]}
            local -a selectedRuleArr=()
            for (( s_i=0; s_i<$fixRuleNum; s_i++ ))
            do
                selectedRuleArr+=(${s_i})
            done


            if [ $(( $fixRuleNum + $numRandPick )) -gt $ruleNum ]
            then
                echo "$(( $fixRuleNum + $numRandPick ))"
                echo $ruleNum
                echo "the number of first fixed value + the number of randomly picking values > the number of total values."
                exit 0
            fi

            local select_i=0
            
            while [[ $select_i < $numRandPick ]]
            do
                local randRuleIdx=$(( $RANDOM % $(($ruleNum - $fixRuleNum)) ))
                # echo $randRuleIdx
                selectedRuleArr+=($(($randRuleIdx + $fixRuleNum)))
                

                # echo $idx
                select_i=$(( select_i + 1 ))
            done

            # for (( s_i=0; s_i<${#uniqueRuleIdxArr[@]}; s_i++ ))
            # do
            #     echo ${uniqueRuleIdxArr[$s_i]}
            # done

            selectedRuleArr+=($(( ${#uniqueRuleIdxArr[@]} - 1 )))
            # echo "uniqueRuleIdxArr의 마지막 값 : ${uniqueRuleIdxArr[$(( ${#uniqueRuleIdxArr[@]} - 1 ))]}"
            # echo 

            for (( select_i=0; select_i<${#selectedRuleArr[@]}; select_i++ ))
            do
                local uniqRuleIdx=${selectedRuleArr[$select_i]}
                local start_idx=${uniqueRuleIdxArr[$uniqRuleIdx]}
                local end_idx=${uniqueRuleIdxArr[$(($uniqRuleIdx+1))]}
                    # echo "uniq rule idx : $uniqRuleIdx"
                    # echo "start idx : $start_idx"
                    # echo "end idx : $end_idx"
                if [ $start_idx -eq ${uniqueRuleIdxArr[$(( ${#uniqueRuleIdxArr[@]} - 1 ))]} ]
                then
                    end_idx=$(( ${#ruleArr[@]} - 1 ))
                    # echo $start_idx
                    # echo $end_idx
                    # exit 0


                fi
                # 전체 ruleArr의 마지막 index가 뽑힌다면?

                # 그렇다면... 
                # if start_idx = unique rule arr num - 1
                # total rule arr num - start_idx

                # 지금 로직이 조금 틀린 것 같다.
  

                local range=$(( $end_idx - $start_idx ))

                for (( i=$start_idx; i<$end_idx; i++ ))
                do
                    # echo -e "${ruleArrR[$i]}"
                    ruleArrR+=("${ruleArr[$i]}")
                    contArrR+=("${contArr[$i]}")
                    ansArrR+=("${ansArr[$i]}")
                    limitArrR+=("${limitArr[$i]}")
                    completeArrR+=("${completeArr[$i]}")
                    msgArrR+=("${msgArr[$i]}")
                done
            done
        }
    else
        declare -n ruleArrR=ruleArr
        declare -n contArrR=contArr
        declare -n ansArrR=ansArr
        declare -n limitArrR=limitArr
        declare -n completeArrR=completeArr
        declare -n msgArrR=msgArr

    fi

    local i
    for (( i=0; i<${#ruleArrR[@]}; i++ ))
    do



        log "----------------------------------------\n[startValueReminder] Enter Rule ${i}"
        log "[startValueReminder] rules : ${ruleArrR[${i}]}\n\n"
        log "[startValueReminder] cont : ${contArrR[${i}]}"

        # r=rule${i}
        # c=cont${i}
        # echo "################################${r} ${c}"
        # echo -e "${!r}\n${!c}"
        
        correctRes="${ansArrR[$i]}"
        log "correct response : $correctRes"
        resStr="PLEASE TYPE <$correctRes>"

        contents="${ruleArrR[${i}]}\n\n${contArrR[${i}]}"
 
        limit=${limitArrR[$i]}


        if [ $limit -gt 0 ]
        then
            contents+="\nPlease Type more than $limit letters."
        fi  

        if [[ $correctRes != " " ]]
        then
            contents+="\n$resStr"
        fi
        log "[startValueReminder] contents : $contents\n----------------------------------------"


        

        if [ ${completeArrR[$i]} = " " ]
        then
            backFlag=0
            log "[startValueReminder] current dialog pass stat : ------------------------false------------------------"
            apple_dialog_text "$contents"
            log "[startValueReminder] parsed button from user : $ans"
            log "[startValueReminder] parsed answer from user : $msg"

            if [ "$ans" = "Back" ]
            then
                log "[startValueReminder] button stat------------------------pressBack------------------------"
                i=$(( i-2 ))
                if [ $i -lt 0 ]
                then
                    i=-1
                fi
                continue
            fi

            # if [ ${limitArrR[$i]} = " " ]
            # then
            #     limit=0
            # else
            #     limit=${limitArrR[$i]}
            # fi        

            while [ \( "$correctRes" != " " -a "${msg^^}" != "${correctRes^^}" \) -o \( "$correctRes" = " " -a ${#msg} -lt ${limit} \) ]
            # while [ "$ans" = "No" -o ${#msg} -lt ${limit} -o "$msg" != "$correctRes" ]
            do
                    alrt=""
                    if [ "$correctRes" != " " -a "${msg^^}" != "${correctRes^^}" ]
                    then
                        log "[startValueReminder] while loop stat : 글자가 틀렸다."
                        log "[startValueReminder] while loop stat : 입력한 글자 : ${msg^^}"
                        log "[startValueReminder] while loop stat : 입력해야 하는 글자 : /$correctRes/"
                        alrt="YOU ENTERED <$msg>\nPLEASE ENTER <$correctRes>.\n"

                        # log "[startValueReminder] while loop stat : false : $cond1"
                    # fi
                    elif [ "$correctRes" = " " -a ${#msg} -lt ${limit} ]
                    then
                        log "[startValueReminder] while loop stat : 글자 수 미달"
                        log "[startValueReminder] while loop stat : ${#msg}"
                        log "[startValueReminder] while loop stat : ${limit}"
                        log "[startValueReminder] while loop stat : false : $cond2"
                        alrt="YOU ENTERED <$msg>\nPLEASE ENTER MORE THAN $limit CHARS.\n"
                    fi
                    ans=""
                    msg=""


                    # alertUpdate $msg $limit
                    apple_dialog_text "${alrt}${warn}${ruleArrR[${i}]}\n\nType$correctRes"
                    if [ "$ans" = "Back" ]
                    then
                        log "[startValueReminder] button stat : ------------------------pressBack------------------------"
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
                completeArrR[$i]="true"
                log "[startValueReminder] current dialog stat : ------------------------complete ${i}!------------------------"
                log "[startValueReminder] dialog stat update: ${completeArrR[@]}"
                msgArrR[$i]=$msg
            fi

            # if [ -z $debug ]
            # then
            record $msg
            # fi
        else # if already submit answers to God.
            log "[startValueReminder] current dialog stat : ------------------------true : show mode------------------------"

            contents+="\nAnswer : ${msgArrR[$i]}"

            if [ $i -eq 0 ]
            then
                apple_dialog_show "$contents" "single"
            else
                apple_dialog_show "$contents"
            fi

            if [ "$ans" = "Back" ]
            then
                log "[startValueReminder] current button stat : ------------------------pressBack------------------------"
                i=$(( i-2 ))
                if [ $i -lt 0 ]
                then
                    i=-1
                fi
            else # when press Next
                log "[startValueReminder] current button stat : ------------------------pressNext------------------------"
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

    local pids=$(pgrep Preview)

    closePreview $pids
    

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