# load package 
library(tidyverse)
library(readxl)
library(rio)

# cases data 
dengue_cases <- read_excel(here::here("data/DengueCaseReporting[2012-23].xlsx"),sheet = 1)
dengue_cases <- dengue_cases |> mutate(Months = factor(Months, levels = month.name)) 

# deaths data 
dengue_deaths <- read_excel(here::here("data/DengueCaseReporting[2012-23].xlsx"),sheet = 2)
dengue_deaths <- dengue_deaths |> mutate(Months = factor(Months, levels = month.name)) 


# transform cases data into long format for visualizations 
long_cases_data <- dengue_cases |> 
  pivot_longer(cols = 2:13, names_to = "Year", values_to = "Cases") |> 
  mutate(Months = factor(Months, levels = month.name)) 

# transform deaths data into long format for visualizations 
long_deaths_data <- dengue_deaths |> 
  pivot_longer(cols = 2:10, names_to = "Year", values_to = "Deaths") |> 
  mutate(Months = factor(Months, levels = month.name)) 

# join data 
all_years <- left_join(long_cases_data, long_deaths_data, by = c("Months", "Year"))
all_years$Year <- as.factor(all_years$Year)

# Monthly dengue cases for 2023 
long_cases_data_23 <- long_cases_data|> 
  filter(Year == 2023)

long_deaths_data_23 <- long_deaths_data|> 
  filter(Year == 2023)

# Join data for monthly cases 
data23 <- left_join(long_cases_data_23, long_deaths_data_23, by = c("Months", "Year"))
data23$Year <- as.factor(data23$Year)





# daily data for 2023 
daily_data_23 <- import_list(here::here("data/DengueCases2023.xlsx"),
                             setclass = "data.table", 
                             rbind_label = "file", 
                             rbind = TRUE)

# convert into date format 
daily_data_23$Date <- as.Date(daily_data_23$Date)

# impute missing values with zero 
daily_data_23[is.na(daily_data_23)] <- 0

# daily_data_23
daily_data_23 <- daily_data_23 |> 
  mutate(Month = lubridate::month(Date, label = TRUE),
         Day = lubridate::day(Date)) 
