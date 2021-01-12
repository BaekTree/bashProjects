#! /bin/bash



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
    updateVerses
    idxV=$(( $RANDOM % ${#vArr[@]} ))
}

viewVerse(){
    genVerseIDx
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
    closeVerse
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



: << "INIT"
    init main function
INIT


init(){
    clear
    updateVerses
    echo ${numV} verses exist.

    hideAll

    IFS=$'\n'
    # str2='RULE 1 DO NOT BE OBSESSED.\n \nRULE 2 PRAYER. \nHIS HELP. HIS POWER. HIS KNOWLEDGE.\nGOD LOVES US.\n \nRULE 3 STOP & REST \nSTOP & REST WHEN OBSESSED. STOP WHEN YOU ARE OBSESSED.  I REPEAT AGAIN. STOP WHEN YOU GET OBSESSED.  \n  \nRULE 4 TESTCASES \n \nRULE 5 PSEUDOCODE \n \nRULE 6 INITIALIZATION \n \nRULE 7 KEEP IT SIMPLE, YOU STUPID!\nIT’S A KISS.\nEASIER, SIMPLER, AND MORE LIKELY BRUTEFORCE THEN YOU THOUGHT'

    rule1="RULE 1 GOD LOVES US."    
    rule2="RULE 2 PRAYER."
    rule3="RULE 3 STOP AND REST"    
    rule4="WHAT IS YOUR EMOTION NOW?"
    rule5="RULE 5 MEMO VERSES"
    rule6="RULE 6 TESTCASES."
    rule7="RULE 7 KEEP IT SIMPLE, YOU STUPID!"
    rule8="RULE 5 PSEUDOCODE "
    rule9="RULE 6 INITIALIZATION"

    ans1="GOD LOVES US."

    cont1="DO NOT BE OBSESSED.\NPLEASE TYPE ${ans1}\n\nDO NOT FORGET CPAS LOCK.\nDO NOT FORGET PERIOD."
    cont2="HIS HELP. HIS POWER. HIS KNOWLEDGE.\nGOD LOVES US.\n\nTYPE PRAYER REEQUEST NOW.\n\nPLEASE TYPE MORE THAN 20 CHARS"
    cont3="STOP AND REST WHEN OBSESSED.\nSTOP WHEN YOU ARE OBSESSED.\n\nI REPEAT AGAIN.\nSTOP WHEN YOU GET OBSESSED.\n\nARE YOU OBSESSED?"  
    cont4=" "
    cont5="GIMME A MEMEO AMONG THE VERSES THAT YOU SAW\n"
    cont6=" "
    cont7="IT’S A KISS.\nEASIER, SIMPLER, AND MORE LIKELY BRUTEFORCE THEN YOU THOUGHT"
    cont8=" "
    cont9=" "



    warn="\nGOD LOVES YOU\nJesus has secrificed himself for you\n\n\n\n\n"



    priorIFS=$IFS
    IFS=$'\n'
    for (( i=0; i<9; i++))
    do
        idxR=$(( $i+1 ))
        # echo $idxR
        r=rule$idxR
        c=cont$idxR
        # echo ${!r}

        rules+=${!r}"\n\n\n"
        # conts+=${!c}
        ruleArr+=(${!r})
        contArr+=(${!c})
    done
    IFS=$priorIFS
    # echo $str
    # echo
    # echo $str2
    # echo
    apple_dialog $rules


    while [ "$ans" = "No" ]
    do
        apple_dialog "GOD LOVES YOU\nJesus has secrificed himself for you\n\n\n\n\n"${str}
    done




    echo "Enter Rule 1"
    apple_text ${rule1}${cont1}
    # open -a Preview '/Users/baek/OneDrive/사진/삼성 갤러리/Pictures/Bible/1585813311117.png'
    echo $ans
    echo $msg
    while [ "$ans" = "No" -o "$msg" != "$ans1" ]
    do
        apple_text "GOD LOVES YOU\nJesus has secrificed himself for you\n\n\n\n\n"${rule1}
    done







    # record "\n\n\n\n\n\n\n-"

    # append time and msg
    record "$(date +%a) $(date +%b) $(date +%d) $(date +"%H:%M") $(date +%Y) "



    # for (( i=1; i<9; i++ ))
    # do
    #     idx=$(( $i + 1 ))
    #     echo -e "\n\n\nEnter Rule ${idx}"
    #     echo -e "${ruleArr[${idx}]}${contArr[${idx}]}"
    #     # r=rule${idx}
    #     # c=cont${idx}
    #     # echo "################################${r} ${c}"
    #     # echo -e "${!r}\n${!c}"
    #     apple_text "${rule[${idx}]}\n${cont[${idx}]}"
    #     record $ans
    #     record $msg
    #     limit=10
    #     while [ "$ans" = "No" -o ${#msg} -lt ${limit} ]
    #     do
    #         alertUpdate $msg $limit
    #         apple_text ${alrt}${warn}${rule2}
    #     done

    #     record $msg
    # done


    echo "Enter Rule 2"
    apple_text "${rule2}\n${cont2}"
    record $ans
    record $msg
    limit=20
    while [ "$ans" = "No" -o ${#msg} -lt ${limit} ]
    do
        alertUpdate $msg $limit
        apple_text ${alrt}${warn}${rule2}
    done

    record $msg






    echo "Enter Rule 3"
    apple_text "${rule3}\n${cont3}"
    record $ans
    record $msg
    limit=10
    while [ "$ans" = "No" -o ${#msg} -lt 10 ]
    do
        alertUpdate $msg $limit
        apple_text ${alrt}${warn}${rule3}
    done

    record "ARE YOU OBSESSED? ${msg}"








    echo "Enter Question"
    apple_text "${rule4}\n${cont4}"
    record $ans
    record $msg
    limit=10
    while [ "$ans" = "No" -o ${#msg} -lt 10 ]
    do
        alertUpdate $msg $limit
        apple_text ${alrt}${warn}${rule4}
    done

    record echo $msg




    echo "Enter Rule 5"
    # echo "Enter Question"
    apple_text "${rule5}\n${cont5}"
    record $ans
    record $msg
    limit=10
    while [ "$ans" = "No" -o ${#msg} -lt 10 ]
    do
        alertUpdate $msg $limit
        apple_text ${alrt}${warn}${rule5}\n${cont5}
    done

    record echo $msg






    closeVerse
}



















<< "START"

START

echo -e "\n\n\n\n$(date +%a) $(date +%b) $(date +%d) $(date +"%H:%M") $(date +%Y)" 

<< "WAIT"

WAIT


baseMin=60
base=$(( $baseMin * 60 ))
var=$(( base / 4 ))

# variance test
limitT=$(( $base + $RANDOM % $var )) 
# echo "wait ${limitT} seconds"

mins=$(( $limitT / 60 ))
# echo $mins
hours=$(( ${mins} / 60 ))

mins=$(( $mins - $hours * 60 ))
sec=$(( $limitT - $hours * 3600 - $mins * 60 ))

echo $hours:$mins:$sec left

leftOver=$(( limitT % 3600 ))
sleep $leftOver




while [ hours -gt 1 ]
do
    echo $hours left
    sleep 3600
    $(( hours-- ))
done

arr(30 20 5 4)

echo 60 mins left

for (( i=0; i<${#arr[@]}; i++ ))
do
    
done


<< "TIME"
30분 뒤
10분 뒤
5분 뒤
1분 뒤
30 초 뒤
10초 부터 카운트

단위는 모두 초 이다.
mins * 60을 하면 초가 된다.

limitT - 30분을 남긴 시간 까지 잠을 잔다.
30분 남은 시간까지 계산.
limitT - 30 * 60
limitT - 10 * 60
militT - 5 * 60
limitT - 60
limitT - 30
limitT - 10

로직 생각을 잘못했다. 이렇게 하면 계속 누적되어서 기다리게 된다...

처음에 주어지는 수에서...
1시간 넘어지는 초까지 자른다.
1시간이 딱 맞도록 남은 시간 만큼 sleep 한다.
그리고... 30분을 sleep
그리고 20분을 sleep 해서 10분이 남도록 맞춘다
그리고 5분 sleep
4 분 sleep
30초 sleep
20초 sleep
10초부터 1초 단위로 카운트


그러면 주어진 수에서... 3600까지 잘라야 한다. 랜덤 단위의 수 base에 접근하기까지 차이를 그냥 sleep한다.
base에 접근하고 나서 1시간, 30분, 10분, 5분, 1분, 30초, 10초까지 고정으로 자른다.

그런데 고정에서 0인 것도 확인을 해야 한다.

base까지 자르고 나서 0으로 나눠서 값이 0이 나오면 감당 안되는 상태. pass한다.
0이 아니라 값이 나오면...? 

diff=limitT - 3600
sleep diff
echo 1 hour left

sleep 30 mins
echo 30 mins left

sleep 20 mins
echo 10 mins left

slee 5 mins
echo 5 mins left

sleep 4 mins 
echo 60 secs left

sleep 30 secs
echo 30 secs left

sleep 20 secs
echo 10 secs left





base 시간이 1시간을 초과하는가?
    1시간까지 시간 단위로 표시

    
    fewHours=limitT / 3600
    if fewHours > 0

        leftOver=limitT % 3600
        sleep leftOver
        
        while fewHours > 1
            echo fewHours left
            sleep 3600
            fewHours --
    



그 다음부터 분 단위로 표시

time=60
sum=0
arr=(30 20 5 4)
for i = 1 to arr.length
    sleep arr[i] * 60
    (time - sum) mins left
    sum += arr[i]

초 단위
arr(30 20)

10초


TIME






<< 'TRY1'

diff=$(( $limitT - $base ))
echo $diff minus
sleep $diff
echo 1 hour left

sleep $(( 30 * 60 ))
echo 30  mins left

sleep $(( 20 * 60 ))
echo 10  mins left

sleep $(( 5 * 60 ))
echo 5  mins left

sleep $(( 4  * 60 ))
echo 1 mins left

sleep 30
echo 30 secs left

sleep 20
echo 10 secs left

fin=$(( $SECONDS + 10 ))
sec=$SECONDS
while [ $SECONDS -lt $fin ]
do
    if [ $sec -ne $SECONDS ]
    then
        sec=$SECONDS
        echo "$(( ${fin} - ${SECONDS} )) secs left."
    fi
done
TRY1

# arr=(30 10 5 1)

# for (( i=0; i<${#arr[@]}; i++ ))
# do
#     t=$(( $limitT - ${arr[i]} * 60 ))
#     if [ $t -gt 0 ]
#     then
#         sleep $t
#         echo ${arr[${i}]} mins left.

#     fi

# done


# sleep $(( $limitT - 30 * 60 ))
# echo 30 mins left
# sleep $(( $limitT - 10 * 60 ))
# echo 10 mins left
# sleep $(( $limitT - 5 * 60 ))
# echo 5 mins left
# sleep $(( $limitT - 60 ))
# echo  60 secs left
# sleep $(( $limitT - 30 ))
# echo  30 secs left


# for (( i=10; i>0; i-- ))
# do
#     sleep $(( $limitT - 10 ))
#     echo 10 secs left
# done





# sleep ${limitT}


# limitT=$(( 100 + $RANDOM % 120 )) 
# echo "wait ${limitT} limitT"
# sleep 60
# sleep ${limitT}
# echo awake!

# sec=$SECONDS
# limitM=$(( $limitT / 60 ))
# # mins=0
# while [ $SECONDS -lt $limitT ]
# do
#     # mins=$(( $SECONDS / 60 ))
#     # if [ $mins -ge $(( $limitM - 5 )) ]
#     # then
#     #     if [ $mins -ne $(( $SECONDS / 60 )) ]
#     #     then
#     #         echo "$(( ${limitM} - ${mins} )) mins left."
#     #     fi

#     # fi

#     if [ $SECONDS -ge $(( $limitT - 60 )) ]
#     then
#         if [ $sec -ne $SECONDS ]
#         then
#             sec=$SECONDS
#             echo "$(( ${limitT} - ${SECONDS} )) secs left."
#         fi
#     fi
# done


init





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


