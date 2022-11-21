#!/bin/bash
#SBATCH -p batch --time 2-0:00:00 --ntasks 8 --nodes 1 --mem 12G 
#SBATCH --out logs/hmmsearch.%a.log

module load hmmer/3

for i in */*.hmm; do

cat pep/*.fasta > allseqs.aa
esl-sfetch --index allseqs.aa
hmmsearch --domtbl ${i}.domtbl -E 1e-5 ${i} allseqs.aa > ${i}.hmmsearch
done
