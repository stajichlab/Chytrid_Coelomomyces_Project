#!/bin/bash -l
#
#SBATCH -n 24 #number cores
#SBATCH -e logs/cdhit.log
#SBATCH -o logs/cdhit.log
#SBATCH --mem 100G #memory per node in Gb
#SBATCH -p intel
#SBATCH -J chytrid_cdhit

#-g = sensitivity 1 = slow, 0=fast
#-c = seq identity
#-M = memory -> 0 unlimited
#-n = word-length, default 10
#-r 1 = direction, 1=both & default
#G = local or global alignment - not sure which we want
#aS = how long coverage of shorter seq must be 


# Just our funnanotate genes
ASM=Funannotate.fasta
OUT1=combined_transcripts/fun
OUT2=combined_transcripts/fun_95
OUT3=combined_transcripts/fun_90

/rhome/cassande/bigdata/software/cd-hit-v4.8.1-2019-0228/cd-hit-est -i $DIR/$ASM -o $OUT1 -M 0 -T $CPU -g 1 -c 1 
/rhome/cassande/bigdata/software/cd-hit-v4.8.1-2019-0228/cd-hit-est -i $DIR/$ASM -o $OUT2 -M 0 -T $CPU -g 1 -c 0.95
/rhome/cassande/bigdata/software/cd-hit-v4.8.1-2019-0228/cd-hit-est -i $DIR/$ASM -o $OUT3 -M 0 -T $CPU -g 1 -c 0.9

