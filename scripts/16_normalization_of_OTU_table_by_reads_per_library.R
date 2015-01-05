#Purpose: Rarefy OTUs from the OTU table. 
#Author: Julia Gustavsen
#Date created: 10 September 2013
#Date modified: 10 September 2013

## ----First_normalize data ----
library(vegan)
library(plyr)

####Reading in data from OTU table ####
# Use 95% OTU from all mids
AllOTUs<-read.csv("../results/usearch/95identity/RdRp_OTUs_table_only_alignable_and_over_75aa.csv", na.strings = "NA", row.names=1)

AllOTUs[is.na(AllOTUs)] <- 0

#Community data should be as "species" for columns and sites as rows. 
AllOTUs_transposed <-t(AllOTUs)

#Ignore the control data for now
AllOTUs_transposed <- AllOTUs_transposed[1:5,]

#Calculate the site with the least amount of reads
min_reads<-min(apply(AllOTUs_transposed,1,sum))

 
#want to do the rarefaction 1000 times
AllOTUs_rarefied_iteration <- lapply(as.list(1:9999), function(x) rrarefy(AllOTUs_transposed, sample=min_reads)) 

#takes the median value of all of the iterations. 
AllOTUs_rarefied_by_lowest_Mid_with_zeros <- aaply(laply(AllOTUs_rarefied_iteration,as.matrix),c(2,3),median) 


#want to get rid of OTU columns that no longer have OTUs in them. 
AllOTUs_rarefied_by_lowest_Mid <- AllOTUs_rarefied_by_lowest_Mid_with_zeros[, colSums(AllOTUs_rarefied_by_lowest_Mid_with_zeros) > 0]


write.csv(AllOTUs_rarefied_by_lowest_Mid, file=paste("../results/AllOTUs_rarefied_by_lowest_Mid_", Sys.Date(), ".csv", sep=""))

