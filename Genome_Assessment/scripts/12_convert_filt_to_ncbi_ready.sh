#!/bin/bash
#SBATCH -p batch,intel 
#SBATCH --time 1-0:00:00 
#SBATCH --ntasks 12 
#SBATCH --nodes 1 
#SBATCH --mem 24G 
#SBATCH --out logs/convert.%a.log
#SBATCH -J coel_genbank


module unload miniconda2 miniconda3
module load funannotate/1.8

DIR=data/filtered
SBTDIR=$DIR/sbt
SAMPFILE=$DIR/samples.csv

IFS=,
tail -n +2 $SAMPFILE | sed -n ${N}p | while read PREFIX GFF FASTA SBT STRAIN
do 
	funannotate util gff2prot -g $DIR/$GFF -f $DIR/$FASTA > $DIR/$PREFIX.prot.fa
	funannotate util gff2tbl -g $DIR/$GFF -f $DIR/$FASTA > $DIR/$PREFIX.tbl
	funannotate util tbl2gbk -i $DIR/$PREFIX.tbl -f $DIR/$FASTA -s "Coelomomyces lativittatus" --strain $STRAIN --sbt $SBTDIR/$SBT --out $DIR/$PREFIX
done

