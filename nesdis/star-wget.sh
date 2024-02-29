#!/bin/bash

# Our previous ftp feed from NESDIS died early this year. They have
# come up with a new download that is a blind wget. Must have the
# filename(which you must create), can't get a listing or just
# recursively grab the entire directory (not that I found so far).

# filenames this year conform to the following conventions
# UAD<MM><DD><AAAA><MM><DD><BBBB>1.gz
# where <MM> is the month number
# <DD> is the day of month
# <AAAA> and <BBBB> are sequences in the following doublets:
# 0000/0000
# 0000/0300
# 0000/0900
# 0600/0600
# 1200/1200
# 1200/1500
# 1200/2100
# 1800/1800

# Why? Who the hell knows.

# data on in the new repository currently goes back from present to
# 1/17/2021 but will eventually be restricted to a rolling 6 months

URL="https://www.star.nesdis.noaa.gov/data/ecmwf"
USERNAME=ecmwf
PASSWD=STARvalsthecals
DDIR=/asl/models/ecmwf/

# to get this banged out, let's just define two arrays each holding 8
# elements; one will hold the first part of the doublet, the other the second
PART1=(0000 0000 0000 0600 1200 1200 1200 1800)
PART2=(0000 0300 0900 0600 1200 1500 2100 1800)

# The STAR archive lags by one day and sometimes misses a few files
# that get filled in a day or two later. Look for files in a window of
# one week prior to today
YYYY=$(date -d "today" +"%Y")
start=$(date -d "today - 4 days" +"%j")
end=$(date -d "today" +"%j")
if [ $end -lt $start ]; then
    end=$(date -d "today - $end days" +"%j")
    echo "> Bridging year boundary"
    echo ">> starting with year $((YYYY--))"
fi
echo "> Retrieval window: $start - $end"

for doy in $(seq -f "%03g" $start $end); do
    MMDD=$(date -d "$YYYY-01-01 -1 day + $doy days" +"%m%d")
    MM=${MMDD:0:2}
    for i in {0..7}; do
	filename=UAD${MMDD}${PART1[$i]}${MMDD}${PART2[$i]}1
	filenamegz=${filename}.gz
	echo "> Processing $filenamegz"
	FPATH=$DDIR/$YYYY/$MM
	if [[ ! -d $FPATH ]]; then
	    mkdir -p $FPATH
	fi

	if [[ -f $FPATH/$filenamegz || ( -f $FPATH/${filename}-1.nc && -f $FPATH/${filename}-2.nc && -f $FPATH/${filename}-d.nc ) ]]; then
	    echo ">> $filename retrieved previously. Skipping."
	else
	    echo ">> Attempting retrieval of $filenamegz"
	    # first attempt wget --spider to see if the url is valid (i.e. the UAD file exists)
	    wget --spider --no-verbose -r -np -nH --user=$USERNAME --password=$PASSWD $URL/$filenamegz
	    # if wget --spider returns successfully, the file exists and we try to download it
	    if [[ $? -eq 0 ]]; then
		wget --no-verbose -r -np -nH --user=$USERNAME --password=$PASSWD --output-document=$FPATH/$filenamegz $URL/$filenamegz || echo ">>> $filenamegz retrieved"
	    else
		echo ">>> ** $filenamegz does not exist to be retrieved yet"
	    fi
	fi
    done
done
