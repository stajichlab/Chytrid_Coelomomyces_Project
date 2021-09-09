#!/usr/bin/bash
#SBATCH -p intel,batch
#SBATCH -o logs/log.blob.create.txt
#SBATCH -e logs/log.blob.create.txt
#SBATCH --nodes=1
#SBATCH --ntasks=16 # Number of cores
#SBATCH --mem=32G # Memory pool for all cores (see also --mem-per-cpu)
#SBATCH -J chytrid_blob2_create


module unload miniconda2
module load miniconda3

module load db-ncbi
module load db-uniprot

#activate blobtools 2 env
#conda activate btk_env
source activate btk_env

export PATH=$PATH:/rhome/cassande/bigdata/software/blobtoolkit/blobtools2

TAXFOLDER=taxonomy
COV=coverage
OUTPUT=blobtools
READDIR=input
ASMDIR=data


## Amber

PREFIX=Coelomomyces_lativittatus_CIRM-AVA-1-Amber
READ=Amber

COVTAB=$BAM.cov
PROTTAX=${OUTPUT}/${TAXFOLDER}/$PREFIX.diamond.tab.taxified.out
BLASTTAX=${OUTPUT}/${TAXFOLDER}/$PREFIX.nt.blastn.tab.taxified.out

ASSEMBLY=${ASMDIR}/$PREFIX.scaffolds.fa
BAM=${OUTPUT}/${COV}/$PREFIX.remap.bam
FWD=${ASMDIR}/${READDIR}/${READ}DNA_R1.fq.gz
REV=${ASMDIR}/${READDIR}/${READ}DNA_R2.fq.gz


#create blob
blobtools create --fasta $ASSEMBLY --replace ${OUTPUT}/$PREFIX 

blobtools add --cov $BAM --threads 16 --replace ${OUTPUT}/$PREFIX

blobtools add --hits $PROTTAX --hits $BLASTTAX --taxrule bestsumorder --taxdump /rhome/cassande/bigdata/software/blobtoolkit/taxdump/ --replace ${OUTPUT}/$PREFIX

## Orange

PREFIX=Coelomomyces_lativittatus_CIRM-AVA-1-Orange
READ=Orange

COVTAB=$BAM.cov
PROTTAX=${OUTPUT}/${TAXFOLDER}/$PREFIX.diamond.tab.taxified.out
BLASTTAX=${OUTPUT}/${TAXFOLDER}/$PREFIX.nt.blastn.tab.taxified.out

ASSEMBLY=${ASMDIR}/$PREFIX.scaffolds.fa
BAM=${OUTPUT}/${COV}/$PREFIX.remap.bam
FWD=${ASMDIR}/${READDIR}/${READ}DNA_R1.fq.gz
REV=${ASMDIR}/${READDIR}/${READ}DNA_R2.fq.gz


#create blob
blobtools create --fasta $ASSEMBLY --replace ${OUTPUT}/$PREFIX 

blobtools add --cov $BAM --threads 16 --replace ${OUTPUT}/$PREFIX

blobtools add --hits $PROTTAX --hits $BLASTTAX --taxrule bestsumorder --taxdump /rhome/cassande/bigdata/software/blobtoolkit/taxdump/ --replace ${OUTPUT}/$PREFIX


## Meiospore 

PREFIX=Coelomomyces_lativittatus_CIRM-AVA-1-Meiospore
READ=Meiospore

COVTAB=$BAM.cov
PROTTAX=${OUTPUT}/${TAXFOLDER}/$PREFIX.diamond.tab.taxified.out
BLASTTAX=${OUTPUT}/${TAXFOLDER}/$PREFIX.nt.blastn.tab.taxified.out

ASSEMBLY=${ASMDIR}/$PREFIX.scaffolds.fa
BAM=${OUTPUT}/${COV}/$PREFIX.remap.bam
FWD=${ASMDIR}/${READDIR}/${READ}DNA_R1.fq.gz
REV=${ASMDIR}/${READDIR}/${READ}DNA_R2.fq.gz


#create blob
blobtools create --fasta $ASSEMBLY --replace ${OUTPUT}/$PREFIX 

blobtools add --cov $BAM --threads 16 --replace ${OUTPUT}/$PREFIX

blobtools add --hits $PROTTAX --hits $BLASTTAX --taxrule bestsumorder --taxdump /rhome/cassande/bigdata/software/blobtoolkit/taxdump/ --replace ${OUTPUT}/$PREFIX
