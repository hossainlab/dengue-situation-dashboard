## Data cleaning 
library(tidyverse)
library(magrittr)
library(purrr)
library(forcats)

## Maps and Plots
library(plotly)
library(ggthemes)
library(ggpubr)
library(leaflet)
library(leafpop)
library(RColorBrewer)

# Dates
library(lubridate)

# For displaying tables
library(DT)
library(readxl)

# read multiple sheets
data23 <- bind_rows("DengueCases2023.xlsx" %>%
                               excel_sheets() %>%
                               purrr::set_names()%>%
                               map(read_excel, path = "DengueCases2023.xlsx"))



# for time series plot
df_daily <- data23 %>%
  select(1:3)
  group_by(Date) %>% 
  mutate(confirmed_cum = cumsum(`Confirmed Cases`), 
    death_cum = cumsum(`Confirmed Deaths`))


fig <- plot_ly(
    data = data23,
    x = ~ Date,
    y = ~ `Confirmed Cases`,
    name = "Confirmed Cases",
    fillcolor = "blue",
    type = "line",
    mode = "none",
    stackgroup = "one") %>%
    add_trace(y = ~ `Confirmed Deaths`,
              name = "Death",
              fillcolor = "red") %>%
    layout(
        title = "",
        yaxis = list(title = "Cumulative Number of Dengue Cases"),
        xaxis = list(title = "Date",
                     type = "Date"),
        legend = list(x = 0.1, y = 0.9),
        hovermode = "compare"
    )
fig



# read dengue cases data from 2012 to 2023  
all_cases_data <- readxl::read_excel("DengueCaseReporting[2012-23].xlsx", sheet = 1)

# read dengue deaths data from 2012 to 2023  
all_deaths_data <- readxl::read_excel("DengueCaseReporting[2012-23].xlsx", sheet = 2)


long_data <- data %>% 
  pivot_longer(cols = 2:13, names_to = "Year", values_to = "Cases") %>% 
  mutate(Months = factor(Months, levels = month.name)) %>%
  arrange(Months)

fig1 <- ggplot(data = long_data, aes(x = Months, y = Cases, fill=Year))+
  geom_bar(stat="identity")

ggplotly(fig1)






