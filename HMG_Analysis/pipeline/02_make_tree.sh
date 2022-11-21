#!/bin/bash
#SBATCH -p intel -N 1 -n 16 --mem 16gb --out logs/trees.log

module load muscle
module load iqtree

for t in */*.hits.aa.fa; do

muscle -align ${t} -output ${t}.fasaln

iqtree2 -s ${t}.fasaln -B 1000 -alrt 1000

done
