#! /usr/local/bin/bash

# # exit when any command fails
# set -e


source dir.sh
source parseArg.sh

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
        # printArrs
    else
        printUsage
    fi
fi
