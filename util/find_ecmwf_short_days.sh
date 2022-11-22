#!/bin/bash

# usage: find_ecmwf_short_days YYYY MM

# find and report days in the ecmwf archive that have less than the 8
# file complement

tend=$(date -d "${1}-${2}-01 + 1 month - 1 day" +"%d")

for i in $(seq -w 1 $tend); do
    fname="UAD${2}${i}*-1.nc"
    nfiles=$(ls ./${fname} 2> /dev/null | wc -l)
    if [[ $nfiles -lt 8 ]]; then
	echo "$1-$2-$i :: $nfiles"
    fi
done
    
