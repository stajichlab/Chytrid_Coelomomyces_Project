#!/bin/bash
#SBATCH -p short -N 1 -n 16 --mem 16gb --out logs/tree_1job.log

module load hmmer/3
module load fasttree

mkdir Tree

hmmalign HMG_box.hmm HMG.hits.aa.fa > HMG.hits.aa.slx # Align the hits to the HMM

esl-reformat afa HMG.hits.aa.slx > HMG.hits.aa.afa # convert to fasta multi-align format

FastTreeMP -gamma -lg < HMG.hits.aa.afa > Tree/HMG.hits.aa.FT.tre
