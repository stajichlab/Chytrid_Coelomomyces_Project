#!/usr/bin/bash
#SBATCH -p short --mem 24gb -N 1 -n 16  --out logs/kallisto.%a.log --array 1-16 
#SBATCH -J chytid_kallisto_fun90

CPU=1
if [ $SLURM_CPUS_ON_NODE ]; then
    CPU=$SLURM_CPUS_ON_NODE
fi

module load kallisto
#INDIR=data/RNAseq_raw
INDIR=mosquito_host_bbduk
OUTDIR=results/kallisto_AOM90_BBNH
SPECIES=CoelomomycesAOM90
FASTQEXT=fq.gz
FWDEXT=1
REVEXT=2

IDX=data/kallisto_input/${SPECIES}.idx
TX=data/kallisto_input/${SPECIES}.fa
SAMPLEFILE=samples_kallisto.v2.csv

mkdir $OUTDIR

if [ ! -f $IDX ]; then
    kallisto index -i $IDX $TX
fi

N=${SLURM_ARRAY_TASK_ID}

if [ -z $N ]; then
 N=$1
 if [ -z $N ]; then
     echo "cannot run without a number provided either cmdline or --array in sbatch"
     exit
 fi
fi

IFS=,
tail -n +2 $SAMPLEFILE | sed -n ${N}p | while read SAMPLE CONDITION REP BASE
do
 OUTNAME=$CONDITION.r${REP}
 READBASE=$BASE'.host.removed'
 if [ ! -f $OUTDIR/$OUTNAME/abundance.h5 ]; then
     kallisto quant -i $IDX -o $OUTDIR/$OUTNAME -t $CPU --bias $INDIR/${READBASE}_${FWDEXT}.$FASTQEXT $INDIR/${READBASE}_${REVEXT}.$FASTQEXT
 fi
done

