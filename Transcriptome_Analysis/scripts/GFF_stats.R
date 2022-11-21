#Basic stats for gff and annotation files from funannotate
#by Cassie Ettinger

library(tidyverse)
library(vroom)

#read in annotation and gff3 files
#annotations <- vroom("Homalodisca_vitripennis_A6A7A9_masurca_v1_ragtag_v1.annotations.txt")
amber_gff <- vroom("db/CoelomomycesAmber_Genes.gff3.gz", skip = 1, col_names = c("scaffold", "software", "feature", "start", "stop", "score", "strand", "frame", "attribute")) #line one is header of gff3
meio_gff <- vroom("db/CoelomomycesMeiospore_Genes.gff3.gz", skip = 1, col_names = c("scaffold", "software", "feature", "start", "stop", "score", "strand", "frame", "attribute")) #line one is header of gff3


#gff features
amber_gff.feat <- group_by(amber_gff, feature)
amber_gff.feat.avgs <- summarise(amber_gff.feat, avg.len = mean(abs(stop - start)))
summary(as.factor(amber_gff.feat$feature))

meio_gff.feat <- group_by(meio_gff, feature)
meio_gff.feat.avgs <- summarise(meio_gff.feat, avg.len = mean(abs(stop - start)))
summary(as.factor(meio_gff.feat$feature))


#construct summary table
# 
amber.annotation.stats <- tibble(Category = c("Number of mRNA genes", "Number of tRNA genes"), Value = c(length(amber_gff.feat$feature[amber_gff.feat$feature == 'mRNA']), length(amber_gff.feat$feature[amber_gff.feat$feature == 'tRNA'])))
# 
# total.genes <- sum(annotation.stats$Value)
amber.total.genes <- length(amber_gff.feat$feature[amber_gff.feat$feature == 'gene'])



amber.annotation.stats <- amber.annotation.stats %>% 
  add_row(Category = "Total number of coding genes", Value = amber.total.genes) %>% 
  add_row(Category = "Number of exons", Value = length(amber_gff.feat$feature[amber_gff.feat$feature == 'exon'])) %>% 
  #add_row(Category = "Percentage of genes with PFAM hit", Value = (total.genes - sum(is.na(annotations$PFAM)))/total.genes * 100)  %>%
  #add_row(Category = "Percentage of genes with InterProScan hit", Value = (total.genes - sum(is.na(annotations$InterPro)))/total.genes *100)  %>%
  #add_row(Category = "Percentage of genes with EggNog hit", Value = (total.genes - sum(is.na(annotations$EggNog)))/total.genes *100) %>%
  #add_row(Category = "Percentage of genes with GO Term", Value = (total.genes - sum(is.na(annotations$`GO Terms`)))/total.genes *100) %>%
  add_row(Category = "Average intron length", Value = amber_gff.feat.avgs$avg.len[amber_gff.feat.avgs$feature == "CDS"]) %>%
  add_row(Category = "Average exon length", Value = amber_gff.feat.avgs$avg.len[amber_gff.feat.avgs$feature == "exon"])  %>%
  #add_row(Category = "Average 5'UTR length", Value = amber_gff.feat.avgs$avg.len[amber_gff.feat.avgs$feature == "five_prime_UTR"])  %>%
  add_row(Category = "Average gene length", Value = amber_gff.feat.avgs$avg.len[amber_gff.feat.avgs$feature == "gene"])  %>%
  #add_row(Category = "Average 3'UTR length", Value = amber_gff.feat.avgs$avg.len[amber_gff.feat.avgs$feature == "three_prime_UTR"])  %>%
  add_row(Category = "Average tRNA length", Value = amber_gff.feat.avgs$avg.len[amber_gff.feat.avgs$feature == "tRNA"])  %>%
  add_row(Category = "Average mRNA length", Value = amber_gff.feat.avgs$avg.len[amber_gff.feat.avgs$feature == "mRNA"]) 


write.csv(amber.annotation.stats, "results/amber.annotation.stats.csv", row.names = FALSE)


#construct summary table
# 
meio.annotation.stats <- tibble(Category = c("Number of mRNA genes", "Number of tRNA genes"), Value = c(length(meio_gff.feat$feature[meio_gff.feat$feature == 'mRNA']), length(meio_gff.feat$feature[meio_gff.feat$feature == 'tRNA'])))
# 
# total.genes <- sum(annotation.stats$Value)
meio.total.genes <- length(meio_gff.feat$feature[meio_gff.feat$feature == 'gene'])



meio.annotation.stats <- meio.annotation.stats %>% 
  add_row(Category = "Total number of coding genes", Value = meio.total.genes) %>% 
  add_row(Category = "Number of exons", Value = length(meio_gff.feat$feature[meio_gff.feat$feature == 'exon'])) %>% 
  #add_row(Category = "Percentage of genes with PFAM hit", Value = (total.genes - sum(is.na(annotations$PFAM)))/total.genes * 100)  %>%
  #add_row(Category = "Percentage of genes with InterProScan hit", Value = (total.genes - sum(is.na(annotations$InterPro)))/total.genes *100)  %>%
  #add_row(Category = "Percentage of genes with EggNog hit", Value = (total.genes - sum(is.na(annotations$EggNog)))/total.genes *100) %>%
  #add_row(Category = "Percentage of genes with GO Term", Value = (total.genes - sum(is.na(annotations$`GO Terms`)))/total.genes *100) %>%
  add_row(Category = "Average intron length", Value = meio_gff.feat.avgs$avg.len[meio_gff.feat.avgs$feature == "CDS"]) %>%
  add_row(Category = "Average exon length", Value = meio_gff.feat.avgs$avg.len[meio_gff.feat.avgs$feature == "exon"])  %>%
  #add_row(Category = "Average 5'UTR length", Value = meio_gff.feat.avgs$avg.len[meio_gff.feat.avgs$feature == "five_prime_UTR"])  %>%
  add_row(Category = "Average gene length", Value = meio_gff.feat.avgs$avg.len[meio_gff.feat.avgs$feature == "gene"])  %>%
  #add_row(Category = "Average 3'UTR length", Value = meio_gff.feat.avgs$avg.len[meio_gff.feat.avgs$feature == "three_prime_UTR"])  %>%
  add_row(Category = "Average tRNA length", Value = meio_gff.feat.avgs$avg.len[meio_gff.feat.avgs$feature == "tRNA"])  %>%
  add_row(Category = "Average mRNA length", Value = meio_gff.feat.avgs$avg.len[meio_gff.feat.avgs$feature == "mRNA"]) 


write.csv(meio.annotation.stats, "results/meio.annotation.stats.csv", row.names = FALSE)




