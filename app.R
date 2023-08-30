library(shiny)
library(ggplot2)

# Create a data frame from the provided data
df <- data.frame(
  Months = c("January", "February", "March", "April", "May", "June", "July",
             "August", "September", "October", "November", "December"),
  `2012` = c(0, 0, 0, 0, 0, 16, 108, 138, 262, 90, 57, 0),
  `2013` = c(0, 0, 0, 0, 4, 44, 220, 353, 495, 363, 212, 58),
  `2014` = c(15, 7, 2, 0, 8, 9, 82, 80, 76, 63, 22, 11),
  `2015` = c(0, 0, 2, 6, 10, 28, 171, 765, 965, 869, 271, 75),
  `2016` = c(13, 3, 17, 38, 70, 254, 926, 1451, 1544, 1077, 522, 145),
  `2017` = c(92, 58, 36, 73, 134, 265, 286, 346, 430, 512, 409, 126),
  `2018` = c(26, 7, 19, 29, 52, 295, 946, 1796, 3087, 2406, 1192, 293),
  `2019` = c(38, 18, 17, 58, 193, 1884, 16253, 52636, 16856, 8143, 4011, 1247),
  `2020` = c(199, 45, 27, 25, 10, 20, 23, 68, 47, 164, 546, 231),
  `2021` = c(32, 9, 13, 3, 43, 272, 2286, 7698, 7841, 5458, 3567, 1207),
  `2022` = c(126, 20, 20, 23, 163, 737, 1571, 3521, 9911, 21932, 19334, 5024),
  `2023` = c(566, 166, 111, 143, 1036, 5956, 1893, 0, 0, 0, 0, 0)
)

# Define the UI
ui <- fluidPage(
  titlePanel("Monthly Data Visualization Dashboard"),
  sidebarLayout(
    sidebarPanel(
      selectInput(
        inputId = "year",
        label = "Select Year",
        choices = colnames(df)[-1],
        selected = colnames(df)[2]
      )
    ),
    mainPanel(
      plotOutput(outputId = "barPlot"),
      plotOutput(outputId = "linePlot")
    )
  )
)

# Define the server
server <- function(input, output) {
  # Bar plot
  output$barPlot <- renderPlot({
    year_data <- df[, c("Months", input$year)]
    bar_plot <- ggplot(year_data, aes(x = reorder(Months, desc(year_data[, 2])), y = year_data[, 2])) +
      geom_bar(stat = "identity", fill = "steelblue") +
      labs(title = paste("Monthly Count for", input$year),
           x = "Month",
           y = "Count")
    print(bar_plot)
  })
  
  # Line plot
  output$linePlot <- renderPlot({
    line_plot <- ggplot(df, aes(x = Months, y = df[, input$year], group = 1)) +
      geom_line(color = "steelblue", size = 1) +
      labs(title = paste("Monthly Count Trend for", input$year),
           x = "Month",
           y = "Count")
    print(line_plot)
  })
}

# Run the application
shinyApp(ui = ui, server = server)
