#!/bin/bash

# use nccopy to compress ecmwf files 

# ecmwf files do not appear to have any UNLIMITED dimensions but run
# nccopy with '-u' anyway, just in case. Go straight to '-d9'
# compression level

# check for verbose output flag
while getopts v flag 
do
    case "${flag}" in
	v) vflag="-v";;
	*)
	    echo "Usage: compress_ecmwf (-v) (for verbose output)"
	    exit
	    ;;
    esac
done

ecmwfbasedir=/asl/models/ecmwf

cd $ecmwfbasedir

declare -a allyears=(2018 2019 2020)
echo "Compress_ecmwf start..."
for year in ${allyears[@]}; do
    echo "> Processing year $year"
    cd $year
    for month in *; do
	echo ">> Processing month $year/$month"
	cd $month
	compress_ecmwf_month ${vflag}
	cd ..
    done
    cd ..
done
