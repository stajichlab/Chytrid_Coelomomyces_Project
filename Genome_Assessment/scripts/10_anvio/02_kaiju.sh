#!/bin/bash -l
#
#SBATCH --ntasks 24 #number cores
#SBATCH --mail-type=END # notifications for job done & fail
#SBATCH --mail-user=cassande@ucr.edu # send-to address
#SBATCH -p intel,batch
#SBATCH -D /rhome/cassande/shared/projects/Chytrid/Coelomomyces/Chytrid_Coelomomyces_Assessment/
#SBATCH -o logs/03_kaiju.log
#SBATCH -e logs/03_kaiju.log
#SBATCH -J chytrid_coel_kaiju
#SBATCH --mem=198G #memory



ANVDIR=anvio
PREFIX=Amber
DB=/rhome/cassande/bigdata/software/databases/kaiju
CPU=24

module load kaiju
module unload miniconda2
module unload anaconda3

module load miniconda3

source activate anvio-7


kaiju -z $CPU -t $DB/nodes.dmp -f $DB/kaiju_db_nr_euk.fmi -i  ${ANVDIR}/${PREFIX}/$PREFIX.gene.calls.fa -o ${ANVDIR}/${PREFIX}/$PREFIX.kaiju.out -v

kaiju-addTaxonNames -t $DB/nodes.dmp -n $DB/names.dmp -i ${ANVDIR}/${PREFIX}/$PREFIX.kaiju.out -o ${ANVDIR}/${PREFIX}/$PREFIX.kaiju.names.out -r superkingdom,phylum,class,order,family,genus,species

anvi-import-taxonomy-for-genes -i ${ANVDIR}/${PREFIX}/$PREFIX.kaiju.names.out -c ${ANVDIR}/${PREFIX}/$PREFIX.db -p kaiju --just-do-it
	

