# Install and load necessary packages
library(shiny)
library(shinydashboard)
library(leaflet)

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
  titlePanel("Dengue Early Warning System"),
  leafletOutput("map"),
  mainPanel(
    h4("Dengue Cases and Deaths"),
    verbatimTextOutput("dengue_info"),
    verbatimTextOutput("warning_message")
  )
)

server <- function(input, output, session) {
  output$map <- renderLeaflet({
    leaflet(dengue_data) %>%
      addTiles() %>%
      addCircleMarkers(
        lng = ~Longitude,
        lat = ~Latitude,
        radius = ~sqrt(Cases) * 5,
        color = "blue",
        label = ~paste("Location:", Location),
        popup = ~paste("Location:", Location, "<br> Cases:", Cases, "<br> Deaths:", Deaths)
      )
  })
  
  output$dengue_info <- renderText({
    latest_data <- tail(dengue_data, 1)
    paste("Date:", latest_data$Date, "\n",
          "Cases:", latest_data$Cases, "\n",
          "Deaths:", latest_data$Deaths)
  })
  
  output$warning_message <- renderText({
    latest_data <- tail(dengue_data, 1)
    warning_message <- character(0)
    
    # Define warning criteria (you can customize this)
    cases_threshold <- 30
    deaths_threshold <- 1
    
    if (latest_data$Cases >= cases_threshold) {
      warning_message <- c(warning_message, "High number of Dengue cases detected!")
    }
    
    if (latest_data$Deaths >= deaths_threshold) {
      warning_message <- c(warning_message, "High number of Dengue deaths detected!")
    }
    
    if (length(warning_message) > 0) {
      paste("Warning:\n", warning_message, collapse = "\n")
    } else {
      "No warning"
    }
  })
}

shinyApp(ui, server)