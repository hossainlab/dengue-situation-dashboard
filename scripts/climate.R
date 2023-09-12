library(tidyverse)
library(raster)
library(geodata)
library(RColorBrewer)

min_val <- 4.943266 
max_val <- 17.502493 

file <- raster(here::here("climate_data/precp.tif"))
summary(file)


mean(file)


plot(file, at = seq(min_val, max_val, length.out = 11))
