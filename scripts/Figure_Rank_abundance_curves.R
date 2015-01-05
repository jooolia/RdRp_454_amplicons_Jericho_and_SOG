## Author: Julia Gustavsen
## Purpose: Generate Euler diagram from normalized OTU data. Generation of figures for individual sites could be functionalized at a later date. 

library(plyr)
library(vegan)
library(BiodiversityR)
library(scales)
library(ggplot2)

AllOTUs_rarefied_by_lowest_Mid <-read.csv(file=paste("../results/AllOTUs_rarefied_by_lowest_Mid_", Sys.Date(), ".csv", sep=""), header=TRUE, row.names=1)

#Find out the proportion of reads coming from the Marna-like clade)
TotalCountsOTUs <- colSums(AllOTUs_rarefied_by_lowest_Mid)
TotalNumberReads <- sum(TotalCountsOTUs)

Marna_like  <- c("OTU_10", "OTU_96", "OTU_33", "OTU_12", "OTU_92", "OTU_69", "OTU_0", "OTU_9", "OTU_29", "OTU_27")
ColumnsWithMarnaclade <- AllOTUs_rarefied_by_lowest_Mid[,Marna_like]
MarnacladeCounts_Total <- colSums(ColumnsWithMarnaclade)
MarnaCladeCounts_Sum <- sum(MarnacladeCounts_Total)

### Total numbers of OTUs by site:
#Jericho Summer
Mid22 <- AllOTUs_rarefied_by_lowest_Mid["Mid22",]
length(Mid22[Mid22>0])
#SOG 2
Mid23 <- AllOTUs_rarefied_by_lowest_Mid["Mid23",]
length(Mid23[Mid23>0])
#SOG1
Mid24 <- AllOTUs_rarefied_by_lowest_Mid["Mid24",]
length(Mid24[Mid24>0])
#Jericho Winter
Mid25 <- AllOTUs_rarefied_by_lowest_Mid["Mid25",]
length(Mid25[Mid25>0])
#SOG4
Mid26 <- AllOTUs_rarefied_by_lowest_Mid["Mid26",]
length(Mid26[Mid26>0])

matrixAll_OTUs <- AllOTUs_rarefied_by_lowest_Mid *AllOTUs_rarefied_by_lowest_Mid
 
betadiver(AllOTUs_rarefied_by_lowest_Mid)

#### Overall rank abundance curves ####

x_lim_rank <- c(1,71)

y_scale <- scale_y_continuous(trans=scales::log_trans(10),breaks=c(0.0001,0.001, 0.01,0.1,1,10,50,100),labels=c("0.0001","0.001", "0.01","0.1","1","10","50","100"),limits=c(0.01,100),"Relative abundance (percent of total)")

theme_figure <- theme_classic()

rank_data<-rankabundance(AllOTUs_rarefied_by_lowest_Mid,
                         factor=row.names, digits=2
) 

rankabunplot(rank_data,scale='abundance', addit=FALSE, specnames=c(1,2,3))

rank_abundance_data.frame <- data.frame(rank_data)

rank_abundance_overall <- ggplot(rank_abundance_data.frame, aes(rank, proportion))

rank_abundance_overall_bar_plot <- rank_abundance_overall + geom_bar(stat="identity", fill="green") + xlim(x_lim_rank) + y_scale 

rank_abundance_overall_bar_plot


rank_abundance_overall_points <- rank_abundance_overall + geom_line(colour="grey") + geom_point(colour="green") + y_scale +theme_figure +ggtitle("Overall OTUs")



#### Rank abundance by site ####


Mid_22 <- t(as.table(AllOTUs_rarefied_by_lowest_Mid[1,]))
rank_data_22 <-rankabundance(Mid_22, digits=2)
rank_abundance_data_22.frame <- data.frame(rank_data_22)
rank_abundance_data_22.frame <- rank_abundance_data_22.frame[rank_abundance_data_22.frame$abundance > 0, ] #if it equals 0 get rid of row

rank_abundance_22 <- ggplot(rank_abundance_data_22.frame, aes(rank, proportion))
rank_abundance_22_bar_plot <- rank_abundance_22  + geom_bar(stat="identity", fill="#153D39") + ggtitle("Jericho Summer") + y_scale +xlim(x_lim_rank)

rank_abundance_22_points <- rank_abundance_22 + geom_line(colour="grey") + geom_point(colour="#153D39") + ggtitle("Jericho Summer") + y_scale +xlim(x_lim_rank) +theme_figure


Mid_23 <- t(as.table(AllOTUs_rarefied_by_lowest_Mid[2,]))
rank_data_23 <-rankabundance(Mid_23, digits=2)
rank_abundance_data_23.frame <- data.frame(rank_data_23)
rank_abundance_data_23.frame <- rank_abundance_data_23.frame[rank_abundance_data_23.frame$abundance > 0, ]

rank_abundance_23 <- ggplot(rank_abundance_data_23.frame, aes(rank, proportion))
rank_abundance_23_bar_plot <- rank_abundance_23  + geom_bar(stat="identity", fill="#2C9473") + ggtitle("SOG Station 2")+ y_scale +xlim(x_lim_rank)

rank_abundance_23_points <-  rank_abundance_23 + 
  geom_line(colour="grey") + 
  geom_point(colour="#2C9473") + 
  ggtitle("SOG Station 2")+ 
  y_scale + 
  xlim(x_lim_rank)+
  theme_figure




Mid_24 <- t(as.table(AllOTUs_rarefied_by_lowest_Mid[3,]))
rank_data_24 <-rankabundance(Mid_24, digits=2)
rank_abundance_data_24.frame <- data.frame(rank_data_24)
rank_abundance_data_24.frame <- rank_abundance_data_24.frame[rank_abundance_data_24.frame$abundance > 0, ]

rank_abundance_24 <- ggplot(rank_abundance_data_24.frame, aes(rank, proportion))
rank_abundance_24_bar_plot <- rank_abundance_24  + geom_bar(stat="identity", fill="#FFB842") + ggtitle("SOG Station 1") + y_scale +xlim(x_lim_rank)

rank_abundance_24_points <- rank_abundance_24+ 
  geom_line(colour="grey") + 
  geom_point(colour="#FFB842") +
  ggtitle("SOG Station 1") + 
  y_scale +
  xlim(x_lim_rank)+
  theme_figure


Mid_25 <- t(as.table(AllOTUs_rarefied_by_lowest_Mid[4,]))
rank_data_25 <-rankabundance(Mid_25, digits=2)
rank_abundance_data_25.frame <- data.frame(rank_data_25)
rank_abundance_data_25.frame <- rank_abundance_data_25.frame[rank_abundance_data_25.frame$abundance > 0,]

rank_abundance_25 <- ggplot(rank_abundance_data_25.frame, aes(rank, proportion))
rank_abundance_25_bar_plot <- rank_abundance_25  + geom_bar(stat="identity", fill="#FF5B13") + ggtitle("Jericho Winter") + y_scale +xlim(x_lim_rank)

rank_abundance_25_points <- rank_abundance_25  + 
  geom_line(colour="grey") +
  geom_point(colour="#FF5B13") +
  ggtitle("Jericho Winter") + 
  y_scale +
  xlim(x_lim_rank)+
  theme_figure


Mid_26 <- t(as.table(AllOTUs_rarefied_by_lowest_Mid[5,]))
rank_data_26 <-rankabundance(Mid_26, digits=2)
rank_abundance_data_26.frame <- data.frame(rank_data_26)
rank_abundance_data_26.frame <- rank_abundance_data_26.frame[rank_abundance_data_26.frame$abundance > 0, ]

rank_abundance_26 <- ggplot(rank_abundance_data_26.frame, aes(rank, proportion))
rank_abundance_26_bar_plot <- rank_abundance_26  + geom_bar(stat="identity", fill="#E80776") + ggtitle("SOG Station 4") + y_scale + xlim(x_lim_rank)


rank_abundance_26_points <- rank_abundance_26  + 
  geom_line(colour="grey") +
  geom_point(colour="#E80776") + 
  ggtitle("SOG Station 4") +
  y_scale + 
  xlim(x_lim_rank)+
  theme_figure



## All plots arranged in grid by 2. All ranks are calculated for each mid. 
## Print to file

Rank_abundances_side_by_side <-file.path("..","figures", paste("Rank_abundances_side_by_side", Sys.Date(), ".eps", sep=""))

postscript(Rank_abundances_side_by_side, width = 11, height = 11,horizontal = FALSE, onefile = FALSE, paper = "special")

sidebysideplot <- grid.arrange(rank_abundance_22_bar_plot,rank_abundance_25_bar_plot,rank_abundance_24_bar_plot,rank_abundance_23_bar_plot, rank_abundance_26_bar_plot, ncol=2)

dev.off()

Rank_abundances_side_by_side_points <-file.path("..","figures", paste("Rank_abundances_points_side_by_side", Sys.Date(), ".eps", sep=""))

postscript(Rank_abundances_side_by_side_points, width = 11, height = 11,horizontal = FALSE, onefile = FALSE, paper = "special")


sidebysideplot_points <- grid.arrange(rank_abundance_22_points,rank_abundance_25_points,rank_abundance_24_points,rank_abundance_23_points, rank_abundance_26_points, ncol=2)

dev.off()
## plot all of the points on 1 graph. 