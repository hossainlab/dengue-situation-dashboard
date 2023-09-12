library(tidyverse)
library(shiny)
library(ggplot2)
library(scales)
library(rio)

# data 
dengue_data <- import_list(here::here("data/DengueCases2023.xlsx"),
                           setclass = "data.table", 
                           rbind_label = "file", 
                           rbind = TRUE)

# Convert Date column to a date object
dengue_data$Date <- as.Date(dengue_data$Date, format = "%m/%d/%Y")

# Fill missing values with zeros
dengue_data[is.na(dengue_data)] <- 0


ui <- fluidPage(
  titlePanel("Dengue Data Visualization"),
  sidebarLayout(
    sidebarPanel(
      dateRangeInput("date_range", "Select Date Range", start = "2023-01-01", end = "2023-12-31"),
      selectInput("plot_type", "Select Plot Type", choices = c("Cases", "Deaths", "Recovered"))
    ),
    mainPanel(
      plotOutput("dengue_plot")
    )
  )
)

server <- function(input, output) {
  filtered_data <- reactive({
    dengue_data %>%
      filter(Date >= input$date_range[1], Date <= input$date_range[2])
  })
  
  output$dengue_plot <- renderPlot({
    ggplot(filtered_data(), aes(x = Date, y = .data[[input$plot_type]])) +
      geom_line() +
      labs(title = paste(input$plot_type, "Over Time"),
           x = "Date",
           y = input$plot_type) +
      theme_minimal()
  })
}

shinyApp(ui, server)



