#!/bin/bash
##
#SBATCH -p intel,batch
#SBATCH -o logs/diamond.log.txt
#SBATCH -e logs/diamond.log.txt
#SBATCH --nodes=1
#SBATCH --ntasks=24 # Number of cores
#SBATCH --mem=128G # Memory pool for all cores (see also --mem-per-cpu)
#SBATCH --mail-type=END # notifications for job done & fail
#SBATCH --mail-user=cassande@ucr.edu # send-to address
#SBATCH -D /rhome/cassande/shared/projects/Chytrid/Coelomomyces/Chytrid_Coelomomyces_Assessment/
#SBATCH -J chytrid_blob_diamond


module unload miniconda2
module load miniconda3
module load diamond/2.0.4
module load blobtools
source activate blobtools
DB=/srv/projects/db/blobPlotDB/2020_10/uniprot_ref_proteomes.diamond.dmnd
ASMDIR=data
CPU=24
COV=coverage

TAXFOLDER=taxonomy
OUTPUT=blobtools

## Amber

PREFIX=Coelomomyces_lativittatus_CIRM-AVA-1-Amber
ASSEMBLY=$(realpath ${ASMDIR}/$PREFIX.scaffolds.fa)


diamond blastx \
	--query $ASSEMBLY \
	--db $DB -c1 --tmpdir /scratch \
	--outfmt 6 \
	--sensitive \
	--max-target-seqs 1 \
	--evalue 1e-25 --threads $CPU \
	--out $OUTPUT/$TAXFOLDER/$PREFIX.diamond.tab

blobtools taxify -f $OUTPUT/$TAXFOLDER/$PREFIX.diamond.tab \
	-m /srv/projects/db/blobPlotDB/2020_10/uniprot_ref_proteomes.taxids \
	-s 0 -t 2 -o $OUTPUT/$TAXFOLDER/

## Orange

PREFIX=Coelomomyces_lativittatus_CIRM-AVA-1-Orange
ASSEMBLY=$(realpath ${ASMDIR}/$PREFIX.scaffolds.fa)


diamond blastx \
	--query $ASSEMBLY \
	--db $DB -c1 --tmpdir /scratch \
	--outfmt 6 \
	--sensitive \
	--max-target-seqs 1 \
	--evalue 1e-25 --threads $CPU \
	--out $OUTPUT/$TAXFOLDER/$PREFIX.diamond.tab

blobtools taxify -f $OUTPUT/$TAXFOLDER/$PREFIX.diamond.tab \
	-m /srv/projects/db/blobPlotDB/2020_10/uniprot_ref_proteomes.taxids \
	-s 0 -t 2 -o $OUTPUT/$TAXFOLDER/


## Meiospore 

PREFIX=Coelomomyces_lativittatus_CIRM-AVA-1-Meiospore
ASSEMBLY=$(realpath ${ASMDIR}/$PREFIX.scaffolds.fa)


diamond blastx \
	--query $ASSEMBLY \
	--db $DB -c1 --tmpdir /scratch \
	--outfmt 6 \
	--sensitive \
	--max-target-seqs 1 \
	--evalue 1e-25 --threads $CPU \
	--out $OUTPUT/$TAXFOLDER/$PREFIX.diamond.tab

blobtools taxify -f $OUTPUT/$TAXFOLDER/$PREFIX.diamond.tab \
	-m /srv/projects/db/blobPlotDB/2020_10/uniprot_ref_proteomes.taxids \
	-s 0 -t 2 -o $OUTPUT/$TAXFOLDER/


