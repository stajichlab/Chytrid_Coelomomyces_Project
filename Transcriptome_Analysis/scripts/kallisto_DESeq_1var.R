library(DESeq2)
library(tximport)
library(dplyr)
library(ggplot2)
library(magrittr)
library(Biobase)
library(pheatmap)
library(RColorBrewer)
library(ggplotify)
library(patchwork)

samples <- read.table("samples.csv",header=TRUE,sep=",")
#samples$Name = sprintf("%s.%s.r%s",samples$Genotype,samples$Treatment,samples$Replicate)
samples$Name = sprintf("%s.r%s",samples$Condition,samples$Replicate)
samples$Name
files <- file.path("results","kallisto_AOM90_BBNH",samples$Name,"abundance.tsv")
txi.kallisto <- tximport(files, type = "kallisto", txOut = TRUE)
head(txi.kallisto$counts)
colnames(txi.kallisto$counts) <- samples$Name
colnames(txi.kallisto$abundance) <- samples$Name
write.csv(txi.kallisto$abundance,"reports/kallisto.TPM.csv")
write.csv(txi.kallisto$counts,"reports/kallisto.counts.csv")

# DEseq2 analyses
#geno = samples$Genotype
treatment = samples$Condition

#sampleTable <- data.frame(condition=treatment,
#                          genotype = geno)
			  
sampleTable <- data.frame(condition=treatment)
sampleTable$condition <- factor(sampleTable$condition)

rownames(sampleTable) = samples$Name


#dds <- DESeqDataSetFromTximport(txi.kallisto,sampleTable,~ condition + genotype)
dds <- DESeqDataSetFromTximport(txi.kallisto,sampleTable, ~ condition)

#nrow(dds)
dds <- dds[ rowSums(counts(dds)) > 1, ]
#nrow(dds)

dds <- estimateSizeFactors(dds)
vsd <- vst(dds, blind=FALSE)
#rld <- rlog(dds, blind=FALSE)
head(assay(vsd), 3)

df <- bind_rows(
  as_tibble(log2(counts(dds, normalized=TRUE)[, 1:2]+1)) %>%
         mutate(transformation = "log2(x + 1)"),
#  as_data_frame(assay(rld)[, 1:2]) %>% mutate(transformation = "rlog"),
  as_tibble(assay(vsd)[, 1:2]) %>% mutate(transformation = "vst"))

colnames(df)[1:2] <- c("x", "y")

#pdf("plots/RNASeq_kallisto.pdf")
ggplot(df, aes(x = x, y = y)) + geom_hex(bins = 80) +
  coord_fixed() + facet_grid( . ~ transformation)


######

res.sig.degs <- read.delim("results/deseq_kallisto/Result_DEGs.tsv")
#select_pval <- order(res.sig.degs$padj, decreasing=FALSE)[1:25]
select_mean <- order(res.sig.degs$baseMean, decreasing=TRUE)[1:25]

#select_pval_all <- order(res.sig.degs$log2FoldChange, decreasing=TRUE)

#res.sig.degs.select.pval <- rownames(res.sig.degs[select_pval,])
res.sig.degs.select.mean <- rownames(res.sig.degs[select_mean,])
#res.sig.degs.all <-rownames(res.sig.degs[select_pval_all,])

#select <- order(rowMeans(counts(dds,normalized=TRUE)),
#                decreasing=TRUE)[1:25]
#df <- as.data.frame(colData(dds)[,c("condition","genotype")])
#df <- as.data.frame(colData(dds)[,c("condition")])


#heatmap_data <- assay(vsd)[select,]
#heatmap_data <- assay(vsd)[res.sig.degs.select.pval,]
heatmap_data <- assay(vsd)[res.sig.degs.select.mean,]
#heatmap_data <- assay(vsd)[res.sig.degs.all,]

colnames(heatmap_data) <-  c("Early Infection (A)", "Early Infection (B)", "Late Infection (A)", "Late Infection (B)", "Middle Infection (A)", "Middle Infection (B)", "Sporangia 0 hr (A)", "Sporangia 0 hr (B)", "Sporangia 24 hr (A)", "Sporangia 24 hr (B)", "Sporangia 36 hr (A)", "Sporangia 36 hr (B)", "Sporangia 48 hr (A)", "Sporangia 48 hr (B)")
col_order <-c("Early Infection (A)", "Early Infection (B)", "Middle Infection (A)", "Middle Infection (B)", "Late Infection (A)", "Late Infection (B)", "Sporangia 0 hr (A)", "Sporangia 0 hr (B)", "Sporangia 24 hr (A)", "Sporangia 24 hr (B)", "Sporangia 36 hr (A)", "Sporangia 36 hr (B)", "Sporangia 48 hr (A)", "Sporangia 48 hr (B)")
heatmap_data <- heatmap_data[, col_order]

LifeStage <- c("Infection", "Infection", "Infection", "Infection", "Infection", "Infection", "Sporangia","Sporangia","Sporangia","Sporangia","Sporangia","Sporangia","Sporangia","Sporangia" )
Timepoint <- c("Early Infection", "Early Infection", "Middle Infection", "Middle Infection", "Late Infection", "Late Infection", "Sporangia 0 hr", "Sporangia 0 hr", "Sporangia 24 hr", "Sporangia 24 hr", "Sporangia 36 hr", "Sporangia 36 hr", "Sporangia 48 hr", "Sporangia 48 hr")

sampd <- data.frame(Timepoint=Timepoint, LifeStage=LifeStage)
sampd$Timepoint <- factor(sampd$Timepoint, 
                          levels = c("Early Infection", "Middle Infection", "Late Infection", 
                                     "Sporangia 0 hr", "Sporangia 24 hr", "Sporangia 36 hr", 
                                     "Sporangia 48 hr"))

rownames(sampd) <- colnames(heatmap_data)

ann_colors = list(
  LifeStage = c(Infection = "gray", Sporangia = "black"),
  Timepoint = c("Early Infection" = "#E69F00","Middle Infection" = "#56B4E9","Late Infection" = "#009E73","Sporangia 0 hr"= "#F0E442","Sporangia 24 hr"= "#0072B2","Sporangia 36 hr"= "#D55E00", "Sporangia 48 hr" ="#CC79A7"))

ph <- as.ggplot(pheatmap(heatmap_data, cluster_rows=FALSE, show_rownames=TRUE,
         cluster_cols=FALSE,annotation_col=sampd,  annotation_colors = ann_colors))

ph

ggsave(filename = 'plots/heatmap_deg_top25_basemean.pdf', plot = last_plot(), device = 'pdf', width = 7, height = 6, dpi = 300)


sampleDists <- dist(t(assay(vsd)))
sampleDistMatrix <- as.matrix(sampleDists)
#rownames(sampleDistMatrix) <- paste(vsd$condition, vsd$genotype, sep="-")
rownames(sampleDistMatrix) <- vsd$condition
colnames(sampleDistMatrix) <- NULL
colors <- colorRampPalette( rev(brewer.pal(9, "Blues")) )(255)
pheatmap(sampleDistMatrix,
         clustering_distance_rows=sampleDists,
         clustering_distance_cols=sampleDists,
         col=colors)

#pcaData <- plotPCA(vsd, intgroup=c("condition", "genotype"), returnData=TRUE)
pcaData <- plotPCA(vsd, intgroup=c("condition"), returnData=TRUE)
percentVar <- round(100 * attr(pcaData, "percentVar"))

pcaData$treatment <- c("Infection", "Infection", "Infection", "Infection", "Infection", "Infection", "Sporangia","Sporangia","Sporangia","Sporangia","Sporangia","Sporangia","Sporangia","Sporangia" )
pcaData$newcond <- c("Early Infection", "Early Infection", "Late Infection", "Late Infection", "Middle Infection", "Middle Infection", "Sporangia 0 hr", "Sporangia 0 hr", "Sporangia 24 hr", "Sporangia 24 hr", "Sporangia 36 hr", "Sporangia 36 hr", "Sporangia 48 hr", "Sporangia 48 hr")

pcaData$newcond <- factor(pcaData$newcond, 
                          levels = c("Early Infection", "Middle Infection", "Late Infection", 
                                     "Sporangia 0 hr", "Sporangia 24 hr", "Sporangia 36 hr", 
                                     "Sporangia 48 hr"))

#ggplot(pcaData, aes(PC1, PC2, color=genotype, shape=condition)) +
ord <- ggplot(pcaData, aes(PC1, PC2, color=newcond, shape=treatment)) +
    geom_point(size=4) +
    xlab(paste0("PC1: ",percentVar[1],"% variance")) +
    ylab(paste0("PC2: ",percentVar[2],"% variance")) +
    coord_fixed() + 
    theme(text = element_text(size = 12)) + 
  labs(color = "Timepoint", shape = "Life Stage") + 
  scale_color_manual(values =  c("#E69F00", "#56B4E9", "#009E73", "#F0E442", "#0072B2", "#D55E00", "#CC79A7")) +
  stat_ellipse(aes(group = treatment))

ord
ggsave(filename = 'plots/ordination_guides.pdf', plot = last_plot(), device = 'pdf', width = 7, height = 5, dpi = 300)


# ph + ord + 
#   plot_layout(widths = c(2.5, 1))  + plot_annotation(tag_levels = 'A') + plot_layout(guides = "collect") 
# 
# # 
# # 
# # (ord / ph)  + plot_annotation(tag_levels = 'A') + plot_layout(heights = c(1, 2.5))
# # ggsave(filename = 'plots/combined_right_v2.pdf', plot = last_plot(), device = 'pdf', width = 12, height = 6, dpi = 300)
