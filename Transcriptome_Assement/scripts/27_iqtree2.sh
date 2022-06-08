#!/usr/bin/bash
#SBATCH --ntasks 24 -N 1 --mem 48gb --time 12-0:00:00 -p intel --out logs/iqtree.%A.log

CPU=$SLURM_CPUS_ON_NODE
if [ -z $CPU ]; then
	CPU=1
fi

module unload perl
module unload python
module unload miniconda2
module load miniconda3
module load IQ-TREE
module load extra
module load GCCcore/7.4.0

NUM=$(wc -l expected_prefixes.lst | awk '{print $1}')
source config.txt
HMM=fungi_odb10
ALN=$PREFIX.${NUM}_taxa.${HMM}.aa.fasaln
iqtree2 -s $ALN -pre ${PREFIX}.${NUM}.${HMM} -alrt 1000 -bb 1000  -m LG+G4 -nt $CPU

