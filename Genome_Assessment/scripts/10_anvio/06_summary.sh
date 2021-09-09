#!/bin/bash -l
#
#SBATCH --ntasks 24 #number cores
#SBATCH --mail-type=END # notifications for job done & fail
#SBATCH --mail-user=cassande@ucr.edu # send-to address
#SBATCH --mem=98G #memory
#SBATCH -p intel,batch
#SBATCH -D /rhome/cassande/shared/projects/Chytrid/Coelomomyces/Chytrid_Coelomomyces_Assessment/
#SBATCH -o logs/08_summary.log
#SBATCH -e logs/08_summary.log
#SBATCH -J chytrid_summary

ANVDIR=anvio
SAMPFILE=samples.csv
COVDIR=$ANVDIR/coverage_anvio
CPU=16
MIN=2500

ASSEM=data/Amber.scaffolds.fixed.fa
NAME=Amber


module unload miniconda2
module unload anaconda3
module load miniconda3

source activate anvio-7




anvi-summarize -p ${ANVDIR}/${NAME}/$NAME'_SAMPLES_MERGED'/PROFILE.db -c ${ANVDIR}/${NAME}/$NAME.db -o ${ANVDIR}/${NAME}/$NAME'_SAMPLES_MERGED'/sample_summary_METABAT -C METABAT

anvi-summarize -p ${ANVDIR}/${NAME}/$NAME'_SAMPLES_MERGED'/PROFILE.db -c ${ANVDIR}/${NAME}/$NAME.db -o ${ANVDIR}/${NAME}/$NAME'_SAMPLES_MERGED'/sample_summary_CONCOCT -C CONCOCT

