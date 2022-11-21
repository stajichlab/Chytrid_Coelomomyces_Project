
library(tidyverse)
library(magrittr)

res.sig.with.annot.v2.group <- res.sig.with.annot.v2 %>% 
  mutate(Annotated=ifelse(is.na(PFAM) & is.na(InterPro) & is.na(BUSCO) & is.na(EggNog) & is.na(COG) & is.na(`GO Terms`) & is.na(CAZyme), "No annotation", "Annotate")) 


select_mean.2 <- order(res.sig.with.annot.v2.group$baseMean, decreasing=TRUE)[1:25]

res.sig.with.annot.v2.group.mean <- res.sig.with.annot.v2.group[select_mean.2,]

write.csv(res.sig.with.annot.v2.group.mean, "results/deseq_kallisto/Result_DEGs_annot_top25_by_mean.txt")
