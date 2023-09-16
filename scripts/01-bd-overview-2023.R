# Color: https://www.datanovia.com/en/blog/top-r-color-palettes-to-know-for-great-data-visualization/


# Load packages 
library(googlesheets4)
library(tidyverse)
library(imputeTS)
library(highcharter)
library(forecast)

# daily data for 2023 
daily_data_23_url <- "https://docs.google.com/spreadsheets/d/1QgYLR4FW0f9MxiH0GDZm2_5tZOdAlLZAKT4-8Tz9rwQ/edit?usp=sharing"

# read multiple data sheets 
daily_data_23 <- daily_data_23_url |> 
  sheet_names() |> 
  set_names() |> 
  map_df(read_sheet, ss = daily_data_23_url, .id = "Month") |> 
  mutate(Month = factor(Month, levels = month.name)) |> 
  mutate(Date = as.Date(Date)) 


# Viz 1: Daily dengue cases over the time 
highchart()  |> 
  hc_xAxis(categories = daily_data_23$Date)  |> 
  hc_add_series(daily_data_23$Cases, 
                type = "line", 
                name = "Cases") |> 
  hc_add_series(daily_data_23$Deaths, 
                type = "line", 
                name = "Deaths") |> 
  hc_add_series(daily_data_23$Recovered,
                type = "line", 
                name = "Recovered")|>
  hc_xAxis(title = list(text = "Date"))  |> 
  hc_yAxis(title = list(text = "Cases")) |> 
  hc_title(text = 'Daily Dengue Cases',
           style = list(fontSize = '25px', 
                        fontWeight = 'bold')) |>
  hc_subtitle(text = 'The number of reported dengue cases by DGHS', 
              style = list(fontSize = '16px')) |> 
  hc_caption(text = "Source: Directorate General of Health Services, Bangladesh (2023") |> 
  hc_credits(enabled = TRUE, text = '@Md. Jubayer Hossain') |> 
  hc_add_theme(hc_theme_google())

# Viz 2: Monthly Dengue Cases, Deaths, and Recovered in 2023
seasonal_trends <- daily_data_23 |> 
  group_by(Month) |> 
  summarise(TotalCases = sum(Cases, na.rm = T), 
            TotalDeaths = sum(Deaths, na.rm = T), 
            TotalRecovered = sum(Recovered, na.rm = T))
highchart()  |> 
  hc_xAxis(categories = seasonal_trends$Month) |> 
  hc_add_series(data = seasonal_trends$TotalCases, type = "line", name = "Confirmed Cases") |> 
  hc_add_series(data = seasonal_trends$TotalRecovered, type = "line", name = "Recovered Cases") |> 
  hc_add_series(data = seasonal_trends$TotalDeaths, type = "line", name = "Deaths Cases") |> 
  hc_xAxis(title = list(text = "Month"))  |> 
  hc_yAxis(title = list(text = "Number of Reported Cases")) |> 
  hc_title(text = 'Seasonality of dengue outbreaks in Bangladesh in 2023',style = list(fontSize = '25px', fontWeight = 'bold')) |>
  hc_subtitle(text = 'By Month', style = list(fontSize = '16px')) |> 
  hc_caption(text = "Source: Directorate General of Health Services, Bangladesh (2023") |> 
  hc_credits(enabled = TRUE, text = '@Md. Jubayer Hossain')

# Viz 3: Number of Dengue Cases by Month in 2023
highchart()  |> 
  hc_xAxis(categories = seasonal_trends$Month) |> 
  hc_add_series(data = seasonal_trends$TotalCases, type = "column", name = "Confirmed Cases") |> 
  hc_add_series(data = seasonal_trends$TotalCases, type = "line", name = "Trend") |> 
  hc_xAxis(title = list(text = "Month"))  |> 
  hc_yAxis(title = list(text = "Number of Reported Cases")) |> 
  hc_title(text = 'Seasonality of dengue outbreaks in Bangladesh in 2023',style = list(fontSize = '25px', fontWeight = 'bold')) |>
  hc_subtitle(text = 'By Month', style = list(fontSize = '16px')) |> 
  hc_caption(text = "Source: Directorate General of Health Services, Bangladesh (2023") |> 
  hc_credits(enabled = TRUE, text = '@Md. Jubayer Hossain') |> 
  hc_add_theme(hc_theme_google())


# Viz 4: Number of Death Cases by Month in 2023
highchart()  |> 
  hc_xAxis(categories = seasonal_trends$Month) |> 
  hc_add_series(data = seasonal_trends$TotalDeaths, type = "column", 
                name = "Deaths", color = viridis::mako(n = 9)) |> 
  hc_add_series(data = seasonal_trends$TotalDeaths, type = "line", name = "Trend") |> 
  hc_xAxis(title = list(text = "Month"))  |> 
  hc_yAxis(title = list(text = "Number of Reported Cases")) |> 
  hc_title(text = 'Seasonality of dengue outbreaks in Bangladesh in 2023',style = list(fontSize = '25px', fontWeight = 'bold')) |>
  hc_subtitle(text = 'By Month', style = list(fontSize = '16px')) |> 
  hc_caption(text = "Source: Directorate General of Health Services, Bangladesh (2023") |> 
  hc_credits(enabled = TRUE, text = '@Md. Jubayer Hossain') |> 
  hc_add_theme(hc_theme_google())



# Viz 5: Comparison 
highchart()  |> 
  hc_xAxis(categories = seasonal_trends$Month) |> 
  hc_add_series(data = seasonal_trends$TotalCases, 
                type = "column", 
                name = "Confirmed Cases", 
                color = "#EFC000FF") |> 
  hc_add_series(data = seasonal_trends$TotalRecovered, 
                type = "column", 
                name = "Recovered Cases") |> 
  hc_add_series(data = seasonal_trends$TotalDeaths,
                type = "column", 
                name = "Deaths Cases") |> 
  hc_xAxis(title = list(text = "Month"))  |> 
  hc_yAxis(title = list(text = "Number of Reported Cases")) |> 
  hc_title(text = 'Seasonality of dengue outbreaks in Bangladesh in 2023',style = list(fontSize = '25px', fontWeight = 'bold')) |>
  hc_subtitle(text = 'By Month', style = list(fontSize = '16px')) |> 
  hc_caption(text = "Source: Directorate General of Health Services, Bangladesh (2023") |> 
  hc_credits(enabled = TRUE, text = '@Md. Jubayer Hossain') |> 
  hc_add_theme(hc_theme_google())
