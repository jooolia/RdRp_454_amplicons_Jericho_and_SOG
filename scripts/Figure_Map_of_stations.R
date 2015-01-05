## Author: Julia Gustavsen
## Purpose: Generate map of stations based on coordinates. 

library(maps)
library(mapdata)



Save_station_map_file <-file.path("../figures/", paste("station_map_", Sys.Date(), ".eps", sep=""))

postscript(Save_station_map_file, width = 11, height = 11,horizontal = FALSE, onefile = FALSE, paper = "special")


#Would like to make the colours standard by site. Will work on this
#22, 23, 24,25, 26
#colours_by_site <-c("#153D39","#2C9473","#FFB842", "#FF5B13" ,"#E80776")

#poster_scheme <- c( "#FFE07A", "#C17AFF", "#821CDC", "#4B0A84", "#84670A")


#x is longitude
#y is latitude
y_coordi <- c(48.75, 50)
x_coordi <- c(-125,-122.5)

map("worldHires","Canada",
    xlim=x_coordi,
     ylim=y_coordi,
    col="gray", 
    fill=TRUE,
    mar = c(1, 1, par("mar")[1], 0.1),
    myborder = 0.0)

map("worldHires",
    "usa",
    xlim=x_coordi,
    ylim=y_coordi,
    col="gray95",
    fill=TRUE,
    add=TRUE)

samps <- read.csv("../data/Lat_lon_stations.csv")   

points(samps$lon, samps$lat,
       pch=19, 
     col="black",
       cex=1) 

text(samps$lon, samps$lat,
     samps$site, 
     offset = 0.2, 
     cex=1.5,
     pos=2,
     col="black"
     ) 

map.scale(cex= 0.5)

#map cities
map.cities(country="Canada",
           label=TRUE,
           cex=1.2,
           xlim=x_coordi,
           ylim=y_coordi,
           pch=20, 
           minpop=40000)
map.axes()

box()

dev.off()

Save_Canada_map_file <-file.path("../figures/", paste("Canada_map", Sys.Date(), ".eps", sep=""))

postscript(Save_Canada_map_file, width = 11, height = 11,horizontal = FALSE, onefile = FALSE, paper = "special")

map("worldHires","Canada",  col="gray",  fill=TRUE)

dev.off()
