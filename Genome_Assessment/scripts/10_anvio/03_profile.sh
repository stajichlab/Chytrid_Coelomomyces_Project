#!/bin/bash -l
#
#SBATCH --ntasks 16 #number cores
#SBATCH -J gwss_anvio_prof
#SBATCH --mail-type=END # notifications for job done & fail
#SBATCH --mail-user=cassande@ucr.edu # send-to address
#SBATCH --mem=250G #memory
#SBATCH -p intel,batch
#SBATCH -D /rhome/cassande/shared/projects/Chytrid/Coelomomyces/Chytrid_Coelomomyces_Assessment/
#SBATCH -o logs/04_prof.log
#SBATCH -e logs/04_prof.log
#SBATCH -J chyrid_coel_profile

ANVDIR=anvio
SAMPFILE=samples.csv
COVDIR=$ANVDIR/coverage_anvio
CPU=16
MIN=2500

ASSEM=data/Amber.scaffolds.fixed.fa
NAME=Amber

AREAD=Amber
OREAD=Orange
MREAD=Meiospore

module unload miniconda2
module unload anaconda3
module load miniconda3

source activate anvio-7

anvi-profile -i ${COVDIR}/$OREAD'.bam' -c ${ANVDIR}/${NAME}/$NAME.db --num-threads $CPU --min-contig-length $MIN --cluster-contigs --output-dir ${ANVDIR}/${NAME}/$OREAD'_profile'

anvi-profile -i ${COVDIR}/$AREAD'.bam' -c ${ANVDIR}/${NAME}/$NAME.db --num-threads $CPU --min-contig-length $MIN --cluster-contigs --output-dir ${ANVDIR}/${NAME}/$AREAD'_profile'

anvi-profile -i ${COVDIR}/$MREAD'.bam' -c ${ANVDIR}/${NAME}/$NAME.db --num-threads $CPU --min-contig-length $MIN --cluster-contigs --output-dir ${ANVDIR}/${NAME}/$MREAD'_profile'

