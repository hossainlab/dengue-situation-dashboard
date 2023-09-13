# Documentation 01 - Package: bangladesh 
# https://www.ovirahman.com/bangladesh/articles/introduction.html

# Documentation 02 - Package: tmap 
# https://cran.r-project.org/web/packages/tmap/vignettes/tmap-getstarted.html

# load packages 
library(tidyverse)
library(tmap)
library(bangladesh)

# all division data 
division_map <- get_map("division")
division_centroids <- bangladesh::get_coordinates(level = "division")


# individual division 
dhaka <- get_divisions(divisions = "Dhaka",level =  "upazila")
# single division
ggplot(data = dhaka) +
  geom_sf() +
  xlab("")+ ylab("")+
  theme_minimal()
