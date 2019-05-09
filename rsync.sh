#!/bin/bash

PATTERM=$1
SRC_FOLDER=$2
DST_FOLDER=$3

#color
tput_red=`tput setaf 1`
tput_green=`tput setaf 2`
tput_yellow=`tput setaf 3`
tput_blue=`tput setaf 4`
tput_purple=`tput setaf 5`
tput_skyblue=`tput setaf 6`
tput_reset=`tput sgr0`
#Usage:
#
#
#
#
#

if [ -z $PATTERM ]; then 
    printf "${tput_red}$PATTERM is NULL string${tput_reset}\n"
    exit 1
else
    printf "${tput_purple}PATTERM:${tput_reset}\t\t\t $PATTERM\n"
fi


if [ ! -e $SRC_FOLDER ] || [ ! -d $SRC_FOLDER ]; then
    printf "${tput_red}${DST_FOLDER} is missing${tput_reset}\n"
    exit 1
else
    printf "${tput_purple}SOURCE FOLDER:${tput_reset}\t\t\t $SRC_FOLDER\n"
fi

if [ ! -e $DST_FOLDER ] || [ ! -d $DST_FOLDER ]; then
    echo -e "${tput_red}$DST_FOLDER is missing${tput_reset}\n"
    exit 1
else
    printf "${tput_purple}DESTINATION FOLDER:${tput_reset}\t\t $DST_FOLDER\n"
fi

function ProgressBar {
# Process data
    local _progress=(${1}*100/${2}*100)/100
    local _done=(${_progress}*4)/10
    local _left=40-$_done
# Build progressbar string lengths
    _fill=$(printf "%${_done}s")
    _empty=$(printf "%${_left}s")

# 1.2 Build progressbar strings and print the ProgressBar line
# 1.2.1 Output example:                           
# 1.2.1.1 Progress : [########################################] 100%ls
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
            `which mkdir` -p $create_folder
            printf "${tput_red}MKDIR${tput_reset} $create_folder"
        fi
        `which cp` $source_file $create_folder
        printf "\e\t ${tput_yellow}CP${tput_reset} $source_folder/`tput_green $target_file`\n" 
        printf "\e\t ${tput_skyblue} ====>${tput_reset} $create_folder\n"
        index=`expr $index + 1`
    fi
    ProgressBar $index $count
done

exit 0



