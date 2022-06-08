#plotting of busco #s for paper
#by Cassie Ettinger

library(tidyverse)
library(ggplot2)
library(vroom)
library(ggtree)
library(treeio)
library(ape)
library(patchwork)
library(ggnewscale)

#load in data
busco.stats <- vroom("data/busco_results.csv")
meta.tre <- vroom("data/busco_results_metadata.csv")
chy.tre <- read.newick("data/chy_root.tre")
gene.counts <- vroom("data/genecounts.csv")

#first parse busco values and do some re-coding to get %

busco.stats.v2 <- busco.stats %>%
  mutate(per_complete = (complete / total) * 100, 
         per_single = (singlecopy / total) * 100,
         per_dup = (duplicate / total) * 100,
         per_frag = (fragmented / total) * 100,
         per_missing = (missing / total) * 100)


busco.stats.v3 <- busco.stats.v2 %>%
  group_by(group, species, BUSCO, mode) %>%
  gather(key = "busco_cat", value = "percent",
         per_single, per_dup, per_frag, per_missing)


#set up names for graphing
busco.stats.v3$busco_cat <- factor(busco.stats.v3$busco_cat, levels = c("per_missing", "per_frag", "per_dup", "per_single"))
busco.stats.v3$BUSCO <- factor(busco.stats.v3$BUSCO, levels = c("eukaryota_odb10", "fungi_odb10"))
busco.stats.v3$mode <- factor(busco.stats.v3$mode, levels = c("genome", "protein"))
busco.stats.v3$species <- factor(busco.stats.v3$species, levels = c("Amber", "Orange", "Meiospore", "AOM90", 
                                                                    "Allomyces macrogynus", "Blastocladiella britannica", "Catenaria anguillulae", "Paraphysoderma sedebokerense",
                                                                    "Batrachochytrium dendrobatidis", "Batrachochytrium salamandrivorans", "Homolaphlyctis polyrhiza", "Polyrhizophydium stewartii",
                                                                    "Neocallimastix californiae", 
                                                                    "Phycomyces blakesleeanus", 
                                                                    "Orbilia oligospora", "Metarhizium anisopliae", "Ophiocordyceps sinensis"))

#filter data appropriately, we will plot protein values here
busco.stats.v4 <- busco.stats.v3 %>%
  filter(mode != "protein")
busco.stats.v3 <- busco.stats.v3 %>%
  filter(mode != "genome")

#filter out genome values
busco.stats.v3.aom <- busco.stats.v3 %>%
  filter(species != "Amber" & species !=  "Orange" & species != "Meiospore")

busco.stats.v3.Coel <- busco.stats.v3 %>%
  filter(group == "Coelomomyces lativittatus")

busco.stats.v3.aom$name <- factor(busco.stats.v3.aom$name, levels = c("Coelomomyces lativittatus",
                                                                    "Allomyces macrogynus", "Blastocladiella britannica", "Catenaria anguillulae", "Paraphysoderma sedebokerense",
                                                                    "Batrachochytrium dendrobatidis", "Batrachochytrium salamandrivorans", "Homolaphlyctis polyrhiza", "Polyrhizophydium stewartii",
                                                                    "Neocallimastix californiae",
                                                                    "Phycomyces blakesleeanus",
                                                                    "Orbilia oligospora", "Metarhizium anisopliae", "Ophiocordyceps sinensis"))



#get tree and parse

#take a look at basic tree
ggtree(chy.tre, color = "black", size=1, linetype = 1) + 
  geom_tiplab(fontface = "bold.italic", size = 5, offset = 0.001) +
  xlim(0,3) + geom_nodelab(aes(label=node))


#get taxa from  tree 
chy.tre.lab <- chy.tre$tip.label 

#now subset metadata
chy.tre.lab.meta <- meta.tre %>% filter(label%in%chy.tre.lab)

#Join metadata with the tree
chy.tre.w.meta <-full_join(chy.tre, chy.tre.lab.meta, by = "label")

#plot tree alone
chy.tre.w.meta.plot <- ggtree(chy.tre.w.meta, color = "black", size=1, linetype = 1) + 
  geom_tiplab(aes(label = name, color= Phylum),fontface = "bold.italic", size = 2.2, offset = 0.01) + 
  scale_color_manual(values=c("#009E73", "#D55E00",  "#0072B2", "#E69F00","#CC79A7"))

chy.tre.w.meta.plot

# plotting busco alone without amber/orange/meio
ggplot(data = busco.stats.v3.aom, aes(x = percent, y = name, fill = busco_cat)) +
  geom_bar(position='stack', stat="identity", orientation = "y") + 
  theme(text = element_text(size = 12)) + 
  theme(panel.background = element_blank()) + 
  facet_grid(~BUSCO) + 
  ylab("") +
  xlab("Percent of total BUSCOs") + 
  scale_fill_manual(labels = c(`per_single` = "Complete and single-copy", 
                               `per_dup` = "Complete and duplicated", `per_frag` = "Fragmented", `per_missing`= "Missing"), values = c("grey", "#DCE318FF", 
                                                                                                                                       "#1F968BFF", "#3F4788FF")) +
  guides(fill = guide_legend(title = "BUSCO Status")) +
  theme(axis.ticks.x = element_blank()) #+ 
  theme(axis.text.x = element_text(angle = -70, hjust = 0, vjust = 0.5), text = element_text(size = 12))

ggsave(filename = 'plots/busco.png', plot = last_plot(), device = 'png', width = 8, height = 5, dpi = 300)

#split busco euk and fungi
busco.stats.v3.aom.fun <- busco.stats.v3.aom %>%
  filter(BUSCO != "eukaryota_odb10")

busco.stats.v3.aom.euk <- busco.stats.v3.aom %>%
  filter(BUSCO != "fungi_odb10")


# plot busco + tree
tree_plus <- chy.tre.w.meta.plot +
  theme(axis.title.x=element_text(),
        axis.text.x=element_text(),
        axis.ticks.x=element_line(),
     axis.line.x=element_line()) +
  # geom_facet(panel = "Genome Size (Mbp)", 
  #            data = gene.counts, geom = geom_bar, 
  #            aes(x = GenomeSizeMbp, fill = Host), orientation= 'y', stat = "identity",
  #            width=.6)  +
  geom_facet(panel = "Gene Count", 
             data = gene.counts, geom = geom_bar, 
             aes(x = GeneCount, fill = Lifestyle), orientation= 'y', stat = "identity",
             width=.6)  +
  scale_fill_viridis_d(option = "magma", begin=.25, direction=-1) + new_scale_fill() +
  geom_facet(panel = "eukaryota_odb10", 
             data = busco.stats.v3.aom.euk, geom = geom_bar, 
             aes(x = percent, fill = busco_cat), 
             orientation = 'y', stat="identity", position="stack",
             width=.6) + 
  geom_facet(panel = "fungi_odb10", 
             data = busco.stats.v3.aom.fun, geom = geom_bar, 
             aes(x = percent, fill = busco_cat), 
             orientation = 'y', stat="identity", position="stack",
             width=.6) + 
  scale_fill_manual(labels = c(`per_single` = "Complete and single-copy", 
                               `per_dup` = "Complete and duplicated", `per_frag` = "Fragmented", `per_missing`= "Missing"), values = c("grey", "#DCE318FF", 
                                                                                                                                       "#1F968BFF", "#3F4788FF")) + 
  guides(fill = guide_legend(title = "BUSCO Status")) +
  xlim_tree(3) #+ 
  theme(legend.text=element_text(size=8),strip.text=element_blank())

facet_labeller(tree_plus, c(Tree = "Phylogeny"))
  
ggsave(filename = 'plots/phylo_busco_lifestyle.png', plot = last_plot(), device = 'png', width = 11, height = 6, dpi = 300)


## just comparing individual annotations vs AOM90 for supplement
ggplot(data = busco.stats.v3.Coel, aes(x = species, y = percent, fill = busco_cat)) +
  geom_bar(position='stack', stat="identity", orientation = "x") + 
  theme(text = element_text(size = 12)) + 
  theme(panel.background = element_blank()) + 
  facet_grid(~BUSCO) + 
  xlab("") +
  ylab("Percent of total BUSCOs") + 
  scale_fill_manual(labels = c(`per_single` = "Complete and single-copy", 
                               `per_dup` = "Complete and duplicated", `per_frag` = "Fragmented", `per_missing`= "Missing"), values = c("grey", "#DCE318FF", 
                                                                                                                                       "#1F968BFF", "#3F4788FF")) +
  guides(fill = guide_legend(title = "BUSCO Status")) +
  theme(axis.ticks.x = element_blank()) + 
theme(axis.text.x = element_text(vjust = 4))

ggsave(filename = 'plots/supp_busco.png', plot = last_plot(), device = 'png', width = 8, height = 5, dpi = 300)



