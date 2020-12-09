#!/bin/bash

for file in UAD*.gz; do
    # see if file already has conversion products
    ncfile=$(basename $file .gz)-1.nc

    if [[ ! -f $ncfile ]]; then
	srun --partition=batch --qos=short+ --mem=4000 --cpus-per-task 1 -N 1 --share --output=/dev/null ~/bin/convert_grib_to_netcdf $file &
    fi
    
done
