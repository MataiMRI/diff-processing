#!/usr/bin/env bash
#SBATCH --job-name=dti_workflow
#SBATCH --time=02-00:00:00
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=2
#SBATCH --mem=1GB
#SBATCH --output=nesi/logs/%j-%x.out
#SBATCH --error=nesi/logs/%j-%x.out
#SBATCH --dependency=singleton

# exit on errors, undefined variables and errors in pipes
set -euo pipefail

# load environment modules
module purge
module load Apptainer/1.1.9 snakemake/7.26.0-gimkl-2022a-Python-3.11.3

# parent folder for cache directories
NOBACKUPDIR="/nesi/nobackup/$SLURM_JOB_ACCOUNT/$USER"

# configure apptainer build and cache directories
export APPTAINER_CACHEDIR="$NOBACKUPDIR/apptainer_cachedir"
export APPTAINER_TMPDIR="$NOBACKUPDIR/apptainer_tmpdir"
mkdir -p "$APPTAINER_CACHEDIR" "$APPTAINER_TMPDIR"
setfacl -b "$APPTAINER_TMPDIR"  # avoid apptainer issues due to ACLs set on this folder

# run snakemake using the NeSI profile
snakemake --profile nesi --config account="$SLURM_JOB_ACCOUNT" $@
