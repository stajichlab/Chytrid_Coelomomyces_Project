#from https://github.com/rajewski/Datura-Genome/blob/master/X_Functions.R

GOEnrich <- function(gene2go="",
                     GOIs="",
                     GOCategory="BP",
                     NumCategories=20) {
  require(topGO)
  require(Rgraphviz)
  require(tidyr)
  require(dplyr)
  # Clean the lists of GO terms from the bash script and convert to a named list object
  GO <- read.table(gene2go, stringsAsFactors = F)
  GO <- separate_rows(as.data.frame(GO[,c(1,2)]), 2, sep="\\|")
  GO <- GO %>% 
    distinct() %>% 
    group_by(V1) %>% 
    mutate(V2 = paste0(V2, collapse = "|")) %>%
    distinct()
  GO <- setNames(strsplit(x = unlist(GO$V2), split = "\\|"), GO$V1)
  # Read in the genes of interest to be tested for GO enrichment
  # create if to handle if the gene list is passed from a named factor object
  if (is(GOIs, "factor")){
    message("You passed a named factor list for genes. Make sure that's correct.")
    GOI <- GOIs
  } else {
    GOI <- scan(file=GOIs,
                what = list(""))[[1]]
    GOI <- factor(as.integer(names(GO) %in% GOI))
    names(GOI) <- names(GO)
  }
  # Create a TopGO object with the necessary data, also get a summary with
  GOData <- new("topGOdata",
                description = "Slyc Cluster 1",
                ontology = GOCategory,
                allGenes = GOI,
                nodeSize = 5,
                annot = annFUN.gene2GO,
                gene2GO=GO)
  # Do the enrichment test
  GOResults <- runTest(GOData,
                       algorithm="weight01", #classic is best, then lea?
                       statistic = "fisher")
  # Summarize the test with a table
  GOTable <- GenTable(GOData,
                      Fisher = GOResults,
                      orderBy = "Fisher",
                      ranksOf = "Fisher",
                      topNodes = NumCategories)
  # Summarize with a prettier graph from https://www.biostars.org/p/350710/
  GOTable$Fisher <- gsub("^< ", "", GOTable$Fisher) #remove too low pvals
  GoGraph <- GOTable[as.numeric(GOTable$Fisher)<0.05, c("GO.ID", "Term", "Fisher", "Significant")]
  if(dim(GoGraph)[1]==0){
    return(NULL) #stop empty graphs
  }
  GoGraph$Term <- gsub(" [a-z]*\\.\\.\\.$", "", GoGraph$Term) #clean elipses
  GoGraph$Term <- gsub("\\.\\.\\.$", "", GoGraph$Term)
  GoGraph$Term <- substring(GoGraph$Term,1,26)
  GoGraph$Term <- paste(GoGraph$GO.ID, GoGraph$Term, sep=", ")
  GoGraph$Term <- factor(GoGraph$Term, levels=rev(GoGraph$Term))
  GoGraph$Fisher <- as.numeric(GoGraph$Fisher)
  return(GoGraph)
}



# Make a Plot of these GO Enrichments -------------------------------------
GOPlot <- function(GoGraph=X,
                   Title="",
                   LegendLimit=max(GoGraph$Significant),
                   colorHex="#5d3f6a99") 
{
  require(ggplot2)
  GoPlot <- ggplot(GoGraph, aes(x=Term, y=-log10(Fisher), fill=Significant)) +
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
  print(GoPlot)
}