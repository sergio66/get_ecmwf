#!/bin/bash
#
# usage: 
#
# 

# sbatch options
#SBATCH --job-name=RUN_NETCDF_CONVERT
# partition = dev/batch
#SBATCH --partition=batch
# qos = short/normal/medium/long/long_contrib
#SBATCH --qos=short+
#SBATCH --account=pi_strow
#SBATCH -N1
#SBATCH --mem-per-cpu=4000
#SBATCH --cpus-per-task 1
#SBATCH --time=00:59:00

#SBATCH -o /home/sbuczko1/LOGS/sbatch/run_netcdf_convert-%A_%a.out
#SBATCH -e /home/sbuczko1/LOGS/sbatch/run_netcdf_convert-%A_%a.err

echo "Executing run_netcdf_convert"

netcdf_convert_driver $1

echo "Finished with run_netcdf_convert"
