## Author: Julia Gustavsen
## Date: 24 June 2013
## Script to re-create the phylogenetic tree with heatmap that I had made with iTOL.
## Will have to line up the heatmap with the phylogenetic tree. I am adding zeros to the OTU table for the isolates and cloned sequences obtained from Genbank.
#Last updated: 30 November 2014

library(ggplot2)
library(gplots)
library(vegan)
library(RColorBrewer)
library(BiodiversityR)
library(reshape2)


AllOTUs_rarefied_by_lowest_Mid_file <-file.path(paste("../results/AllOTUs_rarefied_by_lowest_Mid_", Sys.Date(), ".csv", sep=""))

#To get the numbers to add correctly I had to make it so that it doesn't check the names.
AllOTUs_rarefied_by_lowest_Mid <- read.csv(AllOTUs_rarefied_by_lowest_Mid_file, header = TRUE, check.names = FALSE, row.names=1)

rownames(AllOTUs_rarefied_by_lowest_Mid) <- c("Jericho_Summer", "SOG_Station_2", "SOG_Station_1", "Jericho_Fall", "SOG_Station_4")

## adds OTU in front of each OTU number. Then it will match up with what is in the tree. 
colnames(AllOTUs_rarefied_by_lowest_Mid) <- paste("OTU", colnames(AllOTUs_rarefied_by_lowest_Mid), sep = "_")

#### Drawing the phylogenetic tree ####

library(ape)

## Tree downloaded from Raxml
tree <- read.tree("../data/Alignments/RAxML_bipartitions.NBCI_with_Culley_env_95_with_454_data_trimalled_no_colons_renamed")

#### Adding tree tips as zeros to the OTU table ####

#For tree tips not in OTU table I can add a column of zeros to the matrix. 

#New copy of OTU table
OTU_table_with_isolates <- AllOTUs_rarefied_by_lowest_Mid

#Vector I would add in place for the isolates based on the number of sites in the sample. 
sample_length <- length(rownames(OTU_table_with_isolates))

#Make vector of 0s based on number of sites. 
zeros <- rep(0, sample_length)

#Insert vector in table based on number of tips in tree that are not found in the OTU table. 
for(i in (tree$tip.label)) {
  if (is.element(i, colnames(OTU_table_with_isolates))) {
    print(i)
  }
  else {
    print("no")
    print(i)
    OTU_table_with_isolates <-cbind(OTU_table_with_isolates, zeros)
    colnames(OTU_table_with_isolates)[dim(OTU_table_with_isolates)[2]] <- paste(i)   
  }
} 

#### Rotate the tree and then export it so that the isolates are around the top of the tree. #### 
tre.new <- tree

tre.new <- ladderize(tre.new)
plot.phylo(tre.new, use.edge.length=FALSE)

#display only bootstrap values above 65
tre.new$node.label[which(as.numeric(tre.new$node.label)<65 & as.numeric(tre.new$node.label) !=100)] <- ""

plot(tre.new,
     type="phylogram",
     show.node.label=TRUE,
     direction="leftwards",   
     cex = 0.5)

#exporting tree.
write.tree(tre.new, file.path("../results/", paste("RdRP_tree_rotated_reverse", Sys.Date(), ".tre", sep="")))

#re-import to be able to match up the tip labels with the OTU table. 
reordered_tree <- read.tree(file.path("../results/", paste("RdRP_tree_rotated_reverse", Sys.Date(), ".tre", sep="")))

plot(reordered_tree)

## add symbols to the plot

classification_data <- read.delim("../data/table_to_rename_sequence_data_for_readable_tree.txt", header = TRUE)

#### order matrix so that it is ordered like the tree ####

OTU_table_with_isolates_reordered <- OTU_table_with_isolates[,rev(reordered_tree$tip.label)]

OTU_table_T <- t(OTU_table_with_isolates_reordered)

OTU_table_for_point  <-  as.data.frame(OTU_table_T)
OTU_table_for_point[,"group"] <- "454_OTU"


for (i in reordered_tree$tip.label){
if (i %in% classification_data$Name_for_tree){
  new_name  <- i
  print(new_name)
  #OTU_table_for_point$group <- classification_data$group
  OTU_table_for_point$group[rownames(OTU_table_for_point) == new_name ] <- as.character(classification_data$group[classification_data$Name_for_tree == new_name ])
}
}


OTU_table_for_point <- OTU_table_for_point[rev(reordered_tree$tip.label),]

pch_lookup <- c("454_OTU" = 1, "environmental" = 2, "unknown" = 3, "Jericho" = 4, "Secoviridae" = 0, "Dicistroviridae" = 5, "Iflaviridae" = 6, "Marnaviridae" = 15,"Bacillarnaviridae"=16, "Labyrnaviridae" = 17 )

points(rep(3.9, length(reordered_tree$tip.label)),
       1:length(reordered_tree$tip.label), 
       pch=pch_lookup[as.character(OTU_table_for_point$group[match(reordered_tree$tip.label, rownames(OTU_table_for_point))])],
bg=as.factor(OTU_table_for_point$group[match(reordered_tree$tip.label, rownames(OTU_table_for_point))]))


Save_tree_with_points <-file.path("../figures/", paste("tree_with_points","_", Sys.Date(), ".eps", sep=""))

dev.copy2eps(file=Save_tree_with_points, width = 13, height = 30)

#### Heatmap with log scaled values ####

OTU_table_long <- melt(OTU_table_T)

OTU_table_long$value[OTU_table_long$value == 0] <- NA

OTU_table_long$Var1 <- factor(OTU_table_long$Var1, levels = factor(reordered_tree$tip.label))

OTU_table_long$Var2 <- factor(OTU_table_long$Var2, levels(OTU_table_long$Var2)[c(1,4,3,2,5)])


OTU_heatmap <- ggplot(OTU_table_long, 
                      aes(Var2,Var1)) + 
  geom_tile(aes(fill = value),
            colour = "white") +
  scale_fill_gradient(low = "#A0B0BE",
                     high = "#40627C",
                     na.value = "white" ,
                     trans = "log"
                 ) +
  theme_bw()

##fix up formatting
base_size=9

OTU_heatmap_formatted <- OTU_heatmap + 
  theme_grey(base_size = base_size) + 
  labs(x = "",  y = "") + 
  theme(axis.ticks = element_blank(),
        axis.text.x = element_text(size = base_size * 1.2,
                                   angle = 330, 
                                   hjust = 0,
                                   colour = "grey20"))

#print out

Save_heatmap_file <-file.path("../figures/", paste("heatmap_ggplot","_", Sys.Date(), ".eps", sep=""))

postscript(Save_heatmap_file, width = 8, height = 11,horizontal = FALSE, onefile = FALSE, paper = "special")

OTU_heatmap_formatted

dev.off()


####Phylogenetic distance ####

#for doing phylogenetic distance analysis

library(picante)
library(xtable)

#Faith 1992 (PD=phylogenetic distance, SR=species richness)
RdRp_454.pd <- pd(OTU_table_with_isolates2, reordered_tree, include.root = TRUE)


##### Alpha diversity #####

####Shannon's diversity index ####
##if I want to be consistent with what is in the tree then I will use the OTU_table_with_isolates2 which removes sequences which are not in the tree instead of AllOTUs_rarefied_by_lowest_Mid)

Shannon_each_mids <-diversityresult(OTU_table_with_isolates2, index = "richness", method = "s")

Shannon_eveness_each_mids <-diversityresult(OTU_table_with_isolates2, index = "Jevenness", method = "s")

### Number of unique OTUs ###
#if x is not found in any other site "unique +1" for that site.
#Could work on later...or could just use Venn diagram


#### Simpson's diversity index ####

Simpson_each_mids <-diversityresult(OTU_table_with_isolates2, index = "Simpson", method = "s")

All_diveristy <- cbind(RdRp_454.pd, Shannon_each_mids, Shannon_eveness_each_mids , Simpson_each_mids)

Table_of_454_diversity_file <-file.path("../figures/", paste("Table_of_454_diversity_", Sys.Date(), ".html", sep=""))

All_diveristy.table <-xtable(All_diveristy)

print(All_diveristy.table, 
      floating = FALSE,
      type="html", 
      file=Table_of_454_diversity_file)
