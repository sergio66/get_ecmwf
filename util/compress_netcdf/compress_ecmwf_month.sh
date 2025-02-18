#!/bin/bash

# compress single month of ECMWF downloads

# checks for existence of *.compressed and/or filesizes that indicate
# prior compression before initiating compression

# check for verbose output flag
while getopts v flag 
do
    case "${flag}" in
	v) verbose=1;;
	*)
	    echo "Usage: compress_ecmwf_month (-v) (for verbose output)"
	    exit
	    ;;
    esac
done

# declare -a fsuffix=(1 2 d)
# declare -a sfilesize=(27000000 900000000 10000000)
declare -a fsuffix=(1 d)
declare -a sfilesize=(27000000 10000000)
for index in ${!fsuffix[*]}; do
    ftype=${fsuffix[$index]}
    fsize=${sfilesize[$index]}
    
    for ncfile in *-${ftype}.nc; do
	tncfile=${ncfile}.compressed
	filesize=$(stat -c%s $ncfile)
	
	if [[ ! -f $tncfile && $filesize -gt $fsize ]]; then
	    test $verbose && echo ">>> Compressing $ncfile: nccopy -u -d9 $ncfile ${tncfile}"
	    nccopy -u -d9 $ncfile ${tncfile}
        fi

	# Second if-then block to move compressed files into place
	# even if they were just created above
	if [[ -f $tncfile ]]; then
	    test $verbose && echo ">>> $tncfile exists, moving to replace $ncfile: mv $tncfile $ncfile"
	    mv $tncfile $ncfile
	else
	    test $verbose &&echo ">>> $ncfile already compressed and replaced"
	fi
    done
done
