#!/bin/bash

DATAROOT=/asl/data/ecmwf

printf "YEAR,MONTH,DATAFILES,INVFILES,NCFILES\n" 
# loop over years from 2002 to present
for YEAR in {2002..2015}; do

    # loop over months
    # (restrict 2002 to months 8-12)
    # (restrict 2015 to months 1-4)
    START=1
    if [ "$YEAR" -eq "2002" ]; then
	START=8
    fi
    END=12
    if [ "$YEAR" -eq "2015" ]; then
	END=4
    fi

    for ((MONTH=$START; MONTH<=$END; MONTH++)); do
	if [ "$MONTH" -lt "10" ]; then
	    MONTH="0$MONTH"
	fi
	# get count of UAD* files
	UADFILES=$(ls $DATAROOT/$YEAR/$MONTH/UAD* | wc -l)
	# get count of inv files
	INVFILES=$(ls $DATAROOT/$YEAR/$MONTH/UAD*.inv | wc -l)    
	# get count of nc files
	NCFILES=$(ls $DATAROOT/$YEAR/$MONTH/UAD*.nc | wc -l)    

	# subtract inv and nc files from full file count
	DATAFILES=$((UADFILES-INVFILES-NCFILES))

	# output count of files
	printf "%s,%s,%s,%s,%s\n" "$YEAR" "$MONTH" "$DATAFILES" "$INVFILES" "$NCFILES"
    done
done

