# Packages 
library(tidyverse)
library(plotly)
library(readxl)
library(rio)

# cases data 
dengue_cases <- read_excel(here::here("data/DengueCaseReporting[2012-23].xlsx"),sheet = 1)
dengue_cases <- dengue_cases |> mutate(Months = factor(Months, levels = month.name)) 

# deaths data 
dengue_deaths <- read_excel(here::here("data/DengueCaseReporting[2012-23].xlsx"),sheet = 2)
dengue_deaths <- dengue_deaths |> mutate(Months = factor(Months, levels = month.name)) 

# daily data for 2023 
daily_data_23 <- import_list(here::here("data/DengueCases2023.xlsx"),
                             setclass = "data.table", 
                             rbind_label = "file", 
                             rbind = TRUE)
# convert into date format 
daily_data_23$Date <- as.Date(daily_data_23$Date)
# impute missing values with zero 
daily_data_23[is.na(daily_data_23)] <- 0



# transform data into long format for visualizations 
# cases 
long_cases_data <- dengue_cases |> 
  pivot_longer(cols = 2:13, names_to = "Year", values_to = "Cases") |> 
  mutate(Months = factor(Months, levels = month.name)) 

# deaths 
long_deaths_data <- dengue_deaths |> 
  pivot_longer(cols = 2:10, names_to = "Year", values_to = "Deaths") |> 
  mutate(Months = factor(Months, levels = month.name)) 


# join data 
all_years <- left_join(long_cases_data, long_deaths_data, 
                       by = c("Months", "Year"))
all_years$Year <- as.factor(all_years$Year)

# Monthly dengue cases for 2023 
long_cases_data_23 <- long_cases_data|> 
  filter(Year == 2023)

long_deaths_data_23 <- long_deaths_data|> 
  filter(Year == 2023)

# join data for monthly cases 
data23 <- left_join(long_cases_data_23, long_deaths_data_23, 
                    by = c("Months", "Year"))

data23$Year <- as.factor(data23$Year)



# Viz 1: Daily Confirmed, Death, and Recovered Cases Over Time in 2023
plot_ly(data = daily_data_23, x = ~Date, type = 'scatter', mode = 'lines+markers', 
        name = 'Cases', y = ~Cases) %>%
  add_trace(y = ~Deaths, name = 'Deaths', line = list(color="black")) %>%
  add_trace(y = ~Recovered, name = 'Recovered') %>%
  layout(title = "Daily Dengue Reporting Cases in 2023", 
         xaxis = list(title = 'Date'),
         yaxis = list(title = 'Count'), 
         legend = list(orientation = "h", 
                       xanchor = "center", 
                       x = 0.5, 
                       y= 1))

# Viz 2: Number of Dengue Cases in 2023
plot_ly(data = data23, x = ~Months)  |> 
  add_bars(y = ~Cases, name = 'Confirmed Cases') |> 
  add_trace(y = ~Cases, type = 'scatter', mode = 'lines+markers', name = "Trends") |> 
  layout(title = "Month-wise Dengue Cases in 2023", 
         xaxis = list(title = 'Month'),
         yaxis = list(title = 'Number of Confirmed Cases'), 
         legend = list(orientation = "h", 
                       xanchor = "center", 
                       x = 0.5, 
                       y= 1))

# Viz 3: Number of Death Cases in 2023
plot_ly(data = data23, x = ~Months) |> 
  add_bars(y = ~Deaths, name = 'Confirmed Deaths', marker = list(color = 'black')) |> 
  add_trace(y = ~Deaths, type = 'scatter', mode = 'lines+markers', name = "Trends") |> 
  layout(title = "Month-wise Dengue Death Cases in 2023", 
         xaxis = list(title = 'Month'),
         yaxis = list(title = 'Number of Death Cases'), 
         legend = list(orientation = "h", 
                       xanchor = "center", 
                       x = 0.5, 
                       y= 1))

# Viz 4: Monthly Total Cases by Year [2012-2023]
all_years_aggregated <- all_years |> 
  group_by(Year, Months) |> 
  summarise(TotalCase = sum(Cases), 
            TotalDeaths = sum(Deaths))

plot_ly(data = all_years_aggregated, x = ~Months, y = ~TotalCase, type = 'scatter', 
        mode = 'lines', color = ~Year) |> 
  layout(title = "Monthly Total Cases by Year from 2012 to 2023",
         xaxis = list(title = "Month"),
         yaxis = list(title = "Total Cases"), 
         legend = list(orientation = "h", 
                       xanchor = "center", 
                       x = 0.5, 
                       y= 1))
# Viz 5: Monthly Total Deaths by Year [2015-2023]
plot_ly(data = all_years_aggregated, x = ~Months, y = ~TotalDeaths, type = 'scatter', 
        mode = 'lines', color = ~Year) |> 
  layout(title = "Monthly Total Deaths by Year from 2015 to 2023",
         xaxis = list(title = "Month"),
         yaxis = list(title = "Total Deaths"), 
         legend = list(orientation = "h", 
                       xanchor = "center", 
                       x = 0.5, 
                       y= 1))
# Viz 6: Year-wise Dengue Cases in Bangladesh from 2012 to 2023
year_wise_aggregated <- all_years |> 
  group_by(Year) |> 
  summarise(Total_Cases = sum(Cases), 
            Toal_Deaths = sum(Deaths))
year_wise_aggregated


plot_ly(data = year_wise_aggregated, x = ~Year)  |> 
  add_bars(y = ~Total_Cases, name = 'Cases', marker = list(color = "#2f4b7c")) |> 
  layout(title = 'Year-wise Dengue Cases in Bangladesh from 2012 to 2023', 
         xaxis = list(title = 'Year'),
         yaxis = list(title = 'Number of Cases'))


# Viz 7: Year-wise Dengue Cases in Bangladesh from 2015 to 2023
plot_ly(data = year_wise_aggregated, x = ~Year)  |> 
  add_bars(y = ~Toal_Deaths, name = 'Cases', marker = list(color = "#ff7c43")) |> 
  layout(title = 'Year-wise Dengue Death Cases in Bangladesh from 2015 to 2023', 
         xaxis = list(title = 'Year'),
         yaxis = list(title = 'Number of Cases'))


