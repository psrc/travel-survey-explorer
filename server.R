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

# Reactive dataset
plot<- reactive({
  dataset()
  
  interactive_column_chart(dataset(), x = 'travel_attribute', 
                           y = 'prop', fill = 'demographic_attribute', moe='prop_moe')
})

# Render the filtered data as a gt table
output$data <- render_gt({
  dataset() %>%
    select('travel_attribute', 'demographic_attribute', 'prop', 'prop_moe', 'est', 'count') %>%
    rename('Topic of Interest' = 'travel_attribute') %>%
    rename('Traveler Characteristic' = 'demographic_attribute') %>%
    rename('Share' = 'prop') %>%
    rename('Share Margin of Error' = 'prop_moe') %>%
    rename('Sample Size'='count')%>%
    rename('Total' = 'est') %>%
    mutate('Total' = round(Total, -3)) %>%
    gt() %>%
    fmt_percent(columns = c('Share', 'Share Margin of Error'), decimals = 0) %>%
    fmt_number(columns = 'Total', decimals = 0)
})


output$plot <- renderPlotly({
  plot()
  
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
    saveWidget(as_widget(plot()), file)  # Save the plot as an HTML widget
  }
)
}
