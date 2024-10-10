library(shiny)
library(dplyr)
library(gt)
library(psrcplot)
library(tidyr)

# Load the data (assuming the same data path is used)
summary_tbl <- readRDS('data/hts_tbl_4_shiny.rds')

# Define the server logic
server <- function(input, output, session) {
  
  # Reactive dataset based on user inputs
  dataset <- reactive({
    summary_tbl %>%
      filter(
        `Travel Category` == input$travel,
        `Demographic Category` == input$demographic,
        survey_year == input$survey_year
      )
  })
  
  # Render the plotly chart
  output$plot <- renderPlotly({
    interactive_column_chart(dataset(), x = 'travel_attribute', 
                             y = 'prop', fill = 'demographic_attribute')
  })
  
  # Render the data table using `gt`
  output$data <- render_gt({
    dataset() %>%
      select('travel_attribute', 'demographic_attribute', 'prop', 'prop_moe', 'est') %>%
      rename('Travel Value' = 'travel_attribute') %>%
      rename('Demographic Value' = 'demographic_attribute') %>%
      rename('Share' = 'prop') %>%
      rename('Share MOE' = 'prop_moe') %>%
      rename('Total' = 'est') %>%
      mutate('Total' = round(Total, -3)) %>%
      gt() %>%
      fmt_percent(columns = c('Share', 'Share MOE'), decimals = 0) %>%
      fmt_number(columns = 'Total', decimals = 0)
  })
}
