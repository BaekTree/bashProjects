<< "parseArg"
    parseArg.sh

    input argument : script_name, input_arguments
    output argument : debug, dFunc, arg_file, dFile, log, baseSecArg
parseArg


printUsage(){
    local name="$1"
    echo "usage : $name -f <file_name>"
    echo "option : \n\t -d\n\t -f\n\t -l"
    echo "option -d : "
    echo "\t -d getRules : run only getRules function."
    echo "\t -d all : run getRules and startValueReminder, but not call hideAll and wait functions."
    echo "option -df : erase all limit and ans "
    echo "option -l : enable log."
    echo "option -t : "
    echo "\t -t <seconds> : use in iterator.sh"
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
        elif [[ ${args[$t_arg_i]} = "-t" ]]
        then
            # arg_sec=${args[$t_arg_i]}
            (( t_arg_i++ ))
            baseSecArg=${args[$t_arg_i]}
        elif [[ ${args[$t_arg_i]} = "-l" ]]
        then
            log=${args[$t_arg_i]}
        else
            echo "You entered <${args[$t_arg_i]}>. What did you mean?"
            printUsage "$name"
            exit 0
        fi
    done

    if [[ ! -z $arg_file ]] && [[ $arg_file = "-f" ]] && [[ ! -z $dFile ]]
    then
        local dir_chk=$(ls $DATA_DIR/$dFile)
        if [ "$dir_chk" != "$DATA_DIR/$dFile" ]
        then
            echo -e "no file exists named $DATA_DIR/$dFile" 
            exit 0
        fi
        file="$DATA_DIR/$dFile"
    else
        printUsage "$name"
        exit 0
    fi

    if [ -z $baseSecArg ]
    then
        baseSec=4500
    elif [[ ! $baseSecArg =~ ^[0-9]*$ ]]; then 
        echo -e "usage : iterator_up.sh -t <seconds>\n\tseconds here is the base seconds. \n\tThe shell adds random seconds 1/4 of the base seconds"
        exit 0
    else
        baseSec=$baseSecArg
    fi
    
}