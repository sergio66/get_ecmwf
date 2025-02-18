#!/bin/bash

# check for verbose output flag
while getopts vf: flag 
do
    case "${flag}" in
	v) vflag="-v";;
	f) driverfile=${OPTARG};;
	*)
	    echo -e "Usage: compress_ecmwf_parallel (-v)(-f filename)\n"
	    echo -e "\t -v: set verbose output on\n"
	    echo -e "\t -f filename: use filename as driver file (default is /asl/models/ecmwf/UAD_compression.driver)\n"
	    echo -e "\t * see compress_ecmwf.sh for details on driver file contents\n"
	    exit
	    ;;
    esac
done

test $driverfile || driverfile='/asl/models/ecmwf/UAD_compression.driver'

# get slurm array index (0-index) for this instance from environment and add 1
let line=${SLURM_ARRAY_TASK_ID}+1

ncfilebasepath=$(sed -n "$line p" $driverfile)
echo "NCFILEBASE = $ncfilebasepath"

compress_ecmwf $vflag -f $ncfilebasepath


