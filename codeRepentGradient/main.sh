#! /usr/local/bin/bash

# # exit when any command fails
# set -e

DIR=/Users/baek/project/bashProjects/codeRepentGradient

args=($@)

arg_sec=${args[0]}
# debug=${args[1]}
# dFunc=${args[2]} # debug로 실행할 함수 : getRules만 지원
# arg_file=${args[3]} # 읽을 rules 파일
# dFile=${args[4]}

printUsage(){
    echo -e "usage : ./timer_up.sh <seconds>. without argument, default is 5 secs."
    echo -e "option : \n\t -d\n\t -f\n\t -l"
    echo -e "option -d : "
    echo -e "\t -d getRules : run only getRules function."
    echo -e "\t -d all : run getRules and init, but not call hideAll and wait functions."
    echo -e "option -f : "
    echo -e "\t -f rules.txt : specific file data in data directory."
    echo -e "option -l : enable log."
}

for (( t_arg_i=1; t_arg_i < ${#args[@]}; t_arg_i++ ))
do
    if [ ${args[$t_arg_i]} = "-d" ]
    then
        debug="-d"
        tmp_i=$(( $t_arg_i + 1 ))
        dFunc=${args[$tmp_i]}
        (( t_arg_i++ ))
    elif [ ${args[$t_arg_i]} = "-f" ]
    then
        arg_file="-f"
        tmp_i=$(( $t_arg_i + 1 ))
        dFile=${args[$tmp_i]}
        (( t_arg_i++ ))
    elif [ ${args[$t_arg_i]} = "-l" ]
    then
        log="-l"
    else
        echo "You entered ${args[$t_arg_i]}. What did you mean?"
        printUsage 
        exit 0
    fi
done

if [ -z $arg_sec ]
then
    arg_sec=5
fi


if [[ ! $arg_sec =~ ^[0-9]*$ ]]; then 
    printUsage
    exit 0
fi

scrpt_name=$0
if [[ $scrpt_name = *"_up"* ]] || [[ $scrpt_name = *"main.sh"* ]]
then
    echo "This is in dev!"
    source $DIR/function_up.sh
    file="$DIR/data/rules_up.txt"
else
    source $DIR/stable/function.sh
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
        printUsage
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
        printUsage
    fi
fi
