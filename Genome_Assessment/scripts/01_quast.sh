#!/bin/bash
##
#SBATCH -o logs/quast.log.txt
#SBATCH -e logs/quast.log.txt
#SBATCH --nodes=1
#SBATCH --ntasks=12 # Number of cores
#SBATCH --mem=60G # Memory pool for all cores (see also --mem-per-cpu)
#SBATCH --time=24:00:00
#SBATCH -J chytrid_quast
#SBATCH --mail-type=END # notifications for job done & fail
#SBATCH --mail-user=cassande@ucr.edu # send-to address
#SBATCH -D /rhome/cassande/shared/projects/Chytrid/Coelomomyces/Chytrid_Coelomomyces_Assessment/


module load busco

INDIR=data


/rhome/cassande/bigdata/software/quast-5.1.0rc1/quast.py  $INDIR/Coelomomyces_lativittatus_CIRM-AVA-1-Amber.scaffolds.filtered.fa $INDIR/Coelomomyces_lativittatus_CIRM-AVA-1-Orange.scaffolds.filtered.fa $INDIR/Coelomomyces_lativittatus_CIRM-AVA-1-Meiospore.scaffolds.filtered.fa --threads 12 --eukaryote --space-efficient 

