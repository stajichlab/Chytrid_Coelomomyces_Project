#!/bin/bash -l
#
#SBATCH --ntasks 16 #number cores
#SBATCH --mail-type=END # notifications for job done & fail
#SBATCH --mail-user=cassande@ucr.edu # send-to address
#SBATCH --mem=250G #memory
#SBATCH -p intel,batch
#SBATCH -D /rhome/cassande/shared/projects/Chytrid/Coelomomyces/Chytrid_Coelomomyces_Assessment/
#SBATCH -o logs/05_merge.log
#SBATCH -e logs/05_merge.log
#SBATCH -J chytrid_merge

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

anvi-merge ${ANVDIR}/${NAME}/*profile/PROFILE.db -o ${ANVDIR}/${NAME}/$NAME'_SAMPLES_MERGED' -c ${ANVDIR}/${NAME}/$NAME.db --enforce-hierarchical-clustering

