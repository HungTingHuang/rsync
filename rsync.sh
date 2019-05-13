#!/bin/bash

PATTERM=""
SRC_FOLDER=""
DST_FOLDER=""
#COMP: complement set
#INTER: intersection set
SET="INTER"

 
#COUNT number of parameter
let PARAMETER_COUNT=0
for i in $@; do
    PARAMETER_COUNT=`expr $PARAMETER_COUNT + 1`
done

#
if [ "0" == `expr $PARAMETER_COUNT - 3` ]; then
    PATTERM=$1
    SRC_FOLDER=$2
    DST_FOLDER=$3
fi
if [ "0" == `expr $PARAMETER_COUNT - 4` ]; then
    SET=$1
    PATTERM=$2
    SRC_FOLDER=$3
    DST_FOLDER=$4
fi

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

#SHOW parameter number
if [ "0" == `expr $PARAMETER_COUNT` ]; then 
    printf "${tput_red}PARAMETER COUNT is ZERO${tput_reset}\n"
    exit 1
else
    printf "${tput_purple}PARAMETER COUNT:${tput_reset}\t\t $PARAMETER_COUNT\n"
fi
#SHOW set
if [ -z $SET ] ; then 
    printf "${tput_red}SET is NULL string${tput_reset}\n"
    exit 1
else
    if [ $SET != "INTER" ] && [ $SET != "COMP" ]; then
        printf "${tput_red}SET is NOT correct string${tput_reset}\n"
        exit 1
    else
        printf "${tput_purple}SET:${tput_reset}\t\t\t\t $SET\n"
    fi
fi
#SHOW patterm
if [ -z $PATTERM ]; then 
    printf "${tput_red}PATTERM is NULL string${tput_reset}\n"
    exit 1
else
    printf "${tput_purple}PATTERM:${tput_reset}\t\t\t $PATTERM\n"
fi
#SHOW source folder
if [ ! -e $SRC_FOLDER ] || [ ! -d $SRC_FOLDER ]; then
    printf "${tput_red}${DST_FOLDER} is missing${tput_reset}\n"
    exit 1
else
    printf "${tput_purple}SOURCE FOLDER:${tput_reset}\t\t\t $SRC_FOLDER\n"
fi
#SHOW destination folder
if [ ! -e $DST_FOLDER ] || [ ! -d $DST_FOLDER ]; then
    echo -e "${tput_red}$DST_FOLDER is missing${tput_reset}\n"
    exit 1
else
    printf "${tput_purple}DESTINATION FOLDER:${tput_reset}\t\t $DST_FOLDER\n"
fi



#===================================================#
#                                                   #
#       CP "SOURCE FOLDER"/A/B/C/D/map.h            #
#       ====> "TARGET FOLDER"/A/B/C/D               #
#                                                   #
#===================================================#
list="$(`which find` $SRC_FOLDER -type f -name $PATTERM )"
#Count result
count=`echo "$list" | wc -l`

let index=0
for file in $list; do
    source_file=$file
    target_file=${source_file##*/}

    if [ -n $target_file ]  &&  [ -f $source_file ]; then
        source_folder=${source_file%/${PATTERM}}"/"
        create_folder=""
        if [ -z $source_folder ] || [ ! -d $source_folder ] ; then
            exit 1
        else
            #
            if [ $source_folder = $DST_FOLDER ]; then
                create_folder=$DST_FOLDER
            else
                create_folder=$DST_FOLDER${source_folder#*/}    
            fi
        fi 
        
        #
        if [ -e ${create_folder}${target_file} ] ; then
            :
        else
            if [ "COMP" == $SET ]; then
                :
            else
                continue
            fi
        fi
        
        #if target folder is NOt exist, then CRATE folder
        if [ ! -e $create_folder ]; then
            `which mkdir` -p $create_folder
            printf "${tput_red}MKDIR${tput_reset} $create_folder\n"
        fi

        `which cp` $source_file $create_folder
        printf "\t ${tput_yellow}CP${tput_reset} ${source_folder}${tput_green}$target_file${tput_reset}\n" 
        printf "\t ${tput_skyblue}====>${tput_reset} $create_folder\n"
        index=`expr $index + 1`
    fi

done

exit 0



