#!/bin/bash -l
#
#SBATCH --ntasks 24 #number cores
#SBATCH -p intel
#SBATCH -o logs/23_kaiju.log
#SBATCH -e logs/23_kaiju.log
#SBATCH --mem=198G #memory
#SBATCH -J chy_kaiju



DB=/rhome/cassande/bigdata/software/databases/kaiju
CPU=24
INDIR=data/kallisto_input
OUT=kaiju


module load miniconda3

source activate kaiju


FILE=CoelomomycesTRIN90


kaiju -z $CPU -t $DB/nodes.dmp -f $DB/kaiju_db_nr_euk.fmi -i  $INDIR/$FILE.fa -o $OUT/$FILE.kaiju.out -v

kaiju-addTaxonNames -t $DB/nodes.dmp -n $DB/names.dmp -i $OUT/$FILE.kaiju.out -o $OUT/$FILE.kaiju.names.out -r superkingdom,phylum,class,order,family,genus,species


