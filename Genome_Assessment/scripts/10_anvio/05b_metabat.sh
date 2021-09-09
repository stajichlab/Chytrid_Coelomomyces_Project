#!/bin/bash -l
#
#SBATCH --ntasks 24 #number cores
#SBATCH --mail-type=END # notifications for job done & fail
#SBATCH --mail-user=cassande@ucr.edu # send-to address
#SBATCH --mem=98G #memory
#SBATCH -p intel,batch
#SBATCH -D /rhome/cassande/shared/projects/Chytrid/Coelomomyces/Chytrid_Coelomomyces_Assessment/
#SBATCH -o logs/06b_metabat.log
#SBATCH -e logs/06b_metabat.log
#SBATCH -J chytrid_metabat

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
#module load concoct/1.1.0
module load metabat/0.32.4
#module load maxbin/2.2.1 
#module load diamond

source activate anvio-7
#must also install concoct to conda anvio env



anvi-cluster-contigs -p ${ANVDIR}/${NAME}/$NAME'_SAMPLES_MERGED'/PROFILE.db -c ${ANVDIR}/${NAME}/$NAME.db -C METABAT --driver metabat2 -T $CPU --just-do-it

