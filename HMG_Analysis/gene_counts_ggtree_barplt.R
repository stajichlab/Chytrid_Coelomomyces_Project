##################
library(dplyr)
library(rvcheck)
library(ggplot2)
library(ggtree)
library(treeio)
library(ggstance)
library(ggtreeExtra)
library(RColorBrewer)

geneCopies <- read.table("Chytrid_gene_counts.csv", header=TRUE, sep=",", row.names = NULL)
geneCopies

tip_metadata <- read.table("Chytrid_metadata.tab", sep="\t", header=TRUE,check.names=FALSE, stringsAsFactor=F)

tip_metadata

tree <- read.tree("Chytrid_tree")
tipnames <- tree$tip.label
tipnames
to_drop <- setdiff(tree$tip.label, geneCopies$Strain)
to_drop
straintree <- drop.tip(tree, to_drop)
tipnames <- straintree$tip.label

tipnames

p0 <- ggtree(tree, layout="circular") +
  geom_tiplab(size=0, color="black")

p0

p1 <- ggtree(straintree, layout="rectangular") +
  geom_tiplab(size=3, color="black")

p1

p <- p1 %<+% tip_metadata + geom_tippoint(aes(color=Lifestyle), size=3) +
  scale_color_brewer(palette = "Dark2")
plot(p)

#tip_metadata <- read.table("Lineages.tab", sep="\t", header=TRUE,check.names=FALSE, stringsAsFactor=F)

#tip_metadata

#p <- p1 %<+% tip_metadata + geom_tippoint(aes(color=Lineage), size=2)
#plot(p)

difftable <- setdiff(geneCopies$Strain, straintree$tip.label)
geneCopiesFilter <- filter(geneCopies,geneCopies$Strain %in% straintree$tip.label)

geneCopiesFilter
dd = data.frame(id=straintree$tip.label, value=(geneCopiesFilter$Gene_Count))
dd

geneCounts = data.frame(geneCopiesFilter)

geneCounts

# Define the number of colors you want
#nb.cols <- 21
#mycolors <- colorRampPalette(brewer.pal(8, "Set3"))(nb.cols)
# Create a ggplot with 21 colors
# Use scale_fill_manual

ptbl <- facet_plot(p, panel = 'Total CDS', data = geneCopiesFilter, geom = geom_barh, mapping = aes(x=Gene_Count),
                   stat = "identity") + theme_tree2(legend.position=c(.875, .70)) 

ptbl

ptbl <- facet_plot(p, panel = 'Total_CDS', data = geneCopiesFilter, geom = geom_barh, mapping = aes(x=Gene_Count, group = label, fill=Lifestyle),
                   stat = "identity") + scale_fill_brewer(palette = "Dark2") + theme_tree2(legend.position=c(.875, .70)) 

ptbl
