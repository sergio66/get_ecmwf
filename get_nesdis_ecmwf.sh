#!/bin/bash

# update local archive of ECMWF files being created for JPSS-1
# pulls from nesdis ftp site

# nesdis ftp site maintains a rolling 5-day window of files. When 'n'
# new files come online, 'n' oldest are gone.

# This script implements a rudimentary rsync-over-ftp type behavior where it
# checks the local archive and compares against the ftp archive to pull down only
# those files not currently on the local machine.

# REQUIRES: lftp, awk, diff

# Send start of transfer heartbeat to SLB
CONTACT="4136879102@tmomail.net"
BODY="ECMWF/SPUD xfer start"
echo "$BODY" | mail -s "$BODY" "$CONTACT"

LFTP="/usr/bin/lftp"

# make sure we are at the root of the local archive
# cd /asl/s1/NESDIS_ECMWF
# cd /Volumes/ExtBackup-6TB/NESDIS_ECMWF
# cd /Volumes/ExtBackup-8TB/NESDIS_ECMWF
cd /asl/models/ecmwf

# build the local archive file listing
find . -name 'UAD*' > spud.list

# build the current remote file listing
$LFTP -e 'find;bye' ftp://ftp.star.nesdis.noaa.gov/pub/smcd/spb/ychen/ECMWF_data/ecmwf | \
   grep UAD > nesdis.list

# compare the two lists, collect missing files, and build lftp driver file
diff nesdis.list spud.list | \
   awk 'BEGIN{\
              printf("open ftp://ftp.star.nesdis.noaa.gov\n"); \
              printf("cd pub/smcd/spb/ychen/ECMWF_data/ecmwf/\n"); } \
        /^</ { printf("get %s -o %s\n",$2,$2); } \
        END  { printf("bye\n"); }' > lftp.driver

# make incoming year/month directories, if not currently extant
grep .gz lftp.driver | cut -d" " -f4 | cut -d\/ -f1-3 | sort | uniq | xargs mkdir -p

# execute lftp with lftp.driver to download missing files
$LFTP -f lftp.driver

# Send end of transfer heartbeat to SLB
CONTACT="4136879102@tmomail.net"
BODY="ECMWF/SPUD xfer end"
echo "$BODY" | mail -s "$BODY" "$CONTACT"


