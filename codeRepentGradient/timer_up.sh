#! /usr/local/bin/bash
# read $1
# echo input : $1
arg=$1
# clear

# ascriptComm=osascript -e "display dialog \"$1\" with title \"Code Repent Gradient\" buttons {\"Yes\", \"No\"} default button \"No\""



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
    sleep 1
    # echo 0.3 passed!
    $(osascript -e "tell application \"Preview\"
	set bounds of front window to {0, 0, 600, 900}
    end tell")
# open -a Preview -width 200 -height 500 '/Users/baek/OneDrive/사진/삼성 갤러리/Pictures/Bible/1585813311117.png'

}

hideAll(){
    # hideAll=$(osascript -e "tell application \"Finder\"\nset visible of every process whose visible is true and name is not \"Finder\" to false\nclose every window\nend tell\ndelay 1\ntell application \"Finder\" to quit\ntell application \"Notes\" to quit")   
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
    fi
}


apple_text(){
    closeVerse;
    viewVerse &
    res=$(osascript -e "display dialog \"$1\" with title \"Code Repent Gradient\" buttons {\"Yes\", \"No\"} default answer \"\" default button \"No\"")
    parseBtnAns $res
    parseTxt $res

}


apple_dialog(){
    closeVerse
    viewVerse &
    res=$(osascript -e "display dialog \"$1\" with title \"Code Repent Gradient\" buttons {\"Yes\", \"No\"} default button \"No\"")
    parseBtnAns $res
}


parseBtnAns(){
    priorIFS=$IFS
    IFS=$": "
    arg=($1)
    # echo $arg
    # apple_text $arg
    # arg=($res)

    # echo ${arg[0]}

    for (( i=0; i<${#arg[@]}; i++ ))
    do
        if [ ${arg[i]} = "Yes" -o ${arg[i]} = "No" ]
        # echo 
        then
            ans=${arg[i]}
            echo button answer is $ans
        fi        
    done
    IFS=$priorIFS
    # res=${arg[2]}
}

parseTxt(){
    echo parseTxt
    echo $1
    priorIFS=$IFS
    IFS=$",:"
    arg=($1)
    for (( i=0; i<${#arg[@]}; i++ ))
    do
        echo ${arg[i]}
        if [ ${arg[i]} == " text returned" ]
        then
        #     if [ ${arg[(( $i+1 ))]} == "returned" ]
              # then
                msg=${arg[(( $i+1 ))]}
                echo txt is $msg
        #     fi
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

read(){

<< "READ"

    파일에서 string을 읽는다.
    개행 빈칸인 줄을 만날 때 마다 다음 페이지의 내용 index으로 전환한다.
    동일한 페이지에서는 첫번째 줄은 rule, 두번째 줄은 cont, 세번째 줄은 ans이다. 
    ans는 있을 수도 있고 없을 수도 있다. 

    입력 textline

    메모
    ans가 있을 수도 있고 없을 수도 있다.
    2번째 줄의 cont는 반드시 있다. cont 다음 줄이 빈줄이면 거기서 끝이고
    빈줄이 아니면 ans가 있는 것이다.
    contents도 없을 수 있다!

    그러니까... rule 다음에 빈칸이 나오면... 일단 초기화를 하니까 상관없다 사실!

READ

    file='./rules.txt'

    RAC=("rule" "cont" "ans")
    idxR=1
    idxInside=0
    while read line;
    do
        if [ "$line" = "" ]
        then   
            idxR=$(( idxR + 1 ))
            idxInside=0
            echo
        else
            # r=${RAC[0]}
            # echo ${r^^}
            # echo "${RAC[${idxInside}]} ${idxR} = ${RAC[${idxInside}]^^}${idxR} : $line"
            # echo "${RAC[${idxInside}]^^}${idxR} : $line"
            # ${!RAC}+="$line\n\n"
            echo $line
            case $idxInside in

            0)  
                # echo h
                ruleArr+=("${RAC[${idxInside}]^^}${idxR} : $line")
                rules+="${RAC[${idxInside}]^^}${idxR} : $line\n\n\n\n"
                ;;

            1)
                # contArr+=("${RAC[${idxInside}]^^}${idxR} : $line")
                contArr+=($line)
                ;;

            2)
                # ansArr+=("${RAC[${idxInside}]^^}${idxR} : $line")
                ansArr+=($line)
                ;;
            esac



            # name=${RAC[${idxInside}]}
            # # ${name}Arr
            # ${name}Arr+=("$line")
            # # contArr+=(${!c})

            idxInside=$(( idxInside + 1 ))
        #     echo "$idxInside $line"
        fi
        # echo $line
    done < $file

    #print Arr
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



: << "INIT"
    init main function
INIT


init(){
    updateVerses
    echo ${numV} verses exist.

    # hideAll

    IFS=$'\n'

    # str2='RULE 1 DO NOT BE OBSESSED.\n \nRULE 2 PRAYER. \nHIS HELP. HIS POWER. HIS KNOWLEDGE.\nGOD LOVES US.\n \nRULE 3 STOP & REST \nSTOP & REST WHEN OBSESSED. STOP WHEN YOU ARE OBSESSED.  I REPEAT AGAIN. STOP WHEN YOU GET OBSESSED.  \n  \nRULE 4 TESTCASES \n \nRULE 5 PSEUDOCODE \n \nRULE 6 INITIALIZATION \n \nRULE 7 KEEP IT SIMPLE, YOU STUPID!\nIT’S A KISS.\nEASIER, SIMPLER, AND MORE LIKELY BRUTEFORCE THEN YOU THOUGHT'

    # rule1="RULE 1 MY UTILITY IS MAXIMIZED IN THE GRADIENT VECTOR DIRECTION IN REPENTENCE IN GOD."    
    # rule2="RULE 2 THE PROOF OF THE FAITH"
    # rule3="RULE 3 PRAYER."
    # rule4="RULE 4 STOP AND REST"    
    # rule5="WHAT IS YOUR EMOTION NOW?"
    # rule6="RULE 6 MEMO VERSES"

    # rule6="RULE 6 TESTCASES."
    # rule7="RULE 7 KEEP IT SIMPLE, YOU STUPID!"
    # rule8="RULE 5 PSEUDOCODE "
    # rule9="RULE 6 INITIALIZATION"

    # ans1="MY UTILITY IS MAXIMIZED IN THE GRADIENT VECTOR DIRECTION IN REPENTENCE IN GOD."

    # cont1="DO NOT BE OBSESSED. GOD IS THE CREATEOR OF THIS WORLD. 만물이 주에게서 나오고 주로 말미암고 주께로 돌아감이라. 세세에 영원히 주께 영광이 있을지어다. \n\nPLEASE TYPE ${ans1}\n\nDO NOT FORGET CPAS LOCK.\nDO NOT FORGET PERIOD."
    # cont2="TELL ME THE PROOF AND HISTORY OF HOW GOD HAS DELIEVERED YOU SO FAR.\nLIST THEM UP"
    # cont3="HIS HELP. HIS POWER. HIS KNOWLEDGE.\nGOD LOVES US.\n\nTYPE PRAYER REEQUEST NOW.\n\nPLEASE TYPE MORE THAN 20 CHARS"
    # cont4="STOP AND REST WHEN OBSESSED.\nSTOP WHEN YOU ARE OBSESSED.\n\nI REPEAT AGAIN.\nSTOP WHEN YOU GET OBSESSED.\n\nARE YOU OBSESSED?"  
    # cont5=" "
    # cont6="GIMME A MEMEO AMONG THE VERSES THAT YOU SAW\n"

    # cont6=" "
    # cont7="IT’S A KISS.\nEASIER, SIMPLER, AND MORE LIKELY BRUTEFORCE THEN YOU THOUGHT"
    # cont8=" "
    # cont9=" "



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
        apple_dialog "${warn}${rules}"
    done




    # echo "Enter Rule 1"
    # apple_text "${rule1}\n${cont1}"
    # # open -a Preview '/Users/baek/OneDrive/사진/삼성 갤러리/Pictures/Bible/1585813311117.png'
    # echo $ans
    # echo $msg
    # while [ "$ans" = "No" -o "$msg" != "$ans1" ]
    # do
    #     apple_text "GOD LOVES YOU\nJesus has secrificed himself for you\n\n\n\n\n"${rule1}
    # done







    # record "\n\n\n\n\n\n\n-"

    # append time and msg
    # record "\n\n\n\n\n\n\n$(date +%a) $(date +%b) $(date +%d) $(date +"%H:%M") $(date +%Y) "


    echo "the number : ${#ruleArr[@]}"
    for (( i=0; i<${#ruleArr[@]}; i++ ))
    do
        # echo $i
        # idx=$(( $i + 1 ))
        echo -e "\n\n\nEnter Rule ${i}"
        echo -e "${ruleArr[${i}]}\n\n"
        echo "${contArr[${i}]}"

        # r=rule${i}
        # c=cont${i}
        # echo "################################${r} ${c}"
        # echo -e "${!r}\n${!c}"

        apple_text "${ruleArr[${i}]}\n${contArr[${i}]}"
        # record $ans
        # record $msg
        # limit=10
        # while [ "$ans" = "No" -o ${#msg} -lt ${limit} ]
        # do
        #     alertUpdate $msg $limit
        #     apple_text ${alrt}${warn}${rule2}
        # done

        # record $msg
    done


    # echo "Enter Rule 2"
    # apple_text "${rule2}\n${cont2}"
    # echo $ans
    # record $msg
    # limit=20
    # while [ "$ans" = "No" -o ${#msg} -lt ${limit} ]
    # do
    #     alertUpdate $msg $limit
    #     apple_text ${alrt}${warn}${rule2}
    # done

    # record $msg






    # echo "Enter Rule 3"
    # apple_text "${rule3}\n${cont3}"
    # echo $ans
    # record $msg
    # limit=10
    # while [ "$ans" = "No" -o ${#msg} -lt 10 ]
    # do
    #     alertUpdate $msg $limit
    #     apple_text ${alrt}${warn}${rule3}
    # done

    # record "ARE YOU OBSESSED? ${msg}"








    # echo "Enter Question"
    # apple_text "${rule4}\n${cont4}"
    # echo $ans
    # record $msg
    # limit=10
    # while [ "$ans" = "No" -o ${#msg} -lt 10 ]
    # do
    #     alertUpdate $msg $limit
    #     apple_text ${alrt}${warn}${rule4}
    # done

    # echo $msg




    # echo "Enter Rule 5"
    # # echo "Enter Question"
    # apple_text "${rule5}\n${cont5}"
    # echo $ans
    # record $msg
    # limit=10
    # while [ "$ans" = "No" -o ${#msg} -lt 10 ]
    # do
    #     alertUpdate $msg $limit
    #     apple_text ${alrt}${warn}${rule5}\n${cont5}
    # done

    # echo $msg

    
    # echo "Enter Rule 6"
    # # echo "Enter Question"
    # apple_text "${rule6}\n${cont6}"
    # echo $ans
    # record $msg
    # limit=10
    # while [ "$ans" = "No" -o ${#msg} -lt 10 ]
    # do
    #     alertUpdate $msg $limit
    #     apple_text ${alrt}${warn}${rule6}\n${cont6}
    # done

    # echo $msg





    closeVerse
    # echo "init again";
    # $(nohup ./timer.sh &)
}


wait(){
    << "WAIT"

WAIT


# baseMin=2
# base=$(( $baseMin * 60 ))
# var=$(( base / 4 ))
# variance test
limitT=$arg

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




















<< "START"

START

echo -e "\n\n\n\n$(date +%a) $(date +%b) $(date +%d) $(date +"%H:%M") $(date +%Y)" 


wait
read
# init





<< 'CASEYES'
    apple_text $rule1

    # rule 1
    while [ "$res" != "button returned:Yes, text returned:DO NOT BE OBSESSED." ]
    do
        # echo $rule
        apple_text "RULE 1 DO NOT BE OBSESSED. "
    done

    echo "RULE 1 pass."
CASEYES

<< 'TRY'

<< 'RESULT'
button returned
Yes
 text returned
하나님 감사합니다!
RESULT


    # echo ${arr[1]}
    # echo ${arr[3]}
    # echo $res
    res=${arr[1]}
    msg=${arr[3]}
    # echo "Enter Rule 2"

    while [ "$res" != "Yes" ]
    do
        apple_text "RULE 2 PRAYER. \nHIS HELP. HIS POWER. HIS KNOWLEDGE.\nGOD LOVES US.\nWhat did you pray?"
    done


    echo "RULE 2 pass."
TRY








<< "FUNC"

apple_dialog(){
    echo $1
    $(osascript -e 'display dialog {$1}" buttons {"Yes", "No"} default button "No"')
}

apple_dialog

FUNC

<< "BRUTE"

sec=$SECONDS
while [ $SECONDS -lt 3 ]
do
    
    if [ $sec -ne $SECONDS ]
    then
        sec=$SECONDS
        echo $SECONDS
    fi
done
# apple_dialog test
SURETY="$(osascript -e 'display dialog 
"RULE 1 DO NOT BE OBSESSED. 
 
RULE 2 PRAYER. 
HIS HELP. HIS POWER. HIS KNOWLEDGE.
GOD LOVES US.
 
RULE 3 TESTCASES 
 
RULE 4 STOP & REST 
STOP & REST WHEN OBSESSED. STOP WHEN YOU ARE OBSESSED.  I REPEAT AGAIN. STOP WHEN YOU GET OBSESSED.  
 
RULE 5 PSEUDOCODE 
 
RULE 6 INITIALIZATION 
 
RULE 7 KEEP IT SIMPLE, YOU STUPID!
IT’S A KISS.
EASIER, SIMPLER, AND MORE LIKELY BRUTEFORCE THEN YOU THOUGHT"

 buttons {"Yes", "No"} default button "No"')"

if [ "$SURETY" = "button returned:Yes" ]; then
    echo "Yes, continue with partition."
    rule="($(osascript -e 'display dialog "RULE 1 DO NOT BE OBSESSED. " default answer "" buttons {"Yes", "No"} default button "No"'))"

    while [ $rule -ne "button returned:Yes, text returned:DO NOT BE OBSESSED." ]
        do
            echo $rule
            rule="($(osascript -e 'display dialog "RULE 1 DO NOT BE OBSESSED. " default answer "" buttons {"Yes", "No"} default button "No"'))"
        done

    echo "RULE 1 pass."
    if [ "$SURETY" = "button returned:Yes" ]; then
    echo "Yes, continue with partition."
    rule="($(osascript -e 'display dialog "RULE 1 DO NOT BE OBSESSED. " default answer "" buttons {"Yes", "No"} default button "No"'))"

    while [ $rule -ne "button returned:Yes, text returned:DO NOT BE OBSESSED." ]
        do
            echo $rule
            rule="($(osascript -e 'display dialog "RULE 1 DO NOT BE OBSESSED. " default answer "" buttons {"Yes", "No"} default button "No"'))"
        done

    echo "RULE 1 pass."
    fi

    
    



else
    echo "No, cancel partition."
fi
BRUTE

# while [ $(( SECONDS%3600 )) -eq 0 ]
# do
#     while [ $(( SECONDS%10 )) -eq 0 ]
#     do
#         echo $SECONDS
#     done
#     SURETY="$(osascript -e 'display dialog "RULE 1 DO NOT BE OBSESSED. 
#  
#     RULE 2 PRAYER. 
#     HIS HELP. HIS POWER. HIS KNOWLEDGE.
#     GOD LOVES US.
#      
#     RULE 3 TESTCASES 
#      
#     RULE 4 STOP & REST 
#     STOP & REST WHEN OBSESSED. STOP WHEN YOU ARE OBSESSED.  I REPEAT AGAIN. STOP WHEN YOU GET OBSESSED.  
#      
#     RULE 5 PSEUDOCODE 
#      
#     RULE 6 INITIALIZATION 
#      
#     RULE 7 KEEP IT SIMPLE, YOU STUPID!
#     IT’S A KISS.
#     EASIER, SIMPLER, AND MORE LIKELY BRUTEFORCE THEN YOU THOUGHT" buttons {"Yes", "No"} default button "No"')"

#     if [ "$SURETY" = "button returned:Yes" ]; then
#         echo "Yes, continue with partition."
#     else
#         echo "No, cancel partition."
#     fi
# done


<< 'DIALOG'

SURETY="$(osascript -e 'display dialog "RULE 1 DO NOT BE OBSESSED. 
 
RULE 2 PRAYER. 
HIS HELP. HIS POWER. HIS KNOWLEDGE.
GOD LOVES US.
 
RULE 3 TESTCASES 
 
RULE 4 STOP & REST 
STOP & REST WHEN OBSESSED. STOP WHEN YOU ARE OBSESSED.  I REPEAT AGAIN. STOP WHEN YOU GET OBSESSED.  
 
RULE 5 PSEUDOCODE 
 
RULE 6 INITIALIZATION 
 
RULE 7 KEEP IT SIMPLE, YOU STUPID!
IT’S A KISS.
EASIER, SIMPLER, AND MORE LIKELY BRUTEFORCE THEN YOU THOUGHT" buttons {"Yes", "No"} default button "No"')"

if [ "$SURETY" = "button returned:Yes" ]; then
    echo "Yes, continue with partition."
else
    echo "No, cancel partition."
fi

DIALOG


