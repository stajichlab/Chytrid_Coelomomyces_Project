#python script to filter out contaminant scaffolds
#by cassie ettinger

import sys
import Bio
from Bio import SeqIO

def filter_fasta(input_fasta, output_fasta, contamination): 
	seq_records = SeqIO.parse(input_fasta, format='fasta') #parses the fasta file
	

	with open(contamination) as f:
		contamination_ids_list = f.read().splitlines() #parse the contamination file which is each line as a scaffold id 
	#print(contamination_ids_list)	

	OutputFile = open(output_fasta, 'w') #opens new file to write to
	
	for record in seq_records: 
		if record.id not in contamination_ids_list: 
			OutputFile.write('>'+ record.id +'\n') #writes the scaffold to the file (or assession) 
			OutputFile.write(str(record.seq)+'\n') #writes the seq to the file
			
	OutputFile.close()


filter_fasta("data/Coelomomyces_lativittatus_CIRM-AVA-1-Amber.scaffolds.fa", "data/Coelomomyces_lativittatus_CIRM-AVA-1-Amber.scaffolds.filtered.fa", "anvio/Amber/Amber_SAMPLES_MERGED/SUMMARY_manual/bin_by_bin/Contamination/scaffolds_ided_by_anvio_and_blobtools.txt")	
filter_fasta("data/Coelomomyces_lativittatus_CIRM-AVA-1-Meiospore.scaffolds.fa", "data/Coelomomyces_lativittatus_CIRM-AVA-1-Meiospore.scaffolds.filtered.fa", "blobtools/Coelomomyces_lativittatus_CIRM-AVA-1-Meiospore/scaffolds_bacteria_archaea.txt")	
filter_fasta("data/Coelomomyces_lativittatus_CIRM-AVA-1-Orange.scaffolds.fa", "data/Coelomomyces_lativittatus_CIRM-AVA-1-Orange.scaffolds.filtered.fa", "blobtools/Coelomomyces_lativittatus_CIRM-AVA-1-Orange/scaffolds_bacteria.txt")	
