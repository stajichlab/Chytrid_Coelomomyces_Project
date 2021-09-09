#!/bin/bash
##
#SBATCH -p intel,batch
#SBATCH -o logs/cov.log
#SBATCH -e logs/cov.log
#SBATCH --nodes=1
#SBATCH --ntasks=48 # Number of cores
#SBATCH --mem=64G # Memory pool for all cores (see also --mem-per-cpu)
#SBATCH --mail-type=END # notifications for job done & fail
#SBATCH --mail-user=cassande@ucr.edu # send-to address
#SBATCH -D /rhome/cassande/shared/projects/Chytrid/Coelomomyces/Chytrid_Coelomomyces_Assessment/
#SBATCH -J chytrid_blob_cov


module unload miniconda2
module load bwa
module load samtools/1.11
module load bedtools
module load miniconda3
module load blobtools
source activate blobtools


ASMDIR=data
CPU=24
COV=coverage
TAXFOLDER=taxonomy
OUTPUT=blobtools
READDIR=input

## Amber


PREFIX=Coelomomyces_lativittatus_CIRM-AVA-1-Amber
READ=Amber

ASSEMBLY=${ASMDIR}/$PREFIX.scaffolds.fa
BAM=${OUTPUT}/${COV}/$PREFIX.remap.bam
FWD=${ASMDIR}/${READDIR}/${READ}DNA_R1.fq.gz
REV=${ASMDIR}/${READDIR}/${READ}DNA_R2.fq.gz
	
bwa index $ASSEMBLY

bwa mem -t $CPU $ASSEMBLY $FWD $REV | samtools sort --threads $CPU -T /scratch -O bam -o $BAM
	
samtools index $BAM

blobtools map2cov -i $ASSEMBLY -b $BAM -o ${COV}

## Orange

PREFIX=Coelomomyces_lativittatus_CIRM-AVA-1-Orange
READ=Orange

ASSEMBLY=${ASMDIR}/$PREFIX.scaffolds.fa
BAM=${OUTPUT}/${COV}/$PREFIX.remap.bam
FWD=${ASMDIR}/${READDIR}/${READ}DNA_R1.fq.gz
REV=${ASMDIR}/${READDIR}/${READ}DNA_R2.fq.gz
	
bwa index $ASSEMBLY

bwa mem -t $CPU $ASSEMBLY $FWD $REV | samtools sort --threads $CPU -T /scratch -O bam -o $BAM
	
samtools index $BAM

blobtools map2cov -i $ASSEMBLY -b $BAM -o ${COV}


## Meiospore 

PREFIX=Coelomomyces_lativittatus_CIRM-AVA-1-Meiospore
READ=Meiospore

ASSEMBLY=${ASMDIR}/$PREFIX.scaffolds.fa
BAM=${OUTPUT}/${COV}/$PREFIX.remap.bam
FWD=${ASMDIR}/${READDIR}/${READ}DNA_R1.fq.gz
REV=${ASMDIR}/${READDIR}/${READ}DNA_R2.fq.gz
	
bwa index $ASSEMBLY

bwa mem -t $CPU $ASSEMBLY $FWD $REV | samtools sort --threads $CPU -T /scratch -O bam -o $BAM
	
samtools index $BAM

blobtools map2cov -i $ASSEMBLY -b $BAM -o ${COV}
