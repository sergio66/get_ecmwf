#!/bin/bash

for file in UAD*.gz; do
    # see if file already has conversion products
    ncfile1=$(basename $file .gz)-1.nc
    ncfile2=$(basename $file .gz)-2.nc
    ncfiled=$(basename $file .gz)-d.nc

    if [[ ! -f $ncfile1 || ! -f $ncfile2 || ! -f $ncfiled ]]; then
	srun --partition=high_mem --qos=short+ --time=00:20:00 --mem=4000 --cpus-per-task 1 -N 1 --output=/dev/null ~/bin/convert_grib_to_netcdf $file &
    fi
    
done
