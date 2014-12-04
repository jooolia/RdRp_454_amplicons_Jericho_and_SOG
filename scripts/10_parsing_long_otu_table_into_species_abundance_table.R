

long_otu_table <- read.delim("../results/usearch/95identity/RdRp_OTUs_long_OTU_table.csv", 
                             header=FALSE,
                             col.names = c("Header_ID", "Lib_ID", "OTU_ID"))
long_otu_table$OTU_ID <- as.factor(long_otu_table$OTU_ID) 
str(long_otu_table)
library(reshape2)


OTU_table <- dcast(long_otu_table,OTU_ID~Lib_ID)

sum(OTU_table[2:length(OTU_table)])
# Sum should equal length of the long OTU table

dim(long_otu_table)

write.csv(OTU_table, "../results/usearch/95identity/RdRp_OTUs_table.csv")
