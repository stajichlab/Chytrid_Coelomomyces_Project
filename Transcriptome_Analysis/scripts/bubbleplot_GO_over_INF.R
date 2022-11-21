library(ggplot2)
library(dplyr)
library(magrittr)
library(tidyr)
library(ggplot2) #for plotting
library(forcats) #for plotting
library(vroom)

#load data
revigo.GO <- vroom("results/GO_enrich_within/revigo_filtered_GO_over_inf.csv")

#rename column and then remove original column
revigo.GO$structure <- revigo.GO$...1 
revigo.GO <- revigo.GO[,-c(1)]

#make a factor from the category
revigo.GO$Category <- factor(revigo.GO$Category, 
                          levels = c("BP", "CC", "MF"))

#have it reorder go terms by category (as a number, by descending #)
#changed transparency
#changed continuous color scale
#changed y axis label
revigo.GO.plot.inf <- ggplot(revigo.GO, aes(y = reorder(`GO term`, desc(as.numeric(Category))), x = `Gene Count`, size = `Gene Count`)) + geom_point(aes(color = `P-value`), alpha = 1.0) +
  geom_tile(aes(width = Inf, fill = Category), alpha = 0.15) +
  scale_fill_manual(values = c("red", "yellow", "blue")) + 
  ylab("GO Term") +  scale_color_viridis_c(option = "C")

revigo.GO.plot.inf
