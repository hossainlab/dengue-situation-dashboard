# Load required libraries
library(plotly)

# Sample data (replace this with your actual data)
data <- data.frame(
  Date = seq(as.Date("2023-01-01"), as.Date("2023-01-10"), by = "days"),
  Cases = c(100, 150, 200, 250, 300, 350, 400, 450, 500, 550),
  Deaths = c(10, 15, 20, 25, 30, 35, 40, 45, 50, 55),
  Recovered = c(50, 70, 90, 110, 130, 150, 170, 190, 210, 230),
  Precipitation = c(0.1, 0.2, 0.3, 0.4, 0.5, 0.6, 0.7, 0.8, 0.9, 1.0),
  Temperature_C = c(20, 21, 22, 23, 24, 25, 26, 27, 28, 29),
  RHDay_PCT = c(60, 62, 65, 68, 70, 72, 75, 78, 80, 82),
  RHNight_PCT = c(45, 47, 50, 53, 55, 57, 60, 63, 65, 67),
  Soil_Moisture = c(0.4, 0.42, 0.45, 0.48, 0.5, 0.52, 0.55, 0.58, 0.6, 0.62),
  Vegetation_Monthly = c(0.2, 0.25, 0.3, 0.35, 0.4, 0.45, 0.5, 0.55, 0.6, 0.65)
)

# Line chart for Cases, Deaths, and Recovered
line_chart <- plot_ly(data, x = ~Date) %>%
  add_lines(y = ~Cases, name = "Cases", line = list(color = "blue")) %>%
  add_lines(y = ~Deaths, name = "Deaths", line = list(color = "red")) %>%
  add_lines(y = ~Recovered, name = "Recovered", line = list(color = "green")) %>%
  layout(title = "COVID-19 Statistics",
         xaxis = list(title = "Date"),
         yaxis = list(title = "Count"))
line_chart
# Bar chart for Precipitation
bar_chart <- plot_ly(data, x = ~Date, y = ~Precipitation, type = "bar") %>%
  layout(title = "Precipitation",
         xaxis = list(title = "Date"),
         yaxis = list(title = "Precipitation"))
bar_chart

# Scatter plot for Temperature vs. RHDay_PCT
scatter_plot <- plot_ly(data, x = ~Temperature_C, y = ~RHDay_PCT,
                        text = ~paste("Temp:", Temperature_C, "°C<br>RH:", RHDay_PCT, "%"),
                        mode = "markers", marker = list(size = 10, opacity = 0.7)) %>%
  layout(title = "Temperature vs. Daytime Relative Humidity",
         xaxis = list(title = "Temperature (°C)"),
         yaxis = list(title = "Daytime RH (%)"))
scatter_plot

# Subplots for Soil Moisture and Vegetation Monthly
subplot <- subplot(
  plot_ly(data, x = ~Date, y = ~Soil_Moisture, name = "Soil Moisture"),
  plot_ly(data, x = ~Date, y = ~Vegetation_Monthly, name = "Vegetation Monthly"),
  nrows = 2
)

# Arrange the visualizations in a grid
grid <- subplot(line_chart, bar_chart, scatter_plot, subplot, ncol = 1)

# Show the grid
grid
