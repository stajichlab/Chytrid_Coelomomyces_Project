#!/usr/bin/bash
#SBATCH -p intel,batch
#SBATCH --nodes=1
#SBATCH --ntasks=16 # Number of cores
#SBATCH --mem=48G # Memory pool for all cores (see also --mem-per-cpu)
#SBATCH -D /rhome/cassande/shared/projects/Chytrid/Coelomomyces/Chytrid_Coelomomyces_Assessment/
#SBATCH -J Chytrid_jellyfish
#SBATCH -o logs/jellyfish.log
#SBATCH -e logs/jellyfish.log
#SBATCH --mail-type=END # notifications for job done & fail
#SBATCH --mail-user=cassande@ucr.edu # send-to address
#SBATCH --time=24:00:00



module load jellyfish/2.3.0
CPU=16

LOCATION=data/input
SAMPFILE=samples.csv

mkdir jellfish_results

IFS=,
tail -n +2 $SAMPFILE | sed -n ${N}p | while read PREFIX FREAD RREAD 
do 

	jellyfish count -C -m 21 -s 2G -t 16 <(zcat ${LOCATION}/$FREAD) <(zcat ${LOCATION}/$RREAD) -o jellfish_results/$PREFIX.jf

	jellyfish histo -t 16 jellfish_results/$PREFIX.jf > jellfish_results/$PREFIX.jf.histo

done





