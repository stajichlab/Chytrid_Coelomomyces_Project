#!/bin/bash
##
#SBATCH -o logs/busco_prot.log
#SBATCH -e logs/busco_prot.log
#SBATCH --nodes=1
#SBATCH --ntasks=12 # Number of cores
#SBATCH --mem=60G # Memory pool for all cores (see also --mem-per-cpu)
#SBATCH --time=48:00:00
#SBATCH -J chytid_busco


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

INDIR=data/filtered

busco -i $INDIR/Coelomomyces_lativittatus_CIRM-AVA-1-Amber.prot.fa -l $BUSCO_SET -o busco_prot_fungi_Amber -m protein --cpu 12 

busco -i $INDIR/Coelomomyces_lativittatus_CIRM-AVA-1-Orange.prot.fa -l $BUSCO_SET -o busco_prot_fungi_Orange -m protein --cpu 12 

busco -i $INDIR/Coelomomyces_lativittatus_CIRM-AVA-1-Meiospore.prot.fa -l $BUSCO_SET -o busco_prot_fungi_Meiospore -m protein --cpu 12 

INDIR=data/JGI

busco -i $INDIR/Allma1_GeneCatalog_proteins_20131203.aa.fasta -l $BUSCO_SET -o busco_prot_fungi_Allma1 -m protein --cpu 12 

busco -i $INDIR/Blabri1_all_proteins_20160901.aa.fasta -l $BUSCO_SET -o busco_prot_fungi_Blabri1 -m protein --cpu 12 

busco -i $INDIR/Catan2_all_proteins_20160412.aa.fix.fasta -l $BUSCO_SET -o busco_prot_fungi_Catan2 -m protein --cpu 12 

busco -i $INDIR/Parsed1_all_proteins_20170905.aa.fasta -l $BUSCO_SET -o busco_prot_fungi_Parsed1 -m protein --cpu 12 



