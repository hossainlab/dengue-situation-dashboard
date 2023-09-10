# Install and load necessary packages
install.packages("forecast")

library(tidyverse)
library(forecast)

# Read the data 
dengue_data <- read_excel(here::here("data/DengueCaseReporting[2012-23].xlsx"),sheet = 1)

# Transpose the data so that months are rows and years are columns
dengue_data <- t(dengue_data)

# Convert row names (months) to a time series
dengue_ts <- ts(dengue_data[, -1], start = c(2012, 1), end = c(2023, 12), frequency = 12)

# Fit the SARIMA model
sarima_model <- auto.arima(dengue_ts, seasonal = TRUE, 
                           stepwise = TRUE,
                           approximation = TRUE, 
                           max.order=10)

