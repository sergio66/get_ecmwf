#!/bin/bash

#SBATCH --job-name=COMPRESS_ECMWF
#SBATCH --partition=batch
#SBATCH --qos=short+
#SBATCH --account=pi_strow
#SBATCH -N1
#SBATCH --cpus-per-task=1
# Files are under 2G, see if 4G is enough for runs
#SBATCH --mem=4000
# runtime on strowinteract is about 17 minutes
#SBATCH --time=00:35:00

#SBATCH -o /home/sbuczko1/LOGS/sbatch/compress_ecmwf-%A_%a.out
#SBATCH -e /home/sbuczko1/LOGS/sbatch/compress_ecmwf-%A_%a.err

echo "Executing batch ecmwf compression"
$HOME/git/work/compress_ecmwf_parallel.sh
echo "Ecmwf compression finished"
