#!/bin/bash
##
#SBATCH -o logs/busco_cluster_prot.log
#SBATCH -e logs/busco_cluster_prot.log
#SBATCH --nodes=1
#SBATCH --ntasks=12 # Number of cores
#SBATCH --mem=60G # Memory pool for all cores (see also --mem-per-cpu)
#SBATCH --time=48:00:00
#SBATCH -J chytid_busco_prot


module unload miniconda2
module load augustus/3.3.3
module load hmmer 
module load ncbi-blast/2.2.31+ 
module load R

module load miniconda3

source activate busco5

conda info --envs

export AUGUSTUS_CONFIG_PATH="/bigdata/software/augustus_3.3.3/config/"

BUSCO_SET=fungi_odb10

INDIR=combined_transcripts


busco -i $INDIR/fun_90_pep.fa -l $BUSCO_SET -o busco_fun_fun90_prot -m prot --cpu 12 


BUSCO_SET=eukaryota_odb10
          
busco -i $INDIR/fun_90_pep.fa -l $BUSCO_SET -o busco_euk_fun90_prot -m prot --cpu 12


