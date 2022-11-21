#comparison to orthologous groups

#expanded gene list from Mark
expanded <- read.table("db/Coel_expanded_genes.txt")

expanded$V1 <-  paste0(expanded$V1, "-T1")

res.sig.with.annot.v3 <- res.sig.with.annot.v2 %>%
  filter(GeneID %in% expanded$V1)

write.csv(res.sig.with.annot.v3, "results/DEG.with.expansion.with.annot.csv")
write_tsv(as.data.frame(res.sig.with.annot.v3$GeneID), "results/DEG.with.expansion.with.annot.justGeneID.txt")

#over-enriched go terms
go_terms <- vroom("results/GO_enrich_kallisto/Spo_overenrich_GO_revigo_filt.csv")

res.sig.with.annot.v3.go <- res.sig.with.annot.v3 %>%
  separate_rows("GO Terms", sep=";")

res.sig.with.annot.v3.go.enrich <- res.sig.with.annot.v3.go %>%
  filter(`GO Terms` %in% go_terms$GOBPID)

unique(res.sig.with.annot.v3.go.enrich$GeneID)

go_terms.enrich <- go_terms %>%
  filter(GOBPID %in% res.sig.with.annot.v3.go$`GO Terms`)

write.csv(go_terms.enrich, "results/go.terms.enriched.orthologs.csv")
write_tsv(as.data.frame(res.sig.with.annot.v3$GeneID), "results/DEG.with.expansion.with.annot.justGeneID.txt")


