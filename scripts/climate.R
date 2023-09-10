library(tidyverse)
library(easystats)
library(plotly)
library(raster)
library(geodata)

# data 
data <- readxl::read_excel(here::here("data/Climate_Variables_Dengue.xlsx"))

data <- data |> mutate(Month = factor(Month, levels = month.name))


# Line Plot of Dengue Cases Over Time
plot_dengue_cases <- plot_ly(data, x = ~Month, y = ~DengueCases, type = "scatter", mode = "lines+markers") %>%
  layout(title = "Dengue Cases Over Time",
         xaxis = list(title = "Month"),
         yaxis = list(title = "Dengue Cases"))

# Bar Plot of Monthly Rainfall
plot_rainfall <- plot_ly(data, x = ~Month, y = ~Rainfall, type = "bar", marker = list(color = "skyblue")) %>%
  layout(title = "Monthly Rainfall",
         xaxis = list(title = "Month"),
         yaxis = list(title = "Rainfall (mm)"))

# Scatter Plot of Dengue Cases vs. Temperature (TMAX and TMIN)
plot_ly(data, x = ~TMAX, y = ~DengueCases, mode = "lines+markers", type = "scatter", name = "TMAX") %>%
  add_trace(x = ~TMIN, y = ~DengueCases, mode = "lines+markers", type = "scatter", name = "TMIN") %>%
  layout(title = "Dengue Cases vs. Temperature",
         xaxis = list(title = "Temperature (°C)"),
         yaxis = list(title = "Dengue Cases"))

# Box Plot of Dengue Cases by Month
plot_dengue_box <- plot_ly(data, x = ~Month, y = ~DengueCases, type = "box") %>%
  layout(title = "Distribution of Dengue Cases by Month",
         xaxis = list(title = "Month"),
         yaxis = list(title = "Dengue Cases"))

# Combine the plots into a subplot
subplot(plot_dengue_cases, plot_rainfall, plot_temp_scatter, plot_dengue_box, nrows = 2, title = "Dengue and Climate Variables")


plot_ly(data = data, x = ~Month) |> 
  add_trace(y = ~TMIN, name = "Min. Temperature (C)",  type = 'scatter', mode = 'lines+markers') |> 
  add_trace(y = ~TMAX, name = "Max. Temperature (C)",  type = 'scatter', mode = 'lines+markers') |> 
  add_trace(y = ~Rainfall, name = "Rainfall (mm)",  type = 'scatter', mode = 'lines+markers') |> 
  add_trace(y = ~Humidity, name = "Humidity (%)",  type = 'scatter', mode = 'lines+markers') |> 
  add_trace(y = ~DengueCases, name = "Dengue Cases",  type = 'scatter', mode = 'lines+markers')




