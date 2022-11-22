#!/bin/bash
# Convert ECMWF grib to netcdf

# takes in on baseline grib file, splits on level type and then
# produces netcdf files for each level type

# adjust library paths to correct problem with libhdf **consider this a temporary kludge**
export LD_LIBRARY_PATH="/usr/ebuild/ebuild/software/HDF5/1.10.2-foss-2018b/lib/":$LD_LIBRARY_PATH

GRIBBIN=~/git/eccodes-2.18.0/bin

# check to see if input file is gzipped (assumes files conform to UAD*.gz naming)
if [[ $1 =~ \.gz$ ]]; then
   echo "Input ECMWF file  $1 is gzipped. Unzipping."
   name=$(basename $1 .gz)
   gunzip -c $1 > $name
else
   name=$1
fi
echo ">> Input ECMWF file $name is unzipped. Processing."

# This removes UAD*-1*, UAD*-2*, UAD*-d* files
# Surface part      
name_out1=$name-1
nc_name_out1=$name-1.nc
# Layer part
name_out2=$name-2
nc_name_out2=$name-2.nc
# No sure what this is, save anyway, small
name_out3=$name-d
nc_name_out3=$name-d.nc

if [ ! -f $nc_name_out1 ]; then
   $GRIBBIN/grib_copy -w typeOfLevel=surface $name $name_out1 
   
   $GRIBBIN/grib_to_netcdf -o $nc_name_out1 $name_out1
  rm $name_out1
fi 

if [ ! -f $nc_name_out2 ]; then
    $GRIBBIN/grib_copy -w typeOfLevel=hybrid $name $name_out2
    
    $GRIBBIN/grib_to_netcdf -o $nc_name_out2 $name_out2
   rm $name_out2
fi 

if [ ! -f $nc_name_out3 ]; then
    $GRIBBIN/grib_copy -w typeOfLevel=depthBelowLandLayer $name $name_out3
    
    $GRIBBIN/grib_to_netcdf -o $nc_name_out3 $name_out3
   rm $name_out3
fi 

rm $name
