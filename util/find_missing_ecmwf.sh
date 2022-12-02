#!/bin/bash

ECMWFBASE=/asl/models/ecmwf

# check from 2018/01/01 to present
STARTYEAR=2018
ENDYEAR=$(date -d "today" +"%Y")

# loop over years
for year in $(seq -w $STARTYEAR $ENDYEAR); do

    # find end month for the current year
    ENDMONTH=$( [[ $year == $ENDYEAR ]] && date -d "today" +"%m" || echo 12 )

    # loop over months
    for month in $(seq -w 1 $ENDMONTH); do
	
	cd $ECMWFBASE/$year/$month
	
	# find last day of month
	LASTDAY=$(date -d "$year/$month/01 + 1 month - 1 day" +"%d")

	for day in $(seq -w 1 $LASTDAY); do
	    fileglob="\.\/UAD${month}${day}*-1.nc"

	    nfiles=$(find . -type f -regextype posix-basic -regex "$fileglob" 2> /dev/null | wc -l)
	    if [[ $nfiles != 8 ]]; then 
		echo "$year/$month/$day" 
	    fi

	done

    done

done
