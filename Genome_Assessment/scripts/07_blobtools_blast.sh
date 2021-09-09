#!/bin/bash
##
#SBATCH -p intel,batch
#SBATCH -o logs/blast.log.txt
#SBATCH -e logs/blast.log.txt
#SBATCH --nodes=1
#SBATCH --ntasks=24 # Number of cores
#SBATCH --mem=64G # Memory pool for all cores (see also --mem-per-cpu)
#SBATCH --mail-type=END # notifications for job done & fail
#SBATCH --mail-user=cassande@ucr.edu # send-to address
#SBATCH -D /rhome/cassande/shared/projects/Chytrid/Coelomomyces/Chytrid_Coelomomyces_Assessment/
#SBATCH -J chytrid_blob_blast


module unload miniconda2
module load miniconda3
module load blobtools
source activate blobtools

module load ncbi-blast
DB=/srv/projects/db/NCBI/preformatted/20190709/nt

ASMDIR=data
CPU=24
COV=coverage

TAXFOLDER=taxonomy
OUTPUT=blobtools

## Amber

PREFIX=Coelomomyces_lativittatus_CIRM-AVA-1-Amber
ASSEMBLY=$(realpath ${ASMDIR}/$PREFIX.scaffolds.fa)


blastn \
 -query $ASSEMBLY \
 -db $DB \
 -outfmt '6 qseqid staxids bitscore std' \
 -max_target_seqs 10 \
 -max_hsps 1 -num_threads $CPU \
 -evalue 1e-25 -out $OUTPUT/$TAXFOLDER/$PREFIX.nt.blastn.tab


blobtools taxify -f $OUTPUT/$TAXFOLDER/$PREFIX.nt.blastn.tab \
	-m /srv/projects/db/blobPlotDB/2020_10/uniprot_ref_proteomes.taxids \
	-s 0 -t 2 -o $OUTPUT/$TAXFOLDER/


## Orange

PREFIX=Coelomomyces_lativittatus_CIRM-AVA-1-Orange
ASSEMBLY=$(realpath ${ASMDIR}/$PREFIX.scaffolds.fa)


blastn \
 -query $ASSEMBLY \
 -db $DB \
 -outfmt '6 qseqid staxids bitscore std' \
 -max_target_seqs 10 \
 -max_hsps 1 -num_threads $CPU \
 -evalue 1e-25 -out $OUTPUT/$TAXFOLDER/$PREFIX.nt.blastn.tab


blobtools taxify -f $OUTPUT/$TAXFOLDER/$PREFIX.nt.blastn.tab \
	-m /srv/projects/db/blobPlotDB/2020_10/uniprot_ref_proteomes.taxids \
	-s 0 -t 2 -o $OUTPUT/$TAXFOLDER/



## Meiospore 

PREFIX=Coelomomyces_lativittatus_CIRM-AVA-1-Meiospore
ASSEMBLY=$(realpath ${ASMDIR}/$PREFIX.scaffolds.fa)


blastn \
 -query $ASSEMBLY \
 -db $DB \
 -outfmt '6 qseqid staxids bitscore std' \
 -max_target_seqs 10 \
 -max_hsps 1 -num_threads $CPU \
 -evalue 1e-25 -out $OUTPUT/$TAXFOLDER/$PREFIX.nt.blastn.tab


blobtools taxify -f $OUTPUT/$TAXFOLDER/$PREFIX.nt.blastn.tab \
	-m /srv/projects/db/blobPlotDB/2020_10/uniprot_ref_proteomes.taxids \
	-s 0 -t 2 -o $OUTPUT/$TAXFOLDER/

