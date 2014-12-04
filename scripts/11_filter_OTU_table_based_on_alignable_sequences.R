##  Author: Julia Gustavsen
## Purpose: remove rows from OTU table from sequences that were not able to be aligned
## to the other sequences and the NCBI reference alignment. 

library(dplyr)


OTU_table <- read.csv("../results/usearch/95identity/RdRp_OTUs_table.csv")

sequences <- read.table("../data/OTUs_95identity_removed_unalignable_no_gaps_longer_than_75aa.fasta")

## just want to keep rows that have >
only_otu_info  <- filter(sequences, grepl("OTU", sequences$V1))

## formating of the fasta file header and OTU table differs. 
OTU_numbers_alignable_and_over_75aa <- gsub(">OTU_", "", only_otu_info$V1)

## filter OTU table by alignable sequences
OTU_table_only_alignable_and_over_75aa <- OTU_table[OTU_table$OTU_ID %in% OTU_numbers_alignable_and_over_75aa, ]

## just keep useful columns for the 5 samples. 
OTU_table_only_alignable_and_over_75aa <- OTU_table_only_alignable_and_over_75aa[,2:7]

write.csv(OTU_table_only_alignable_and_over_75aa, "../results/usearch/95identity/RdRp_OTUs_table_only_alignable_and_over_75aa.csv")
