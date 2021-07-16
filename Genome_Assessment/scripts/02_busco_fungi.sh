#!/bin/bash
##
#SBATCH -o logs/busco.log
#SBATCH -e logs/busco.log
#SBATCH --nodes=1
#SBATCH --ntasks=12 # Number of cores
#SBATCH --mem=60G # Memory pool for all cores (see also --mem-per-cpu)
#SBATCH --time=48:00:00
#SBATCH -J chytid_busco
#SBATCH --mail-type=END # notifications for job done & fail
#SBATCH --mail-user=cassande@ucr.edu # send-to address
#SBATCH -D /rhome/cassande/shared/projects/Chytrid/Coelomomyces/Chytrid_Coelomomyces_Assessment/


module unload miniconda2
module load augustus/3.3.3
module load hmmer 
module load ncbi-blast/2.2.31+ 
module load R

module load miniconda3

source activate busco5

conda info --envs

export BUSCO_CONFIG_FILE=$(realpath config.ini)
export AUGUSTUS_CONFIG_PATH="/bigdata/software/augustus_3.3.3/config/"

BUSCO_PATH=$(realpath config.ini)

BUSCO_SET=fungi_odb10

INDIR=data

busco -i $INDIR/Coelomomyces_lativittatus_CIRM-AVA-1-Amber.scaffolds.fa -l $BUSCO_SET -o busco_fungi_Amber -m genome --config $BUSCO_PATH --cpu 12 

busco -i $INDIR/Coelomomyces_lativittatus_CIRM-AVA-1-Orange.scaffolds.fa -l $BUSCO_SET -o busco_fungi_Orange -m genome --config $BUSCO_PATH --cpu 12 

busco -i $INDIR/Coelomomyces_lativittatus_CIRM-AVA-1-Meiospore.scaffolds.fa -l $BUSCO_SET -o busco_fungi_Meiospore -m genome --config $BUSCO_PATH --cpu 12 




