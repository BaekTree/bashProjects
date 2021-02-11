
source /Users/baek/project/bashProjects/codeRepentGradient/dir.sh

declare imgList
declare -a imgListArr

log(){
    if [[ $log == "-l" ]]
    then
        echo -e "$1"
    fi
}
updateImgList(){
    imgListArr="$1"

    local curDir=$(pwd)
    log "[updateVerses] : move to bible dir"
    cd "$IMG_DIR"
    log "[updateVerses] : pwd: $(pwd)"

    local imgList=$(ls)
    imgListArr=($imgList)

    log "[updateVerses] : back to cur dir : $curDir"
    cd ${curDir}
}

getRandImgIdx(){
    local imgListArr=("$@")
    local imgIdx=$(( $RANDOM % ${#imgListArr[@]} ))
    echo "$imgIdx"

}

showImg(){
    # closePreview

    local imgIdx="$(getRandImgIdx "${imgListArr[@]}")"
    log "[showImg] opening ${imgListArr[${imgIdx}]}"
    open -a Preview "$IMG_DIR/${imgListArr[${imgIdx}]}";
    sleep 0.5
    movePreview
}

movePreview(){
    getPreviewPid
    if [ ! -z $pids ]
    then
        priorIFS="$IFS"
        IFS=", "
        # expected output : "0, 0, 1792, 1120"
        local disRsl=$(osascript -e 'tell application "Finder" to get bounds of window of desktop')

        local -a disRslArr=($disRsl) # idx 2 : width, dix 3 : height
        
        # test
        # echo "${disRslArr[*]}"

        # for ((i=0; i <${#disRslArr[@]}; i++ ))
        # do
        #     echo "$i : ${disRslArr[$i]}"
        # done


        local w=${disRslArr[2]}
        local h=${disRslArr[3]}
        # echo $w $h
        local startPosition=$(( w / 2 ))
        # echo $startPosition
        osascript -e "tell application \"Preview\"
        set bounds of front window to { $startPosition, 0, $w, $h }
        end tell" # {left edge position l, top edge position t, right edge position r, bottom position y}

        #  l
        # to---or
        #  |   |
        #  o---oy
        IFS="$priorIFS"
    fi  
    
}

getPreviewPid(){
    pids=$(pgrep Preview)   
}

closePreview(){
    if [ -z $pids ]
    then
        log "[closeVerse] : no pids"
    else
        log "[closeVerse] : preview pids : ${pids}"
        log "[closeVerse] : killing preview $pids"
        kill -9 ${pids}
        sleep 0.5
    fi
}