#Basic stats for gff and annotation files from funannotate
#by Cassie Ettinger

library(tidyverse)
library(vroom)

#read in annotation and gff3 files
# annotations <- vroom("data/Coelomomyces_lativittatus_CIRM-AVA-1-Amber.annotations.txt")
# gff <- vroom("data/Coelomomyces_lativittatus_CIRM-AVA-1-Amber.gff3", skip = 1, col_names = c("scaffold", "software", "feature", "start", "stop", "score", "strand", "frame", "attribute")) #line one is header of gff3
# annotations <- vroom("data/Coelomomyces_lativittatus_CIRM-AVA-1-Orange.annotations.txt")
# gff <- vroom("data/Coelomomyces_lativittatus_CIRM-AVA-1-Orange.gff3", skip = 1, col_names = c("scaffold", "software", "feature", "start", "stop", "score", "strand", "frame", "attribute")) #line one is header of gff3
annotations <- vroom("data/Coelomomyces_lativittatus_CIRM-AVA-1-Meiospore.annotations.txt")
gff <- vroom("data/Coelomomyces_lativittatus_CIRM-AVA-1-Meiospore.gff3", skip = 1, col_names = c("scaffold", "software", "feature", "start", "stop", "score", "strand", "frame", "attribute")) #line one is header of gff3


#coding genes vs. trna
coding.genes <- as.data.frame(summary(as.factor(annotations$Feature)))

#gff features
gff.feat <- group_by(gff, feature)
gff.feat.avgs <- summarise(gff.feat, avg.len = mean(abs(stop - start)))

#construct summary table

annotation.stats <- tibble(Category = c("Number of mRNA genes", "Number of tRNA genes"), Value = c(coding.genes[1,1], coding.genes[2,1]))

total.genes <- sum(annotation.stats$Value)

annotation.stats <- annotation.stats %>% 
  add_row(Category = "Total number of coding genes", Value = total.genes) %>% 
  add_row(Category = "Percentage of genes with PFAM hit", Value = (total.genes - sum(is.na(annotations$PFAM)))/total.genes * 100)  %>%
  add_row(Category = "Percentage of genes with InterProScan hit", Value = (total.genes - sum(is.na(annotations$InterPro)))/total.genes *100)  %>%
  add_row(Category = "Percentage of genes with EggNog hit", Value = (total.genes - sum(is.na(annotations$EggNog)))/total.genes *100) %>%
  add_row(Category = "Percentage of genes with COG hit", Value = (total.genes - sum(is.na(annotations$COG)))/total.genes *100) %>%
  add_row(Category = "Percentage of genes with GO Term", Value = (total.genes - sum(is.na(annotations$`GO Terms`)))/total.genes *100) %>%
  add_row(Category = "Average intron length", Value = gff.feat.avgs$avg.len[gff.feat.avgs$feature == "CDS"]) %>%
  add_row(Category = "Average exon length", Value = gff.feat.avgs$avg.len[gff.feat.avgs$feature == "exon"])  %>%
  add_row(Category = "Average 5'UTR length", Value = gff.feat.avgs$avg.len[gff.feat.avgs$feature == "five_prime_UTR"])  %>%
  add_row(Category = "Average gene length", Value = gff.feat.avgs$avg.len[gff.feat.avgs$feature == "gene"])  %>%
  add_row(Category = "Average 3'UTR length", Value = gff.feat.avgs$avg.len[gff.feat.avgs$feature == "three_prime_UTR"])  %>%
  add_row(Category = "Average tRNA length", Value = gff.feat.avgs$avg.len[gff.feat.avgs$feature == "tRNA"])  %>%
  add_row(Category = "Average mRNA length", Value = gff.feat.avgs$avg.len[gff.feat.avgs$feature == "mRNA"]) 


#write.csv(annotation.stats, "Amber_annotation.stats.csv", row.names = FALSE)
#write.csv(annotation.stats, "Orange_annotation.stats.csv", row.names = FALSE)
write.csv(annotation.stats, "Meio_annotation.stats.csv", row.names = FALSE)

