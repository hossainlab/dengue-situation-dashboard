# packages
library(tidyverse)
library(readxl)
library(denguedatahub)
library(lubridate)
library(plotly)


# cases data 
dengue_cases <- read_excel(here::here("data/DengueCaseReporting[2012-23].xlsx"),sheet = 1)
dengue_cases <- dengue_cases |> mutate(Months = factor(Months, levels = month.name)) 

# deaths data 
dengue_deaths <- read_excel(here::here("data/DengueCaseReporting[2012-23].xlsx"),sheet = 2)
dengue_deaths <- dengue_deaths |> mutate(Months = factor(Months, levels = month.name)) 

# transform data into long format for visualizations 
# cases 
long_cases_data <- dengue_cases |> 
  pivot_longer(cols = 2:13, names_to = "Year", values_to = "Cases") |> 
  mutate(Months = factor(Months, levels = month.name)) 

# deaths 
long_deaths_data <- dengue_deaths |> 
  pivot_longer(cols = 2:10, names_to = "Year", values_to = "Deaths") |> 
  mutate(Months = factor(Months, levels = month.name)) 

# join data and filter data 
all_years_data <- left_join(long_cases_data, long_deaths_data, 
                       by = c("Months", "Year"))


all_years_data |> 
  filter(Year == c(2019, 2022, 2023))


