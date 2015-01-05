## Author: Julia Gustavsen
## Purpose: Generate Euler diagram from normalized OTU data. 

## After comments by reviewers I am making suggested changes and adding in a diagram looking at the number of OTUs in each section.

library(Cairo)

AllOTUs_rarefied_by_lowest_Mid <- read.csv(paste("../results/AllOTUs_rarefied_by_lowest_Mid_", Sys.Date(), ".csv", sep=""), header = TRUE, check.names = FALSE, row.names=1)

rownames(AllOTUs_rarefied_by_lowest_Mid) <- c("Jericho_Summer", "SOG_Station_2", "SOG_Station_1", "Jericho_Fall", "SOG_Station_4")


normalized_OTU_matrix <- as.matrix(AllOTUs_rarefied_by_lowest_Mid)
normalized_OTU_matrix[normalized_OTU_matrix>0]  <- 1

## maybe just need to flip the site...

adj <- normalized_OTU_matrix%*%t(normalized_OTU_matrix)


# These data are normalized!


## this is giving the wrong answer!!!
library(venneuler)

## just want the SOG and Jericho separate
Jericho_OTUs <- normalized_OTU_matrix[c("Jericho_Summer","Jericho_Fall"),]
## remove any OTUs that are O
Jericho_OTUs <- as.data.frame(Jericho_OTUs)
Jericho_OTUs <- Jericho_OTUs[apply(Jericho_OTUs[, -1], MARGIN = 1, function(x) any(x > 0)), ]


SOG_OTUs <- normalized_OTU_matrix[c("SOG_Station_2", "SOG_Station_1", "SOG_Station_4"),]
SOG_OTUs <- as.data.frame(SOG_OTUs)
SOG_OTUs <- SOG_OTUs[apply(SOG_OTUs[, -1], MARGIN = 1, function(x) any(x > 0)), ]


flipped_matrix <- t(normalized_OTU_matrix)
flipped_Jericho <- t(Jericho_OTUs)
flipped_SOG <- t(SOG_OTUs)

#melt_flipped <- melt(flipped_matrix)
#melt_original <- melt(normalized_OTU_matrix)
#melt_adj <- melt(adj)


library(limma)
b <- vennCounts(flipped_Jericho)
vennDiagram(b)

b <- vennCounts(flipped_SOG)
vennDiagram(b)



pdf("../figures/Euler_diagram_RdRp_Jericho_shared_OTUs_normalized.pdf", width = 8, height = 11,onefile = FALSE)
v <- venneuler(flipped_Jericho)
plot(v)
dev.off()

pdf("../figures/Euler_diagram_RdRp_SOG_shared_OTUs_normalized.pdf", width = 8, height = 11,onefile = FALSE)
v <- venneuler(flipped_SOG)
plot(v)
dev.off()
