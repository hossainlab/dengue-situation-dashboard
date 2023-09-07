# packages
library(tidyverse)
library(denguedatahub)
library(lubridate)
library(plotly)


# data 
dengue_cases <- readxl::read_excel(here::here("data/DengueCaseReporting[2012-23].xlsx"),
                           sheet = 1)


# transform data into long format for visualizations 
# cases 
long_cases_data <- dengue_cases |> 
  pivot_longer(cols = 2:13, names_to = "Year", values_to = "Cases") |> 
  mutate(Months = factor(Months, levels = month.name)) 


p1 <- long_cases_data %>%
  ggplot(aes(x = Year, y = Cases)) +
  geom_line(aes(group = Year),
            alpha = 0.5) + 
  xlab("Time") + ylab("Cases") 

p1



# deaths 
long_deaths_data <- dengue_deaths |> 
  pivot_longer(cols = 2:10, names_to = "Year", values_to = "Deaths") |> 
  mutate(Months = factor(Months, levels = month.name)) 

# join data 
all_years <- left_join(long_cases_data, long_deaths_data, 
                       by = c("Months", "Year"))










# dynamic plot 
library(plotly)
subplot(p0, 
        subplot(
          ggplotly(p1, tooltip = "District", width = 2000),
          ggplotly(p2, tooltip = "District", width = 2000),
          ggplotly(p3, tooltip = "District", width = 1500),
          ggplotly(p4, tooltip = "District", width = 1500),
          nrows = 2)
) %>%
  highlight(dynamic = TRUE)