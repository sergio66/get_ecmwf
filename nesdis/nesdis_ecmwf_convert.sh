#!/bin/bash


uadfilebases=($(find . -type f -name "UAD*" | cut -c1-22 | sort --unique))

for filebase in "${uadfilebases[@]}"; do
    echo $filebase
    # see if file already has conversion products
    cprods=false
    [[ -f $filebase-1.nc && -f $filebase-2.nc && -f $filebase-d.nc ]] && cprods=true

    # see if UAD--- file exists
    base=false
    [[ -f $filebase ]] && base=true

    # see if UAD---.gz file exists
    gbase=false
    [[ -f $filebase.gz ]] && gbase=true

    # if current base does not have all product files, re-run
    if [[ ! -f $ncfile1 || ! -f $ncfile2 || ! -f $ncfiled ]]; then
	srun --partition=high_mem --qos=short+ --time=00:20:00 --mem=4000 --cpus-per-task 1 -N 1 --output=/dev/null ~/bin/convert_grib_to_netcdf $filebase &
    fi
    
done
