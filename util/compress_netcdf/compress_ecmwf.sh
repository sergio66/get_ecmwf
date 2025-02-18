#!/bin/bash

# use nccopy to compress ecmwf files 

# ecmwf files do not appear to have any UNLIMITED dimensions but run
# nccopy with '-u' anyway, just in case. Go straight to '-d9'
# compression level

# routine takes in path and basefilename for a set of netcdf files as
# produced by convert_grib_to_netcdf conversion

# e.g. for downloaded GRIB file
# /asl/models/ecmwf/2020/12/UAD12070000120703001.gz, conversion
# produces 3 files in the same tree: UAD12070000120703001-[12d].nc
# This routine compresses each of those netcdf files through nccopy

# check for verbose output flag
while getopts vf: flag
do
    case "${flag}" in
	v) verbose=1;;
	f) ncfilebase=${OPTARG};;
	*) echo "Usage: compress_ecmwf (-v) -f filebasepath"
	    exit
	    ;;
    esac
done

module try-load netCDF/4.6.1-intel-2018b

#ncfilebase=$1
echo "NCFILEBASE = $ncfilebase"

declare -a fsuffix=(1 2 d)
declare -a sfilesize=(27000000 900000000 10000000)

for index in ${!fsuffix[*]}; do
    ftype=${fsuffix[$index]}
    fsize=${sfilesize[$index]}
    
    ncfile=${ncfilebase}-${ftype}.nc
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
	mv -b $tncfile $ncfile
    else
	test $verbose &&echo ">>> $ncfile already compressed and replaced"
    fi

done

