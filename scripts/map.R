# Documentation 01 - Package: bangladesh 
# https://www.ovirahman.com/bangladesh/articles/introduction.html

# Documentation 02 - Package: tmap 
# https://cran.r-project.org/web/packages/tmap/vignettes/tmap-getstarted.html

# load packages 
library(tidyverse)
library(tmap)
library(bangladesh)



country <- get_map("country")




sylhet <- get_divisions(divisions = "Sylhet", level =  "upazila")
# single division
ggplot(data = sylhet) +
  geom_sf() +
  xlab("")+ ylab("")+
  theme_minimal()
