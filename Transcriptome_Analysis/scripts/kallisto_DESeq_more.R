#kallisto deseq 
#By Cassie Ettinger

#need to get DEG and up and down (I think?) for GO enirchment

#load libraries
library(DESeq2)
library(tximport)
library(dplyr)
library(ggplot2)
library(magrittr)
library(Biobase)
library(pheatmap)
library(RColorBrewer)

#read data in 

samples <- read.table("samples.csv",header=TRUE,sep=",")
samples$Name = sprintf("%s.r%s",samples$Condition,samples$Replicate)
samples$Name
files <- file.path("results","kallisto_AOM90_BBNH",samples$Name,"abundance.tsv")
txi.kallisto <- tximport(files, type = "kallisto", txOut = TRUE)
head(txi.kallisto$counts)
colnames(txi.kallisto$counts) <- samples$Name
colnames(txi.kallisto$abundance) <- samples$Name

#going to group data here - otherwise would need to deal with contrasts and loops 
#just testing pipeline now so this is easier to start with
#plus big differences in heatmap from kallisto_DESeq_1var.R report show differences
#between these two groups
samples$Stage <- c("Inf", "Inf", "Inf", "Inf", "Inf", "Inf", "Spor", "Spor","Spor", "Spor","Spor", "Spor","Spor", "Spor" )

# DEseq2 set-up
treatment = samples$Stage

sampleTable <- data.frame(condition=treatment)
sampleTable$condition <- factor(sampleTable$condition)

rownames(sampleTable) = samples$Name

#import data into deseq looking at "condition" which is Spor vs. Inf
dds <- DESeqDataSetFromTximport(txi.kallisto,sampleTable, ~ condition)

dds <- dds[ rowSums(counts(dds)) > 1, ]


dds <- estimateSizeFactors(dds)

#run deseq diff abundance analysis
dds.test <- DESeq(dds)

#get results
#this is where we would need contrasts / loops
#if we had more than two groups to compare
res <- results(dds.test) 

#get only results that are sig & have log fold change >2
res.sig <- subset(res, (padj < 0.01 & abs(log2FoldChange) >2))

#write table with all differentially expressed genes (DEG) between Spo and Inf
write.table(res.sig, "results/deseq_kallisto/Result_DEGs.tsv", 
            quote=F, 
            row.names=T, 
            sep="\t")

#write table of gene ids of all DEG
write.table(rownames(res.sig),
            file="results/deseq_kallisto/allDEGs.tsv",
            quote=F,
            row.names = F,
            col.names = F)

#write table with gene ids more expressed in spor group
write.table(rownames(res.sig[res.sig$log2FoldChange>0,]),
            file="results/deseq_kallisto/Result_Up.tsv",
            quote=F,
            row.names = F,
            col.names = F) #up in spor, sown in inf

#write table with genes more expressed in inf group 
write.table(rownames(res.sig[res.sig$log2FoldChange<0,]),
            file="results/deseq_kallisto/Result_Down.tsv",
            quote=F,
            row.names = F,
            col.names = F) #up in inf, down in spor

#add annotation information to DEG table
library(vroom)
res.sig.table <- read.table("results/deseq_kallisto/Result_DEGs.tsv")
annotation <- vroom("db/Coelomomyces_lativittatus_CIRM-AVA-1-Meiospore.annotations.txt")

#add annotation information to DEG table
library(vroom)
res.sig.table <- read.table("results/deseq_kallisto/Result_DEGs.tsv")
annotation <- vroom("db/CoelomomycesAOM90.annotation.txt")

#making sure the names line up
annotation$GeneID <- paste0(annotation$GeneID, "-T1")
res.sig.table$GeneID <- row.names(res.sig.table)

#join tables
res.sig.with.annot <- left_join(res.sig.table, annotation)

#which direction is expression?
res.sig.with.annot.v2 <- res.sig.with.annot %>% mutate(Expression=ifelse(log2FoldChange > 2, "Sporangia", "Infection"))

#write table with annotation information
write.table(res.sig.with.annot.v2, "results/deseq_kallisto/Result_DEGs_annot.tsv", 
            quote=F, 
            row.names=F, 
            sep="\t")

