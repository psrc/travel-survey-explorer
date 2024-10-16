library(shiny)
library(dplyr)
library(gt)
library(psrcplot)
library(tidyr)

server <- function(input, output, session) {

# Reactive dataset
dataset <- reactive({
  req(input$travel, input$demographic, input$survey_year)  # Ensure inputs are available
  
  # Filter the dataset based on user input
  summary_tbl %>%
    filter(travel_category == input$travel, 
           demographic_category == input$demographic, 
           survey_year == input$survey_year)
})


# Render the filtered data as a gt table
output$data <- render_gt({
  dataset() %>%
    select('travel_attribute', 'demographic_attribute', 'prop', 'prop_moe', 'est') %>%
    rename('Topic of Interest' = 'travel_attribute') %>%
    rename('Traveler Characteristic' = 'demographic_attribute') %>%
    rename('Share' = 'prop') %>%
    rename('Share MOE' = 'prop_moe') %>%
    rename('Total' = 'est') %>%
    mutate('Total' = round(Total, -3)) %>%
    gt() %>%
    fmt_percent(columns = c('Share', 'Share MOE'), decimals = 0) %>%
    fmt_number(columns = 'Total', decimals = 0)
})


output$plot <- renderPlotly({
  req(dataset())  # Ensure dataset is available
  
  # Create the interactive Plotly plot
  interactive_column_chart(dataset(), x = 'travel_attribute', 
                           y = 'prop', fill = 'demographic_attribute', moe='prop_moe') %>%
    ggplotly()  # Convert ggplot to plotly
})

# Download the filtered data as an Excel file
output$downloadData <- downloadHandler(
  filename = function() {
    paste("Travel_Survey_Data_", Sys.Date(), ".xlsx", sep = "")
  },
  content = function(file) {
    req(dataset())  # Ensure dataset is available
    if (nrow(dataset()) == 0) {
      stop("No data available for download.")  # Add error handling if dataset is empty
    }
    write_xlsx(dataset(), path = file)  # Write the dataset to an Excel file
  }
)

# Download the plot as an HTML file
output$downloadPlot <- downloadHandler(
  filename = function() {
    paste("Travel_Survey_Plot_", Sys.Date(), ".html", sep = "")
  },
  content = function(file) {
    req(dataset())  # Ensure dataset is available
    if (nrow(dataset()) == 0) {
      stop("No data available for download.")  # Add error handling if dataset is empty
    }
    plot <- static_column_chart(dataset(), x = 'travel_attribute', 
                                     y = 'prop', fill = 'demographic_attribute', moe='prop_moe')
    saveWidget(as_widget(plot), file)  # Save the plot as an HTML widget
  }
)
}
