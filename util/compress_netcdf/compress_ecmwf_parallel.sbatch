#!/bin/bash

#SBATCH --job-name=COMPRESS_ECMWF
#SBATCH --partition=high_mem
#SBATCH --qos=short+
#SBATCH --account=pi_strow
#SBATCH -N1
#SBATCH --cpus-per-task=1
# Files are under 2G, see if 4G is enough for runs
#SBATCH --mem=4000
# runtime on strowinteract is about 17 minutes
#SBATCH --time=00:40:00

#SBATCH -o /home/sbuczko1/LOGS/sbatch/compress_ecmwf-%A_%a.out
#SBATCH -e /home/sbuczko1/LOGS/sbatch/compress_ecmwf-%A_%a.err

echo "Executing batch ecmwf compression"
$HOME/git/get_ecmwf/util/compress_ecmwf_parallel.sh -v -f $1
echo "Ecmwf compression finished"
