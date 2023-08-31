# load packages 
library(tidyverse)
library(readxl)
library(rio)

# read all sheets 
data23 <- import_list(here::here("data/DengueCases2023.xlsx"),
                    setclass = "data.table", 
                    rbind_label = "file", 
                    rbind = TRUE)


# check data structure 
glimpse(data23)

class(data23$Cases)

# check missing values 
gg_miss_var(data23)


# trends 
ggplot(data, aes(x = Date))+ 
  geom_line(aes(y = Cases, color = "Confirmed Cases"))+ 
  geom_line(aes(y = Deaths, color = "Confirmed Deaths"))+ 
  geom_line(aes(y = Recovered, color = "Recovered Cases"))+ 
  labs(title = "Dengue cases trend over time",
     x = "Date", 
     y = "Count")+
  scale_color_manual("Dengue Cases", 
                     values = c("Confirmed Cases" = "red", 
                                "Confirmed Deaths" = "black", 
                                "Recovered Cases" = "green")) 
  


# environment trends 
data23 %>% 
  arrange(Cases) %>%
  ggplot(aes(x = Date))+ 
    geom_line(aes(y = Cases, color = "Confirmed Cases"))+ 
    geom_line(aes(y = Precipitation, color = "Precipitation"))+ 
    geom_line(aes(y = Temperature_C, color = "Temperature (C)"))+ 
    labs(title = "Dengue cases and environmental parameters trend over time",
         x = "Date", 
         y = "Count")+
    scale_color_manual("Dengue Cases", 
                       values = c("Confirmed Cases" = "red", 
                                  "Precipitation" = "black", 
                                  "Temperature (C)" = "green")) 

ggplotly(p)

fig3 <- ggplot(data = long_cases_data, 
               aes(x = Months, y = Cases, group=Year, color=Year))+
  geom_line()+
  theme_minimal()+ 
  theme(axis.text.x = element_text(angle = 60, vjust = 0.5, hjust=1))
ggplotly(fig3)



fig3 <- ggplot(data = long_cases_data, 
               aes(x = Months, y = Cases, fill=Year))+
  geom_bar(stat="identity")+
  theme_minimal()+ 
  theme(axis.text.x = element_text(angle = 60, vjust = 0.5, hjust=1))

ggplotly(fig3)


