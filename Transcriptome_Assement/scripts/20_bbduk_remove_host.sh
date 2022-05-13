#!/usr/bin/bash
#SBATCH -p short --mem 24gb -N 1 -n 16  --out logs/bbduk.host.%a.log --array 1-16 
#SBATCH -J chytid_host


CPU=1
if [ $SLURM_CPUS_ON_NODE ]; then
    CPU=$SLURM_CPUS_ON_NODE
fi

module load bowtie2
module load samtools 

INDIR=data/RNAseq_raw
OUT=mosquito_host_bbduk
SPECIES=GBTE01.1
FASTQEXT=fq.gz
FWDEXT=1
REVEXT=2
REF=GBTE01.1.fa
SAMPLEFILE=samples_kallisto.csv
REFLOC=data/kallisto_input

mkdir $OUT

N=${SLURM_ARRAY_TASK_ID}

if [ -z $N ]; then
 N=$1
 if [ -z $N ]; then
     echo "cannot run without a number provided either cmdline or --array in sbatch"
     exit
 fi
fi


IFS=,
tail -n +2 $SAMPLEFILE | sed -n ${N}p | while read SAMPLE CONDITION REP READBASE
do
	OUTNAME=$CONDITION.r${REP}	
	/rhome/cassande/bigdata/software/bbmap/bbmap.sh in1=$INDIR/${READBASE}_${FWDEXT}.$FASTQEXT in2=$INDIR/${READBASE}_${REVEXT}.$FASTQEXT outm1=$OUT/${OUTNAME}.host_${FWDEXT}.$FASTQEXT outm2=$OUT/${OUTNAME}.host_${REVEXT}.$FASTQEXT outu1=$OUT/${OUTNAME}.host.removed_${FWDEXT}.$FASTQEXT outu2=$OUT/${OUTNAME}.host.removed_${REVEXT}.$FASTQEXT ref=$REFLOC/$REF
	 
done






