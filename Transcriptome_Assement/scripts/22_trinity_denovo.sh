#!/bin/bash
##
#SBATCH -o logs/22_trinity.log
#SBATCH -e logs/22_trinity.log
#SBATCH --nodes=1
#SBATCH --ntasks=12 # Number of cores
#SBATCH --mem=250G # Memory pool for all cores (see also --mem-per-cpu)
#SBATCH -J chytid_trinity
#SBATCH -p intel


#module load trinity-rnaseq
module load trinity-rnaseq/2.13.2
#module load fastqc
module load samtools
module load jellyfish
module load bowtie2
module load salmon

READS=mosquito_host_bbduk
CPU=12
MEM=250G

#fastqc $RAW/*.fq.gz
#look like adapters and trimming done with sickle/adapterremoval before & fastqc look OK in this sense


export PATH="/rhome/cassande/.local/bin/:$PATH"
Trinity --seqType fq --max_memory $MEM --trimmomatic --normalize_reads --output trinity_out_no_host_bbduk --left $READS/left.fq --right $READS/right.fq --CPU $CPU


