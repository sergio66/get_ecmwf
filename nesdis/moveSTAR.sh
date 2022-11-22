#!/bin/bash

echo "Processing downloaded STAR ECMWF files"

SRCDIR=./data/ecmwf
# downloaded files are named like 
# UAD02241800022418001.gz
# UADMMDD.... .gz

MVBASE=/asl/models/ecmwf/2021
# files need to be moved to $MVBASE/$MM

nfiles=$(ls $SRCDIR/UAD*.gz | wc -l)
echo "> $nfiles waiting to be moved"
for file in $SRCDIR/UAD*.gz; do
    MM=$(basename $file | cut -c4-5)
    if [[ ! -d $MVBASE/$MM ]]; then
	echo ">> Directory $MVBASE/$MM missing. Creating"
	mkdir -p $MVBASE/$MM
    fi
    
    echo ">moving $file -> $MVBASE/$MM/$(basename $file)"
    mv $file $MVBASE/$MM/$(basename $file)

done
    
