#!/bin/bash
#SBATCH -p short -N 1 -n 16 --mem 16gb --out logs/download.log

#start by identifying the genes of interest and downloading them. 

curl -o C1_cysteine_protease.hmm http://pfam.xfam.org/family/PF00112/hmm #Insect_path
curl -o Trypsin_protease.hmm http://pfam.xfam.org/family/PF00112/hmm #Insect_path
curl -o HMG_Box.hmm http://pfam.xfam.org/family/PF00505/hmm #mating
curl -o Ecdysone_receptor_zfC4.hmm http://pfam.xfam.org/family/PF00104/hmm #insect_association
curl -o Ecdysone_receptor_hormone.hmm http://pfam.xfam.org/family/PF00105/hmm #insect_association
curl -o Photochrome.hmm http://pfam.xfam.org/family/PF00360/hmm #Photosensing
curl -o lycopene_cyclase.hmm http://pfam.xfam.org/family/PF05834/hmm #B-carotene synthesis
curl -o BCMO1.hmm http://pfam.xfam.org/family/PF03055/hmm #Beta,beta-carotene 15,15'-monooxygenase F. oxy

for file in *.hmm; do dir=$(echo $file | cut -d. -f1); mkdir -p $dir; mv $file $dir; done

#add another pep file for comparisons. We can add more too. 

wget https://ftp.ncbi.nlm.nih.gov/genomes/genbank/fungi/Metarhizium_anisopliae/latest_assembly_versions/GCA_000739145.1_Metarhizium_anisopliae/GCA_000739145.1_Metarhizium_anisopliae_protein.faa.gz
pigz GCA_000739145.1_Metarhizium_anisopliae_protein.faa.gz


ln -s /rhome/myaco005/bigdata/chytrid/Coelomomyces/gene_counts/pep
mv GCA_000739145.1_Metarhizium_anisopliae_protein.faa pep/Metarhizium_anisopliae_protein.fasta
