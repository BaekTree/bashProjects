
IMAGE_DIR='/Users/baek/OneDrive/사진/삼성 갤러리/Pictures/Bible'

updateImageList(){
    curDir=$(pwd)
    debugPrint "[updateImageList] : move to bible dir"
    cd "$IMAGE_DIR"
    debugPrint "[updateImageList] : pwd: $(pwd)"

    local imageList=$(ls)
    local limageArr=($imageList)

    # numImage=${#imageArr[@]}

    debugPrint "[updateImageList] : back to cur dir : $curDir"
    cd ${curDir}
    echo "$imageArr"
}

getRandImgIdx(){
    local imgArr=($@)
    local imageIdx=$(( $RANDOM % ${#imgArr[@]} ))
    echo "$imageIdx"
}

showImage(){
    # closeVerse
    local imgArr=($@)
    local imgIdx=$(getRandImgIdx "$imgArr")
    # debugPrint "[showImage] opening ${imageArr[${imageIdx}]}"
    open -a Preview "/Users/baek/OneDrive/사진/삼성 갤러리/Pictures/Bible/${imageArr[${imageIdx}]}";
    $(sleep 1 || debugPrint 1 passed!) &
    osascript -e "tell application \"Preview\"
	set bounds of front window to {768, 0, 1536, 960}
    end tell"
}

closeVerse(){
    pids=$(pgrep Preview)   
    if [ -z $pids ]
    then
        debugPrint "[closeVerse] : no pids"
    else
        debugPrint "[closeVerse] : preview pids : ${pids}"
        debugPrint "[closeVerse] : killing preview $pids"
        kill -9 ${pids}
        sleep 0.5
    fi
}