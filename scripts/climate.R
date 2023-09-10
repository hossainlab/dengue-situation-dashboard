library(tidyverse)
library(easystats)
library(plotly)
library(raster)
library(geodata)

# data 
climate_data <- readxl::read_excel(here::here("data/Climate_Variables_Dengue.xlsx"))
climate_data <- climate_data |> mutate(Month = factor(Month, levels = month.name))



ggplot(climate_data, aes(x = Month)) +
  geom_line(aes(y = TMIN, color = "Min. Temperature (C)"))


plot_ly(data = climate_data, x = ~Month) |> 
  add_trace(y = ~TMIN, name = "Min. Temperature (C)",  type = 'scatter', mode = 'lines+markers') |> 
  add_trace(y = ~TMAX, name = "Max. Temperature (C)",  type = 'scatter', mode = 'lines+markers') |> 
  add_trace(y = ~Rainfall, name = "Rainfall (mm)",  type = 'scatter', mode = 'lines+markers') |> 
  add_trace(y = ~Humidity, name = "Humidity (%)",  type = 'scatter', mode = 'lines+markers') |> 
  add_trace(y = ~DengueCases, name = "Dengue Cases",  type = 'scatter', mode = 'lines+markers')




