#! /usr/local/bin/bash

# # exit when any command fails
# set -e


source dir.sh
printUsage(){
    local name="$1"
    echo "usage : ./$name.sh"
    echo "option : \n\t -d\n\t -f\n\t -l"
    echo "option -d : "
    echo "\t -d getRules : run only getRules function."
    echo "\t -d all : run getRules and startValueReminder, but not call hideAll and wait functions."
    echo "option -df : erase all limit and ans "
    echo "option -f : "
    echo "\t -f rules.txt : specific file data in data directory."
    echo "option -l : enable log."
}

parseArg(){
    local args=("$@")
    local name="${args[0]}"

    # local -n debug
    # local -n dFunc
    # local -n arg_file
    # local -n dFile
    # local -n log

    local tmp_i
    for (( t_arg_i=1; t_arg_i < ${#args[@]}; t_arg_i++ ))
    do
    if [[ ${args[$t_arg_i]} = "-d" ]] || [[ ${args[$t_arg_i]} = "-df" ]]
        then
            debug=${args[$t_arg_i]}
            tmp_i=$(( $t_arg_i + 1 ))
            dFunc=${args[$tmp_i]}
            (( t_arg_i++ ))
        elif [[ ${args[$t_arg_i]} = "-f" ]]
        then
            arg_file=${args[$t_arg_i]}
            tmp_i=$(( $t_arg_i + 1 ))
            dFile=${args[$tmp_i]}
            (( t_arg_i++ ))
        elif [[ ${args[$t_arg_i]} = "-l" ]]
        then
            log=${args[$t_arg_i]}
        else
            echo "You entered <${args[$t_arg_i]}>. What did you mean?"
            printUsage "$name"
            exit 0
        fi
    done
}

scrpt_name=$0

args=($@)

parseArg "$scrpt_name" "${args[@]}"


# debug=${args[1]}
# dFunc=${args[2]} # debug로 실행할 함수 : getRules만 지원
# arg_file=${args[3]} # 읽을 rules 파일
# dFile=${args[4]}



# if [[ $scrpt_name = *"_up"* ]] || [[ $scrpt_name = *"main.sh"* ]]
# then
    # echo "This is in dev!"
source $DIR/function_up.sh
    # file="$DATA_DIR/rules_up_only_kor.txt"
# else
    # source $DIR/stable/function.sh
    # file="$DATA_DIR/rules_up_only_kor.txt"
# fi



if [ $arg_file = "-f" -a ! -z $dFile ]
then
    dir_chk=$(ls $DATA_DIR/$dFile)
    if [ "$dir_chk" != "$DATA_DIR/$dFile" ]
    then
        echo -e "no file exists named $DATA_DIR/$dFile" 
        exit 0
    fi
    file="$DATA_DIR/$dFile"
else
    printUsage
    exit 0
fi
    

declare -a ruleArr=()
declare -a contArr=()
declare -a ansArr=()
declare -a limitArr=()
declare -a completeArr=()
declare -a msgArr=()
declare -a uniqueRuleIdxArr=()

allArr=( ruleArr contArr ansArr limitArr completeArr)
lenAllArr=${#allArr[@]}

source ./getValuesFunc.sh


echo -e "$(date +%a) $(date +%b) $(date +%d) $(date +"%H:%M") $(date +%Y)" 
if [ -z $debug ] # debug 아닐 때. 모두 실행
then
    hideAll
    getRules
    clear
    startValueReminder
else # debug 일때
    echo "|----------------------------------------------------------------------------------------------------------------------|"
    echo "|                                                                                                                      |"
    echo "|                                           WELCOME TO CODE REPENT GRADIENT!                                           |"
    echo "|                                                                                                                      |"
    echo "|----------------------------------------------------------------------------------------------------------------------|"

    if [ $dFunc == "all" ]
    then
        echo "run all with debug"
        getRules # getRules 실행
        startValueReminder
    elif [ $dFunc == "getRules" ] 
    then
        echo "run only getRules"
        getRules
    else
        printUsage
    fi
fi
