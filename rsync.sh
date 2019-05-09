#!/bin/bash


PATTERM=$1
SRC_FOLDER=$2
DST_FOLDER=$3

#Usage:
#
#
#
#
#

if [ -z $PATTERM ]; then 
    echo -e "\e[31m$PATTERM is NULL string\e[0m"
    exit 1
else
    echo -e "\e[95mPATTERM:\e[0m\t\t\t $PATTERM"
fi


if [ ! -d $SRC_FOLDER ]; then
    echo -e "\e[31m$SRC_FOLDER is missing\e[0m"
    exit 1
else
    echo -e "\e[95mSOURCE FOLDER:\e[0m\t\t\t $SRC_FOLDER"
fi

if [ ! -d $DST_FOLDER ]; then
    echo -e "\e[31m$DST_FOLDER is missing\e[0m"
    exit 1
else
    echo -e "\e[95mDESTINATION FOLDER:\e[0m\t\t $DST_FOLDER"
fi

function ProgressBar {
# Process data
    let _progress=(${1}*100/${2}*100)/100
    let _done=(${_progress}*4)/10
    let _left=40-$_done
# Build progressbar string lengths
    _fill=$(printf "%${_done}s")
    _empty=$(printf "%${_left}s")

# 1.2 Build progressbar strings and print the ProgressBar line
# 1.2.1 Output example:                           
# 1.2.1.1 Progress : [########################################] 100%
printf "\n\r${_fill// /\#}${_empty// /-}  ${1}/${2} ${_progress}%%\n\r"

}

#===================================================#
#                                                   #
#===================================================#
list="$(find $SRC_FOLDER -type f -name $PATTERM )"
#count
count=`echo "$list" | wc -l`
let index=0
for file in $list; do
    source_file=$file
    target_file=${source_file##*/}
    if [ -n target_file ]  &&  [ -f $source_file ]; then
        source_folder=${source_file%/*.h}
        create_folder=$DST_FOLDER${source_folder#*/}
        if [ ! -e $create_folder ]; then
#if target folder is NOt exist, then CRATE folder
            mkdir -p $create_folder
            echo -e "\e[31mMKDIR\e[0m $create_folder"
        fi
        cp $source_file $create_folder
        echo -e "\t \e[33mCP\e[0m $source_folder/\e[32m$target_file\e[0m" 
        echo -e "\t \e[90m====>\e[0m $create_folder"
        index=`expr $index + 1`
    fi
    ProgressBar $index $count
done

exit 0



