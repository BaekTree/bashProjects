#! /usr/local/bin/bash
# read $1
# echo input : $1

# # exit when any command fails
# set -e

DIR=/Users/baek/project/bashProjects/codeRepentGradient

args=($@)

arg_sec=${args[0]}
# debug=${args[1]}
# dFunc=${args[2]} # debug로 실행할 함수 : getRules만 지원
# arg_file=${args[3]} # 읽을 rules 파일
# dFile=${args[4]}

for (( t_arg_i=0; t_arg_i < ${#args[@]}; t_arg_i++ ))
do
    if [ ${args[$t_arg_i]} = "-d" ]
    then
        debug="-d"
        tmp_i=$(( $t_arg_i + 1 ))
        dFunc=${args[$tmp_i]}
    elif [ ${args[$t_arg_i]} = "-f" ]
    then
        arg_file="-f"
        tmp_i=$(( $t_arg_i + 1 ))
        dFile=${args[$tmp_i]}
    fi
done

# echo $debug
# echo $dFunc
# echo $arg_file
# echo $dFile

# exit 0


if [ -z $arg_sec ]
then
    arg_sec=5
fi


if [[ ! $arg_sec =~ ^[0-9]*$ ]]; then 
    # init $1 seconds!
    echo -e "usage : ./timer_up.sh <seconds>.\noption : -d for debug."
    exit 0
# else
fi



if [ $debug != "-d" ]
then
    echo -e "usage : ./timer_up.sh <seconds>.\noption : -d for debug"
    exit 0
fi
# ascriptComm=osascript -e "display dialog \"$1\" with title \"Code Repent Gradient\" buttons {\"Yes\", \"No\"} default button \"No\""



curFile=$0
if [[ $curFile = *"_up"* ]]
then
    echo "This is in dev!"
    source function_up.sh
    file="$DIR/data/rules_up.txt"
else
    source function.sh
    file="$DIR/data/rules.txt"
fi

echo -e "\n\n\n\n$(date +%a) $(date +%b) $(date +%d) $(date +"%H:%M") $(date +%Y)" 


<< "DEBUG"
    테스트케이스
    -d을 누른다.
        clear, wait, hide을 실행하지 않는다.
    그 뒤로 아무것도 명시하지 않으면 그대로 진행.
    만약에 파일이름을 추가로 명시했다면 해당 파일을 연다. 찾을 수 없으면 에러를 내고 종료.
    만약에 함수이름을 명시했다면 해당 함수만 실행. 틀린 것을 넣으면 에어를 내고 종료.

    파일이름 없이 함수이름을 넣었다면? 
        그럼 파일 이름으로 받은 argument가 함수 이름인지 확인해야 한다... 그냥 둘


    getRules만 명시했다.
        기본 함수들을 실행하지 않고 getRules만 실행한다. init도 실행하지 않는다.
    명시가 없다.
        기본함수만 실행하지 않고 모두 실행

    d을 누르지 않는다.
    모든 함수를 다 실행
DEBUG


if [ ! -z $arg_file ]
then
    if [ $arg_file = "-f" -a ! -z $dFile ]
    then
        dir_chk=$(ls $DIR/data/$dFile)
        if [ "$dir_chk" != "$DIR/data/$dFile" ]
        then
            echo -e "no file exists named $DIR/data/$dFile" 
            exit 0
        fi
        file="$DIR/data/$dFile"
    else
        echo -e "usage : ./timer_up.sh <seconds>.\noption : \n-f specific files to get."
        exit 0
    fi
fi

if [ -z $debug ] # debug 아닐 때. 모두 실행
then
    clear
    wait $arg_sec
    hideAll
    getRules
    init
else # debug 일때
    if [ $dFunc == "all" ]
    then
        echo "run all with debug"
        getRules # getRules 실행
        init
    elif [ $dFunc == "getRules" ] 
    then
        echo "run only getRules"
        getRules
    else
        echo -e "usage : ./timer_up.sh <seconds>.\noption : \n-d getRules for run only getRules.\n-d all for run all with log and without hide and wait feature."
    fi
fi












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


