library(tidyverse)
library(readxl)
library(rio)
library(plotly)
library(hrbrthemes)

# cases data 
dengue_cases <- read_excel(here::here("data/DengueCaseReporting[2012-23].xlsx"),
                        sheet = 1) 


# deaths data 
dengue_deaths <- read_excel(here::here("data/DengueCaseReporting[2012-23].xlsx"),
                           sheet = 2)

# daily data 
daily_data_23 <- import_list(here::here("data/DengueCases2023.xlsx"),
                      setclass = "data.table", 
                      rbind_label = "file", 
                      rbind = TRUE)

daily_data_23$Date <- as.Date(data23$Date)

# Daily dengue pattern 
# Create a time series line plot
plot_ly(data = daily_data_23, x = ~Date, type = 'scatter', mode = 'lines+markers', 
        name = 'Cases', y = ~Cases) %>%
  add_trace(y = ~Deaths, name = 'Deaths', line = list(color="black")) %>%
  add_trace(y = ~Recovered, name = 'Recovered') %>%
  layout(xaxis = list(title = 'Date'),
         yaxis = list(title = 'Count'))



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



# Monthly dengue cases for 2023 
long_cases_data_23 <- long_cases_data|> 
  filter(Year == 2023)

long_deaths_data_23 <- long_deaths_data|> 
  filter(Year == 2023)

# join data 
data23 <- left_join(long_cases_data_23, long_deaths_data_23, 
                    by = c("Months", "Year"))

# bar charts for dengue cases in 2023 
plot_ly(data = data23, x = ~Months)  |> 
  add_bars(y = ~Cases, name = 'Confirmed Cases') |> 
  add_trace(y = ~Cases, type = 'scatter', mode = 'lines+markers', name = "Trends") |> 
  # Add other years similarly
  layout(xaxis = list(title = 'Month'),
         yaxis = list(title = 'Number of Confirmed Cases'))

# bar charts for dengue deaths in 2023 
plot_ly(data = data23, x = ~Months) |> 
  add_bars(y = ~Deaths, name = 'Confirmed Deaths', marker = list(color = 'black')) |> 
  add_trace(y = ~Deaths, type = 'scatter', mode = 'lines+markers', name = "Trends") |> 
  layout(xaxis = list(title = 'Month'),
         yaxis = list(title = 'Number of Death Cases'))


# Dengue Cases by year 
plot_ly(data = dengue_cases, x = ~Months)  |> 
  add_bars(y = ~`2012`, name = '2012') |>
  add_bars(y = ~`2013`, name = '2013') |>
  add_bars(y = ~`2014`, name = '2014') |>
  add_bars(y = ~`2015`, name = '2015') |>
  add_bars(y = ~`2016`, name = '2016') |>
  add_bars(y = ~`2017`, name = '2017') |>
  add_bars(y = ~`2018`, name = '2018') |>
  add_bars(y = ~`2019`, name = '2019') |>
  add_bars(y = ~`2020`, name = '2020') |>
  add_bars(y = ~`2021`, name = '2021') |>
  add_bars(y = ~`2022`, name = '2022') |>
  add_bars(y = ~`2023`, name = '2023') |>
  layout(xaxis = list(title = 'Month'),
         yaxis = list(title = 'Number of Confirmed Cases'))

# Dengue deaths by year 
plot_ly(data = dengue_deaths, x = ~Months)  |> 
  add_bars(y = ~`2015`, name = '2015') |>
  add_bars(y = ~`2016`, name = '2016') |>
  add_bars(y = ~`2017`, name = '2017') |>
  add_bars(y = ~`2018`, name = '2018') |>
  add_bars(y = ~`2019`, name = '2019') |>
  add_bars(y = ~`2020`, name = '2020') |>
  add_bars(y = ~`2021`, name = '2021') |>
  add_bars(y = ~`2022`, name = '2022') |>
  add_bars(y = ~`2023`, name = '2023') |>
  layout(xaxis = list(title = 'Month'),
         yaxis = list(title = 'Number of Death Cases'))


# all years pattern 
# Create a bar chart to show the yearly sum of cases and deaths
plot_ly(data = all_years, x = ~Year, y = ~Cases, type = 'bar', name = 'Cases') %>%
  add_trace(y = ~Deaths, name = 'Deaths') %>%
  layout(xaxis = list(title = 'Year'),
         yaxis = list(title = 'Cases'))
