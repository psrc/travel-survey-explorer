library(shiny)
library(dplyr)
library(gt)
library(psrcplot)
library(tidyr)

vars <- c("travel_attribute" = "Travel Value", 
          "demographic_attribute" = "Demographic Value", 
          "prop" = "Share", 
          "prop_moe" = "Share MOE", 
          "est" = "Total")

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
    interactive_column_chart(dataset(), 
                             x = 'travel_attribute', 
                             y = 'prop', 
                             fill = 'demographic_attribute')
  })
  
  dataset_tbl <- reactive({
    dataset() %>%
      select(names(vars)) |> 
      mutate(est = round(est, -3))
  })
  
  # Render the data table using `gt`
  output$data <- render_gt({
    dataset_tbl() |> 
      gt() %>%
      cols_label(!!!vars) |> # passing the named vector
      fmt_percent(columns = c('prop', 'prop_moe'), decimals = 0) %>%
      fmt_number(columns = 'est', decimals = 0)
  })
  
  dataset_tbl_download <- reactive({
    dataset_tbl() |> 
      setNames(vars)
  })
    
  output$downloadData <- downloadHandler(
      filename = function() {
        paste('data-', Sys.Date(), '.xlsx', sep='')
      },
      content = function(con) {
        write_xlsx(dataset_tbl_download(), con)
      }
    )
}
