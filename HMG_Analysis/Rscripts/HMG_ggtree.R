library(ggplot2)
library(rlang)
library(dplyr)
library(ggtree)
library(ggrepel)
library(ggnewscale)
library("viridis")
library(treeio)
library(phytools)

tree <- read.tree("HMG_tree3.txt")
tree

tree2 <- phytools::reroot(tree, 163)
plot(tree2)
nodelabels()

tipnames <- tree2$tip.label
tipnames
tip_metadata <- read.table("HMG_Ids.txt", sep="\t", header=TRUE,check.names=FALSE, stringsAsFactor=F)
tip_metadata
to_drop <- setdiff(tree2$tip.label, tip_metadata$ID)
to_drop
straintree <- drop.tip(tree2, to_drop)
tipnames <- straintree$tip.label
tipnames

p1 <- ggtree(straintree, layout="rectangular") +
  geom_nodelab(size=3) + 
  geom_tiplab(size=3, color="black", offset = 0.05)

p1

p <- p1 %<+% tip_metadata + geom_tippoint(aes(color=Species), size=3) 

plot(p)


p1 <- ggtree(tree, layout="rectangular") +
  geom_label_repel(aes(label=tree$node.label)) + 
  geom_tiplab(size=3, color="black", offset = 0.05)

p1

p <- p1 %<+% tip_metadata + geom_tippoint(aes(color=Species, shape=15), size=3)


p1 <- ggtree(straintree, layout="rectangular") +
  geom_nodelab(size=0) + geom_nodepoint(aes(color=as.numeric(label)), size = 1.5) +
  geom_tiplab(size=3.5, color="black", offset = 0.05) + scale_color_viridis("bootstrap") + theme_tree(legend.position=c(0.1, 0.6)) + 
  new_scale_color()

p1

p2 <- p1 %>% collapse(node=226)

p <- p1  %<+% tip_metadata + geom_tippoint(aes(color=Phylum, shape=Coelomomyces_lativitattus), size=3) +
  scale_color_manual(values = c("#009E73", "#D55E00", "#0072B2", "#E69F00","#CC79A7")) + coord_cartesian(clip = 'off') +
  theme(plot.margin = unit(c(1,10,1,1), "lines"))

plot(tree)
nodelabels()

tree1 <- ggtree(straintree) + geom_text2(aes(subset=!isTip, label=node), hjust=-.3) + 
  geom_tiplab(size=3, color="black", offset = 0.05)
tree1



p <- p1  %<+% tip_metadata + geom_tippoint(aes(color=Phylum, shape=Coelomomyces_lativitattus), size=3) +
  scale_color_manual(values = c("#009E73", "#D55E00", "#0072B2", "#E69F00","#CC79A7")) + coord_cartesian(clip = 'off') +
  geom_strip('Phycomyces_blakesleeanus|PHYBLDRAFT_154054','Phycomyces_blakesleeanus|PHYBLDRAFT_154054', barsize=10, fontsize=4,
             label = "SexM", offset=1.2, align=T, geom='label', fill = "#E69F00") +
  geom_strip('Ophiocordyceps_sinensis|EQL04085.1','Ophiocordyceps_sinensis|EQL04085.1', barsize=10, fontsize=4,
             label = "MAT1-2-1", offset=1.2, align=T, geom='label', fill = "#009E73") +
  geom_strip('Ophiocordyceps_sinensis|EQK97645.1','Metarhizium_anisopliae|KFG83434.1', barsize=10, fontsize=4,
             label = "MAT1-1-3", offset=1.2, align=T, geom='label', fill = "#009E73") +
  geom_strip('Phycomyces_blakesleeanus|B0F2H2','Phycomyces_blakesleeanus|B0F2H1', barsize=10, fontsize=4,
             label = "SexP", offset=1.2, align=T, geom='label', fill = "#E69F00") +
  theme(plot.margin = unit(c(1,10,1,1), "lines")) + nodelabels() 

p

pfinal <- collapse(p, 224, 'mixed', fill = "steelblue")
pfinal

pfinal <- p %>% collapse(node=224)
pfinal
