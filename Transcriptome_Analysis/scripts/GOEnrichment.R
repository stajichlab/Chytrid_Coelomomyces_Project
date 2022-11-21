#GO Enrichment script
#By Cassie Ettinger

library(tidyverse)
library(ggplot2)
library(vroom)
library(AnnotationDbi)
library(GSEABase)
library(GOstats)


## Bash commands:
# grep "gene" CoelomomycesMeiospore_Genes.gff3 | cut -f9 | sort | uniq | sed 's/ID=//' | sed 's/[;].*//' > all_genes.txt
# sort all_genes.txt | uniq > universal_genes.txt 
# rm all_genes.txt
## note could have just gone to genome for this - but oh my poor brain didn't think of that until later, oh well
#
# grep "GO" CoelomomycesMeiospore_Genes.gff3 | cut -f9 | sort | uniq | sed 's/ID=//' | sed 's/[-T].*//' > CM_genes_uniq.txt
# grep "GO" CoelomomycesMeiospore_Genes.gff3 | cut -f9 | sort | uniq | sed 's/^.*.Ontology_term=//' | sed 's/[;].*//' | sed 's/,/|/g' > CM_GO.txt
# paste -d'\t' CM_genes_uniq.txt CM_GO.txt > CM_gogenes.txt
# 
# rm  CM_genes_uniq.txt CM_GO.txt
#
## Remove the -T1 from gene names
# sort results/deseq_kallisto/Result_Up.tsv | uniq | sed 's/[-T].*//' > results/deseq_kallisto/Results_Up.tsv 
# sort results/deseq_kallisto/Result_Down.tsv | uniq | sed 's/[-T].*//' > results/deseq_kallisto/Results_Down.tsv 
# sort results/deseq_kallisto/allDEGs.tsv | uniq | sed 's/[-T].*//' > results/deseq_kallisto/all_DEG.tsv 
# rm Result_Up.tsv Result_Down.tsv allDEGs.tsv

#load datasets

#load in genes and respective GO IDS
meiospore <- vroom('db/CoelomomycesAOM90.GO.txt', col_names = c("GeneID", "GO"))

#list of all genes in genome
all_genes <- read.delim('db/AOM_universal_genes.txt',header = FALSE)

#respective outputs of kalisto_DESeq_more.R
enrich.spo <- read.delim('results/deseq_kallisto/Results_Up.tsv', header =FALSE)
enrich.inf <- read.delim('results/deseq_kallisto/Results_Down.tsv', header =FALSE)
deg <- read.delim('results/deseq_kallisto/all_DEG.tsv', header =FALSE)


#split GO IDs into individual rows
meiospore.go <- meiospore %>%
  separate_rows(GO, sep="\\|")


# GO Analyses
# following https://github.com/stajichlab/Bd_Zoo-Spor_Analysis2015
# as input genes of interest here I am using genes 
# that are expressed more in one group (e.g. Spor / Inf) over the other
# not sure that is right approach - esp when asking about GO 'underenrichment' 


#make GO dataframe: #GO ID, #IEA, #GeneID
meiospore.goframeData <- data.frame(meiospore.go$GO, "IEA", meiospore.go$GeneID)
meiospore.goFrame <- GOFrame(meiospore.goframeData,organism="Coelomomyces lativittatus")
meiospore.goAllFrame=GOAllFrame(meiospore.goFrame)

meiospore.gsc <- GeneSetCollection(meiospore.goAllFrame, setType = GOCollection())


# Sporangia

params <- GSEAGOHyperGParams(name="My Custom GSEA based annot Params",
                             geneSetCollection=meiospore.gsc,
                             geneIds = enrich.spo$V1,
                             universeGeneIds = all_genes$V1,
                             ontology = "MF",
                             pvalueCutoff = 0.05,
                             conditional = FALSE,
                             testDirection = "over")

Over <- hyperGTest(params)
summary(Over)
Over
write.csv(summary(Over),"results/GO_enrich_kallisto/Spo_OverMF_enrich.csv");

paramsCC <- GSEAGOHyperGParams(name="My Custom GSEA based annot Params",
                               geneSetCollection=meiospore.gsc,
                               geneIds = enrich.spo$V1,
                               universeGeneIds = all_genes$V1,
                               ontology = "CC",
                               pvalueCutoff = 0.05,
                               conditional = FALSE,
                               testDirection = "over")

OverCC <- hyperGTest(paramsCC)
summary(OverCC)
OverCC
write.csv(summary(OverCC),"results/GO_enrich_kallisto/Spo_OverCC_enrich.csv");

paramsBP <- GSEAGOHyperGParams(name="My Custom GSEA based annot Params",
                               geneSetCollection=meiospore.gsc,
                               geneIds = enrich.spo$V1,
                               universeGeneIds = all_genes$V1,
                               ontology = "BP",
                               pvalueCutoff = 0.05,
                               conditional = FALSE,
                               testDirection = "over")

OverBP <- hyperGTest(paramsBP)
summary(OverBP)
OverBP
write.csv(summary(OverBP),"results/GO_enrich_kallisto/Spo_OverBP_enrich.csv");


params <- GSEAGOHyperGParams(name="My Custom GSEA based annot Params",
                             geneSetCollection=meiospore.gsc,
                             geneIds = enrich.spo$V1,
                             universeGeneIds = all_genes$V1,
                             ontology = "MF",
                             pvalueCutoff = 0.05,
                             conditional = FALSE,
                             testDirection = "under")


Under <- hyperGTest(params)
summary(Under)
Under
write.csv(summary(Under),"results/GO_enrich_kallisto/Spo_UnderMF_enrich.csv");


paramsCC <- GSEAGOHyperGParams(name="My Custom GSEA based annot Params",
                               geneSetCollection=meiospore.gsc,
                               geneIds = enrich.spo$V1,
                               universeGeneIds = all_genes$V1,
                               ontology = "CC",
                               pvalueCutoff = 0.05,
                               conditional = FALSE,
                               testDirection = "under")

UnderCC <- hyperGTest(paramsCC)
summary(UnderCC)
UnderCC
write.csv(summary(UnderCC),"results/GO_enrich_kallisto/Spo_UnderCC_enrich.csv");

paramsBP <- GSEAGOHyperGParams(name="My Custom GSEA based annot Params",
                               geneSetCollection=meiospore.gsc,
                               geneIds = enrich.spo$V1,
                               universeGeneIds = all_genes$V1,
                               ontology = "BP",
                               pvalueCutoff = 0.05,
                               conditional = FALSE,
                               testDirection = "under")

UnderBP <- hyperGTest(paramsBP)
summary(UnderBP)
UnderBP
write.csv(summary(UnderBP),"results/GO_enrich_kallisto/Spo_UnderBP_enrich.csv");


## Inf

params <- GSEAGOHyperGParams(name="My Custom GSEA based annot Params",
                             geneSetCollection=meiospore.gsc,
                             geneIds = enrich.inf$V1,
                             universeGeneIds = all_genes$V1,
                             ontology = "MF",
                             pvalueCutoff = 0.05,
                             conditional = FALSE,
                             testDirection = "over")

Over <- hyperGTest(params)
summary(Over)
Over
write.csv(summary(Over),"results/GO_enrich_kallisto/Inf_OverMF_enrich.csv")

paramsCC <- GSEAGOHyperGParams(name="My Custom GSEA based annot Params",
                               geneSetCollection=meiospore.gsc,
                               geneIds = enrich.inf$V1,
                               universeGeneIds = all_genes$V1,
                               ontology = "CC",
                               pvalueCutoff = 0.05,
                               conditional = FALSE,
                               testDirection = "over")

OverCC <- hyperGTest(paramsCC)
summary(OverCC)
OverCC
write.csv(summary(OverCC),"results/GO_enrich_kallisto/Inf_OverCC_enrich.csv")







paramsBP <- GSEAGOHyperGParams(name="My Custom GSEA based annot Params",
                               geneSetCollection=meiospore.gsc,
                               geneIds = enrich.inf$V1,
                               universeGeneIds = all_genes$V1,
                               ontology = "BP",
                               pvalueCutoff = 0.05,
                               conditional = FALSE,
                               testDirection = "over")

OverBP <- hyperGTest(paramsBP)
summary(OverBP)
OverBP
write.csv(summary(OverBP),"results/GO_enrich_kallisto/Inf_OverBP_enrich.csv")


ggplot(overBP_inf, aes(x=ExtraTerm, y=-log10(Fisher), fill=Significant)) +
  stat_summary(geom = "bar", fun = mean, position = "dodge") +
  xlab(element_blank()) +
  ylab("Log Fold Enrichment") +
  scale_fill_gradientn(colours = c("#87868140", colorHex), #0000ff40
                       limits=c(1,LegendLimit),
                       breaks=c(1,LegendLimit)) +
  ggtitle(Title) +
  scale_y_continuous(breaks=round(seq(0, max(-log10(GoGraph$Fisher),3)), 1)) +
  #theme_bw(base_size=12) +
  theme(
    panel.grid = element_blank(),
    legend.position=c(0.8,.3),
    legend.background=element_blank(),
    legend.key=element_blank(),     #removes the border
    legend.key.size=unit(0.5, "cm"),      #Sets overall area/size of the legend
    #legend.text=element_text(size=18),  #Text size
    legend.title=element_blank(),
    plot.title=element_text(angle=0, face="bold", vjust=1, size=25),
    axis.text.x=element_text(angle=0, hjust=0.5),
    axis.text.y=element_text(angle=0, vjust=0.5),
    axis.title=element_text(hjust=0.5),
    #title=element_text(size=18)
  ) +
  guides(fill=guide_colorbar(ticks=FALSE, label.position = 'left')) +
  coord_flip()


params <- GSEAGOHyperGParams(name="My Custom GSEA based annot Params",
                             geneSetCollection=meiospore.gsc,
                             geneIds = enrich.inf$V1,
                             universeGeneIds = all_genes$V1,
                             ontology = "MF",
                             pvalueCutoff = 0.05,
                             conditional = FALSE,
                             testDirection = "under")


Under <- hyperGTest(params)
summary(Under)
Under
write.csv(summary(Under),"results/GO_enrich_kallisto/Inf_UnderMF_enrich.csv");


paramsCC <- GSEAGOHyperGParams(name="My Custom GSEA based annot Params",
                               geneSetCollection=meiospore.gsc,
                               geneIds = enrich.inf$V1,
                               universeGeneIds = all_genes$V1,
                               ontology = "CC",
                               pvalueCutoff = 0.05,
                               conditional = FALSE,
                               testDirection = "under")

UnderCC <- hyperGTest(paramsCC)
summary(UnderCC)
UnderCC
write.csv(summary(UnderCC),"results/GO_enrich_kallisto/Inf_UnderCC_enrich.csv");

paramsBP <- GSEAGOHyperGParams(name="My Custom GSEA based annot Params",
                               geneSetCollection=meiospore.gsc,
                               geneIds = enrich.inf$V1,
                               universeGeneIds = all_genes$V1,
                               ontology = "BP",
                               pvalueCutoff = 0.05,
                               conditional = FALSE,
                               testDirection = "under")

UnderBP <- hyperGTest(paramsBP)
summary(UnderBP)
UnderBP
write.csv(summary(UnderBP),"results/GO_enrich_kallisto/Inf_UnderBP_enrich.csv")




#hmm is there a good way to plot these first results?
#we could sum by 'term' and plot 
#need to think on this






##### alternative way ####
source("scripts/GOfunctions.R")
library("ggplot2")
library("cowplot")
theme_set(theme_cowplot())
library("patchwork")


#Now using scripts from https://github.com/rajewski/Datura-Genome/
#doesn't have an option of over vs. under enriched? 

# Make a GO Enrichment of the Up and Down Regulated Genes
GO_Up_Inf <- GOEnrich(gene2go = "db/CM_gogenes.txt",
                    GOIs="results/deseq_kallisto/Results_Down.tsv")

inf <- GOPlot(GO_Up_Inf)
inf

GO_Up_Spo <- GOEnrich(gene2go = "db/CM_gogenes.txt",
                  GOIs="results/deseq_kallisto/Results_Up.tsv")

spo <- GOPlot(GO_Up_Spo)
spo


GO_All <- GOEnrich(gene2go = "db/CM_gogenes.txt",
                   GOIs="results/deseq_kallisto/all_DEG.tsv")

GOPlot(GO_All)


#plot results
inf + spo + plot_annotation(tag_levels = 'A')

ggsave(filename = 'plots/GO_enrich_infA_spoB_method2.pdf', plot = last_plot(), device = 'pdf', width = 16, height = 8, dpi = 300)



