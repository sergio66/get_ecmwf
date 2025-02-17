#!/bin/bash

# command line parameter is path and name of driver list file

# get slurm array index (0-index) for this instance from environment and add 1
line=$SLURM_ARRAY_TASK_ID
let line+=1

uadfile=$(sed -n "$line p" $1)
echo "UADFILE = $uadfile"

echo "Changing directory to path of source file $(dirname $uadfile)"
cd $(dirname $uadfile)

echo "Running convert_grib_to_netcdf on $uadfile"
~/bin/convert_grib_to_netcdf $uadfile

echo "$uadfile converted"
