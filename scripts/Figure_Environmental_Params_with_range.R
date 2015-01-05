#Author: Julia Gustavsen
#created: 4 June 2013
#Purpose: create graphs from data from RdRP metadata. 

library(ggplot2)
library(gridExtra)
library(plotrix)
#import data

Enviro_Data_RdRp_Mids <- read.csv("../data/EnvironmentalParametersForRdRpMids.csv", na.strings = "NA")

### Make graphs with error values plotted on the bar graph ######

Enviro_barplot_with_sd <- function (Columns_for_param, limit_y_axis,y_label, plot_title ){
  param_mean <- data.frame(Sample_name=Enviro_Data_RdRp_Mids[,1],
                           Means=rowMeans(Enviro_Data_RdRp_Mids[,Columns_for_param],
                                          na.rm=TRUE))
  
  param_values <- Enviro_Data_RdRp_Mids[,Columns_for_param]
  
  param_sd <- apply(param_values,
                    1,
                    sd,
                    na.rm = TRUE) 
  
  param_with_sd <- cbind(param_mean, 
                         param_sd)
  print(param_sd)
  
  param_barplot <- ggplot(param_with_sd, 
                          aes(Sample_name,Means))
  
  param_plot_line <- param_barplot + 
    geom_bar(stat="identity", 
             fill="white", 
             colour="black") +
    ylim(limit_y_axis)
  
  param_plot_line
  
  param_for_graph_with_sd <- aes(ymax = Means + param_sd, ymin= Means - param_sd)
  
  param_plot_line_error <- param_plot_line +
    geom_errorbar(param_for_graph_with_sd, 
                  position="dodge",
                  width=0.25) + 
    labs(y = y_label, x = "") + 
    ggtitle(plot_title) +
    theme_classic() +
    theme(axis.text.x=element_text(angle=25, vjust=0.2))
  return(param_plot_line_error)
}


Enviro_barplot_with_se <- function(Columns_for_param, limit_y_axis,y_label, plot_title ) { 
  param_mean <- data.frame(Sample_name=Enviro_Data_RdRp_Mids[,1], 
                           Means=rowMeans(Enviro_Data_RdRp_Mids[,Columns_for_param],
                                          na.rm=TRUE))
  
  param_values <- Enviro_Data_RdRp_Mids[,Columns_for_param]
  param_se <- apply(param_values,
                    1,
                    std.error,
                    na.rm = TRUE) 
  print(param_se)
  
  param_with_se <- cbind(param_mean,
                         param_se)
  param_barplot <- ggplot(param_with_se, 
                          aes(Sample_name, Means))
  
  param_plot_line <- param_barplot + 
    geom_bar(stat="identity", 
             fill="white", 
             colour="black") +
    ylim(limit_y_axis)
  
  param_plot_line
  param_for_graph_with_se <- aes(ymax = Means + param_se, ymin= Means - param_se)
  
  param_plot_line_error <- param_plot_line +
    geom_errorbar(param_for_graph_with_se, 
                  position="dodge", 
                  width=0.25) + 
    labs(y = y_label, x = "") + 
    ggtitle(plot_title) +
    theme_classic() +
    theme(axis.text.x=element_text(angle=25, vjust=0.2))
  return(param_plot_line_error)
}


Chla_a_with_sd <- Enviro_barplot_with_sd(7:9, c(0,4), expression(paste("Chlorophyll a ug L"^"-1")), "")
 
Chla_a_with_se <- Enviro_barplot_with_se(7:9, c(0,4), expression(paste("Chlorophyll a ug L"^"-1")), "")

Silicate_with_sd <- Enviro_barplot_with_sd(10:11, c(0,40), "Silicate (uM)", "")

Silicate_with_se <- Enviro_barplot_with_se(10:11, c(0,40), "Silicate (uM)", "")

Phosphate_with_sd <- Enviro_barplot_with_sd(12:13, c(0,1.5), "Phosphate (uM)", "")

Phosphate_with_se <- Enviro_barplot_with_se(12:13, c(0,1.5), "Phosphate (uM)", "")

Nitrogen_with_sd <- Enviro_barplot_with_sd(14:15, c(0,15), "Nitrogen (uM)", "")

Nitrogen_with_se <- Enviro_barplot_with_se(14:15, c(0,15), "Nitrogen (uM)", "")


#### Temperature and Salinity #########

Enviro_Data_RdRp_Mids_CTD <- read.csv("../data/EnvironmentalParameters_from_CTD_integrated_ForRdRpMids.csv")


temperature_base <- ggplot(Enviro_Data_RdRp_Mids_CTD, aes(Location, Temperature))


temperature_point <- temperature_base + 
  geom_point(colour = "blue",
             size = 3, 
             # alpha = 6/10
             ) +
               ylim(c(10,20))
temperature_point

temperature_point_region <- temperature_point+ theme_classic()  + 
  labs(y = expression(paste("Temperature (", degree, "C)")), x ="") + 
  theme(axis.text.x=element_text(angle=25, vjust=0.2)) 

temperature_point_region

salinity_base <- ggplot(Enviro_Data_RdRp_Mids_CTD, aes(Location, Salinity))

salinity_point <- salinity_base + 
   geom_point(colour = "green", size = 3, 
             #alpha = 6/10
  ) +
  ylim(c(10,30))

salinity_point

salinity_point_region <- salinity_point + 
  theme_classic() +
  labs(y = " Salinity (ppt)", x = "")+ 
  theme(axis.text.x=element_text(angle=25, vjust=0.2))



############ Printing out figure ###############


Environmental_params <-file.path("../figures/", paste("Environmental_params_", Sys.Date(), ".eps", sep=""))

postscript(Environmental_params, width = 11, height = 11,horizontal = FALSE, onefile = FALSE, paper = "special")


sidebysideplot <- grid.arrange(Chla_a_with_se, Silicate_with_se,Phosphate_with_se,Nitrogen_with_se,salinity_point_region, temperature_point_region, ncol=2)

dev.off()


