#Purpose: Generate rarefaction curves from OTU table using vegan rarefaction curve and function obtained from Jenna Jacobs (see rarefaction_function.R)
#Author: Julia Gustavsen


library(vegan)

source("../scripts/rarefaction_function.R")


AllOTUs <- read.csv("../results/usearch/95identity/RdRp_OTUs_table.csv", na.strings = "NA", row.names=1)

AllOTUs[is.na(AllOTUs)] <- 0

#Community data should be as "species" for columns and sites as rows. 
AllOTUs_transposed <-t(AllOTUs)

#To ignore control sample
AllOTUs_transposed <- AllOTUs_transposed[2:6,]

#Adding in the sum of all the OTUs
Overall_AllOTUs_transposed <- colSums(AllOTUs_transposed)


AllOTUs_transposed <- rbind(AllOTUs_transposed, Overall_AllOTUs_transposed)


# 4) Rarefy your dataset
OTUs_95_mid.rare<-rarefaction(AllOTUs_transposed[1:5,], col=F) # I'm a big fan of B&Weme

OTUs_95_overall.rare <- rarefaction(AllOTUs_transposed[6,], col=F)

write.csv(OTUs_95_mid.rare$richness, file="OTUs_95_mid.rare_richness.csv")


###make a nicer graph ####

Rarefaction_curves <-file.path("..","figures", paste("Rarefaction_curves", Sys.Date(), ".ps", sep=""))

postscript(Rarefaction_curves, width = 8, height = 11,horizontal = FALSE, onefile = FALSE, paper = "special")

#makes it so the plot does not have terrible looking numbers
options(scipen=3)
plot(OTUs_95_overall.rare$subsample,OTUs_95_overall.rare$richness$OTU_0,type="l",lwd=2, col="black", ylab="OTU Richness", xlab="Sequence reads", las=1)
library(Hmisc)
#adds minor ticks to the current plot
minor.tick(nx=5, ny=5, tick.ratio=0.5)

lines(OTUs_95_mid.rare$subsample,OTUs_95_mid.rare$richness$Mid22,lwd=2, pch=1,cex=0.5, col="#153D39")
#text (21000,80, "Jericho 10 July", col="#153D39", cex=1.2)

lines(OTUs_95_mid.rare$subsample,OTUs_95_mid.rare$richness$Mid23, lwd=2,pch=2,cex=0.5, col="#2C9473")
#text (20000, 30, "SOG Station 1",col="#2C9473", cex=1.2)

lines(OTUs_95_mid.rare$subsample,OTUs_95_mid.rare$richness$Mid24,lwd=2, pch=3,cex=0.5, col="#FFB842")
#text (50000, 30, "SOG Station 2", col="#FFB842", cex=1.2)

lines(OTUs_95_mid.rare$subsample,OTUs_95_mid.rare$richness$Mid25,lwd=2,pch=4,cex=0.5, col="#FF5B13")
#text (30000, 65, "Jericho 12 October", col="#FF5B13", cex=1.2)

lines(OTUs_95_mid.rare$subsample,OTUs_95_mid.rare$richness$Mid26,lwd=2,pch=5,cex=0.5,col="#E80776")
#text (40000, 55, "SOG station 3", col="#E80776", cex=1.2)


legend("bottomright",cex=0.5, fill = c("black", "#153D39", "#2C9473", "#FFB842", "#FF5B13","#E80776"),
       legend = c("Overall", "Jericho summer ", "SOG Station 2", "SOG Station 1", "Jericho fall", "SOG station 4"))

dev.off()

