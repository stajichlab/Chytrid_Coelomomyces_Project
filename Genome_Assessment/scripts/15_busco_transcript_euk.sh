#!/bin/bash
##
#SBATCH -o logs/busco_tran_euk.log
#SBATCH -e logs/busco_tran_euk.log
#SBATCH --nodes=1
#SBATCH --ntasks=12 # Number of cores
#SBATCH --mem=60G # Memory pool for all cores (see also --mem-per-cpu)
#SBATCH --time=48:00:00
#SBATCH -J chytid_busco_euk_tran

module unload miniconda2
module load augustus/3.3.3
module load hmmer 
module load ncbi-blast/2.2.31+ 
module load R

module load miniconda3

source activate busco5

conda info --envs

export AUGUSTUS_CONFIG_PATH="/bigdata/software/augustus_3.3.3/config/"

BUSCO_SET=eukaryota_odb10


INDIR=data/filtered


busco -i $INDIR/Coelomomyces_lativittatus_CIRM-AVA-1-Amber.transcripts.fasta  -l $BUSCO_SET -o busco_tran_euk_Amber -m tran --cpu 12 

busco -i $INDIR/Coelomomyces_lativittatus_CIRM-AVA-1-Orange.transcripts.fasta  -l $BUSCO_SET -o busco_tran_euk_Orange -m tran --cpu 12 

busco -i $INDIR/Coelomomyces_lativittatus_CIRM-AVA-1-Meiospore.transcripts.fasta -l $BUSCO_SET -o busco_tran_eul_Meiospore -m tran --cpu 12 

busco -i $INDIR/Allma1_GeneCatalog_transcripts_20131203.nt.fasta -l $BUSCO_SET -o busco_tran_euk_Allma1 -m tran --cpu 12 

busco -i $INDIR/Blabri1_all_transcripts_20160901.nt.fasta -l $BUSCO_SET -o busco_tran_euk_Blabri1 -m tran --cpu 12 

busco -i $INDIR/Catan2_all_transcripts_20160412.nt.fix.fasta -l $BUSCO_SET -o busco_tran_euk_Catan2 -m tran --cpu 12 

busco -i $INDIR/Parsed1_all_transcripts_20170905.nt.fasta -l $BUSCO_SET -o busco_tran_euk_Parsed1 -m tran --cpu 12 



