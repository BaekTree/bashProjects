#! /usr/local/bin/bash

# # exit when any command fails
# set -e
source dir.sh
# DIR=/Users/baek/project/bashProjects/codeRepentGradient

args=($@)

# debug=${args[1]}
# dFunc=${args[2]} # debug로 실행할 함수 : getRules만 지원
# arg_file=${args[3]} # 읽을 rules 파일
# dFile=${args[4]}

printUsage(){
    echo -e "usage : ./main.sh"
    echo -e "option : \n\t -d\n\t -f\n\t -l"
    echo -e "option -d : "
    echo -e "\t -d getRules : run only getRules function."
    echo -e "\t -d all : run getRules and init, but not call hideAll and wait functions."
    echo -e "option -df : erase all limit and ans "
    echo -e "option -f : "
    echo -e "\t -f rules.txt : specific file data in data directory."
    echo -e "option -l : enable log."
}

for (( t_arg_i=0; t_arg_i < ${#args[@]}; t_arg_i++ ))
do
if [[ ${args[$t_arg_i]} = "-d" ]] || [ ${args[$t_arg_i]} = "-df" ]
    then
        debug=${args[$t_arg_i]}
        tmp_i=$(( $t_arg_i + 1 ))
        dFunc=${args[$tmp_i]}
        (( t_arg_i++ ))
    elif [ ${args[$t_arg_i]} = "-f" ]
    then
        arg_file=${args[$t_arg_i]}
        tmp_i=$(( $t_arg_i + 1 ))
        dFile=${args[$tmp_i]}
        (( t_arg_i++ ))
    elif [ ${args[$t_arg_i]} = "-l" ]
    then
        log=${args[$t_arg_i]}
    else
        echo "You entered ${args[$t_arg_i]}. What did you mean?"
        printUsage 
        exit 0
    fi
done




scrpt_name=$0
if [[ $scrpt_name = *"_up"* ]] || [[ $scrpt_name = *"main.sh"* ]]
then
    echo "This is in dev!"
    source $DIR/function_up.sh
    file="$DATA_DIR/rules_up.txt"
else
    source $DIR/stable/function.sh
    file="$DATA_DIR/rules.txt"
fi

echo -e "\n\n\n\n$(date +%a) $(date +%b) $(date +%d) $(date +"%H:%M") $(date +%Y)" 


<< "DEBUG"

DEBUG


if [ ! -z $arg_file ]
then
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
fi

if [ -z $debug ] # debug 아닐 때. 모두 실행
then
    clear
    hideAll
    getRules
    init
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
        init
    elif [ $dFunc == "getRules" ] 
    then
        echo "run only getRules"
        getRules
    else
        printUsage
    fi
fi
