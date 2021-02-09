#! /usr/local/bin/bash
# read $1
# echo input : $1

arg=$1

if [ -z $1 ]
then
    arg=5
fi


if [[ ! $1 =~ ^[0-9]*$ ]]; then 
    # init $1 seconds!
    echo -e "usage : ./timer_up.sh <seconds>.\noption : -d for debug."
    exit 0
# else
fi

debug=$2
dWhich=$3

if [ $debug != "-d" -a $debug != "-t" ]
then
    echo -e "usage : ./timer_up.sh <seconds>.\noption : -d for debug, -t for test\n-d : use rulesTest.txt\n-t : use rules_up.txt"
    exit 0
fi
# ascriptComm=osascript -e "display dialog \"$1\" with title \"Code Repent Gradient\" buttons {\"Yes\", \"No\"} default button \"No\""



curFile=$0
if [[ $curFile = *"_up"* ]]
then
    echo "This is in dev!"
    source /Users/baek/project/bashProjects/codeRepentGradient/testing/function_up.sh
else
    source /Users/baek/project/bashProjects/codeRepentGradient/stable/function.sh
fi














<< "START"

START




echo -e "\n\n\n\n$(date +%a) $(date +%b) $(date +%d) $(date +"%H:%M") $(date +%Y)" 


<< "DEBUG"
    테스트케이스
    -d을 누른다
        clear, wait, hide을 실행하지 않는다.
    getRules만 명시했다.
        기본 함수들을 실행하지 않고 getRules만 실행한다. init도 실행하지 않는다.
    명시가 없다.
        기본함수만 실행하지 않고 모두 실행

    d을 누르지 않는다.
    모든 함수를 다 실행
DEBUG

if [ -z $debug ] # debug 아닐 때. 모두 실행
then
    clear
    wait $arg
    hideAll
    getRules
    init
else # bebug 일때
    getRules # getRules 실행
    if [ -z $dWhich ] # dWhich가 없으면 기본함수만 제외하고 모두 실행
    then
        init
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


