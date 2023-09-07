library(tidyverse)
library(ggthemes)
library(hrbrthemes)
library(maps)
library(magrittr)
library(viridis)
library(denguedatahub)
library(visdat)

# Level of Dengue risk around the world
level_of_risk

# Visualize level_of_risk dataset
vis_dat(level_of_risk) 

# Summarize and Visualize level_of_riskdata
tab1 <- level_of_risk %>% group_by(region, level_of_risk) %>%
  summarise(count = n(), .groups = 'drop') 
knitr::kable(tab1)

ggplot(tab1, aes(region, count)) + 
  geom_bar(aes(fill = level_of_risk), stat = "identity", position = "dodge")+
  labs(title = "Level of Dengue risk around the world",
       subtitle = "The level of risk in the context of dengue refers to the likelihood of dengue outbreaks happening in various regions worldwide.", 
       x = "Region",
       y = "Number of countries", 
       caption = "by Jubayer Hossain, Data Source: denguedatahub")+ 
  guides(fill = guide_legend(title = "Level of Risk"))+
  scale_fill_brewer(palette = "Dark2")+ 
  theme(legend.position = "top") 


ggplotly(p)

# Presence of dengue incidence in 2019
worlddata2019 <- dplyr::filter(world_annual, year == 2019)
ggplot(worlddata2019, aes(x = long,
                          y = lat,
                          group=group,
                          fill = dengue.present)) +
  geom_polygon(color = "black") +
  labs(title = "Presence of dengue incidence in 2019", 
       subtitle = "Dengue Incidence in 2019: A Global Health Challenge", 
       x = "Longitude",
       y = "Latitude", 
       caption = "by Jubayer Hossain, Data Source: denguedatahub") +
  guides(fill = guide_legend(title = "Dengue Present?"))+
  theme(legend.position = "top") + 
  scale_fill_brewer(palette = "Dark2") 

# Global Dengue Incidence 
world_annual |> 
  group_by(year) |> 
  summarise(Total)

plot_ly(data = world_annual, x = ~year)  |> 
  add_bars(y = ~incidence, name = 'Dengue Incidence', marker = list(color = "#ff7c43")) |> 
  layout(title = 'Global Dengue Incidence from ', 
         xaxis = list(title = 'Year'),
         yaxis = list(title = 'Incidence'))


world <- world_annual
