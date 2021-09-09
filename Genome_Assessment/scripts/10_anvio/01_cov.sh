#!/bin/bash -l
#
#SBATCH --ntasks 24 #number cores
#SBATCH -D /rhome/cassande/shared/projects/Chytrid/Coelomomyces/Chytrid_Coelomomyces_Assessment/
#SBATCH -o logs/01_cov_anvio.log
#SBATCH -e logs/01_cov_anvio.log
#SBATCH -J chytrid_cov_anvio
#SBATCH --mail-type=END # notifications for job done & fail
#SBATCH --mail-user=cassande@ucr.edu # send-to address
#SBATCH --mem=98G #memory
#SBATCH -p intel,batch

module unload miniconda2
module unload anaconda3

module load miniconda3

source activate anvio-7

ANVDIR=anvio
COVDIR=coverage_anvio
CPU=24

mkdir $ANVDIR/$COVDIR

#since we have individual assemblies we need to map reads from each sample to the other samples assembly for megabat
#note I haven't done this before so we will see how it goes
#this part can be removed for co-assemblies


ASSEM=data/Coelomomyces_lativittatus_CIRM-AVA-1-Amber.scaffolds.fa
PREFIX=Amber
LOC=data
AREAD=Amber
OREAD=Orange
MREAD=Meiospore
LOCATION=$LOC/input

anvi-script-reformat-fasta $ASSEM -o $LOC/Amber.scaffolds.fixed.fa -l 0 --simplify-names

bowtie2-build $LOC/Amber.scaffolds.fixed.fa ${ANVDIR}/${COVDIR}/$PREFIX

bowtie2 --threads $CPU -x  ${ANVDIR}/${COVDIR}/$PREFIX -1 ${LOCATION}/$AREAD'DNA_R1.fq.gz' -2 ${LOCATION}/$AREAD'DNA_R2.fq.gz' -S ${ANVDIR}/${COVDIR}/$AREAD'.sam'
samtools view -F 4 -bS ${ANVDIR}/${COVDIR}/$AREAD'.sam' > ${ANVDIR}/${COVDIR}/$AREAD'-RAW.bam'
anvi-init-bam ${ANVDIR}/${COVDIR}/$AREAD'-RAW.bam' -o ${ANVDIR}/${COVDIR}/$AREAD'.bam'

bowtie2 --threads $CPU -x  ${ANVDIR}/${COVDIR}/$PREFIX -1 ${LOCATION}/$OREAD'DNA_R1.fq.gz' -2 ${LOCATION}/$OREAD'DNA_R2.fq.gz' -S ${ANVDIR}/${COVDIR}/$OREAD'.sam'
samtools view -F 4 -bS ${ANVDIR}/${COVDIR}/$OREAD'.sam' > ${ANVDIR}/${COVDIR}/$OREAD'-RAW.bam'
anvi-init-bam ${ANVDIR}/${COVDIR}/$OREAD'-RAW.bam' -o ${ANVDIR}/${COVDIR}/$OREAD'.bam'

bowtie2 --threads $CPU -x  ${ANVDIR}/${COVDIR}/$PREFIX -1 ${LOCATION}/$MREAD'DNA_R1.fq.gz' -2 ${LOCATION}/$MREAD'DNA_R2.fq.gz' -S ${ANVDIR}/${COVDIR}/$MREAD'.sam'
samtools view -F 4 -bS ${ANVDIR}/${COVDIR}/$MREAD'.sam' > ${ANVDIR}/${COVDIR}/$MREAD'-RAW.bam'
anvi-init-bam ${ANVDIR}/${COVDIR}/$MREAD'-RAW.bam' -o ${ANVDIR}/${COVDIR}/$MREAD'.bam'

mkdir ${ANVDIR}/$PREFIX

anvi-gen-contigs-database -f ${LOC}/Amber.scaffolds.fixed.fa -o ${ANVDIR}/${PREFIX}/$PREFIX.db
anvi-run-hmms -c ${ANVDIR}/${PREFIX}/$PREFIX.db --num-threads $CPU
anvi-get-sequences-for-gene-calls -c ${ANVDIR}/${PREFIX}/$PREFIX.db -o ${ANVDIR}/${PREFIX}/$PREFIX.gene.calls.fa
anvi-get-sequences-for-gene-calls -c ${ANVDIR}/${PREFIX}/$PREFIX.db --get-aa-sequences -o ${ANVDIR}/${PREFIX}/$PREFIX.amino.acid.sequences.fa


