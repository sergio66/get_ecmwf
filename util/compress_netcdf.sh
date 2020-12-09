# netcdf files downloaded from ECMWF or converted from ECMWF grib
# files do not utilize netcdf compression and are about 3x larger than
# necessary

# input parameter is a string for MonthDay (e.g. 0803)

# look for files in current directory with '.nc' extension
for file in UAD${1}*.nc; do
    nccopy -u -d9 $file tmp_$file
    #rm $file
    #mv tmp_$file $file
done
