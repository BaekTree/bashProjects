
source /Users/baek/project/bashProjects/codeRepentGradient/dir.sh
# source /Users/baek/project/bashProjects/codeRepentGradient/log.sh

IMAGE_LOG=1

imgToggle=1

imgLog(){
    if [[ $IMAGE_LOG == 1 ]]
    then
        echo -e "$1"
    fi
}

declare imgList
declare -a imgListArr


updateImgList(){
    imgListArr="$1"

    local curDir=$(pwd)
    imgLog "[updateVerses] : move to bible dir"
    cd "$IMG_DIR"
    imgLog "[updateVerses] : pwd: $(pwd)"

    local imgList=$(ls)
    imgListArr=($imgList)

    imgLog "[updateVerses] : back to cur dir : $curDir"
    cd ${curDir}
}

getRandImgIdx(){
    local imgListArr=("$@")
    # echo $imgListArr
    local imgIdx=$(( $RANDOM % ${#imgListArr[@]} ))
    echo "$imgIdx" # return
    # imgLog "[getRandImgIdx] : ${imgIdx}"

}

toggleImg(){
    if [[ $imgToggle == 1 ]]
    then
        imgToggle=0

        closePreview
    else
        imgToggle=1
        showImg
    fi
}

showImg(){
    if [[ $imgToggle == 1 ]]
    then
        # closePreview
        # getPreviewPid
        # echo "$pids"

        # sample : open -a Preview /Users/baek/OneDrive/사진/삼성\ 갤러리/Pictures/Bible/1608648596555.png

        local imgIdx="$(getRandImgIdx "${imgListArr[@]}")"
        imgLog "[showImg] opening ${imgListArr[${imgIdx}]}"
        # osascript -e "tell application \"Finder\" to open \"$IMG_DIR/${imgListArr[${imgIdx}]}\"";
        open -a Preview "$IMG_DIR/${imgListArr[${imgIdx}]}";
        sleep 0.5
        movePreview
    fi
}

movePreview(){
    local pids="$(getPreviewPid)"
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
    local pids=$(pgrep Preview)   
    echo $pids
}

closePreview(){
    

    local pids="$(getPreviewPid)"
    # sleep 1
    if [ ! -z $pids ]
    then
        pkill Preview
    #     imgLog "[closeVerse] : no pids"
    # else
    #     imgLog "[closeVerse] : preview pids : ${pids}"
    #     imgLog "[closeVerse] : killing preview $pids"
    #     kill -9 ${pids}
    #     sleep 0.5
    fi
}