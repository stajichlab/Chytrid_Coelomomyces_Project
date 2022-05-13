#!/bin/bash -l
#
#SBATCH --ntasks 16 #number cores
#SBATCH -p intel
#SBATCH -o logs/24_mmeseqdb.log
#SBATCH -e logs/24_mmeseqdb.log
#SBATCH --mem=400G #memory
#SBATCH -J chy_mmseq

source activate mmseqs2

#mkdir tmp

mmseqs databases UniRef90 uniref90 tmp

mmseqs createtaxdb uniref90 tmp

mmseqs createindex uniref90 tmp

mmseqs createdb data/kallisto_input/CoelomomycesTRIN90.fa TRIN90

mmseqs taxonomy TRIN90 uniref90 taxonomyResult_TRIN90 tmp

mmseqs createtsv TRIN90 taxonomyResult_TRIN90 taxonomyResult_TRIN90.tsv
