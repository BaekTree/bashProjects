
source ./dir.sh

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
        osascript -e "tell application \"Preview\"
        set bounds of front window to {768, 0, 1536, 960}
        end tell"
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