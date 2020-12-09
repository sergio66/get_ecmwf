#!/bin/bash

verbose=1

which nccopy

# get slurm array index (0-index) for this instance from environment and add 1
line=$SLURM_ARRAY_TASK_ID
let line+=1

ncfile=$(sed -n "$line p" UAD-2_compression.driver)
echo "NCFILE = $ncfile"

# compressed -2 files are ~600M while uncompressed are
# ~1.7G. threshold size is somewhere in bewteen (900M)
fsize=900000000
  
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
    mv $tncfile $ncfile
else
    test $verbose &&echo ">>> $ncfile already compressed and replaced"
    exit
fi

