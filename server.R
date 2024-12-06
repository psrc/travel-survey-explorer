server <- function(input, output, session) {
  
  output$var_def_ui <- renderUI({
    # display variable definitions
    
    t <- var_def_tbl |> 
      filter(variables_union == input$travel) |> 
      pull(definition)
    
    d <- var_def_tbl |> 
      filter(variables_union == input$demographic)|> 
      pull(definition)
    
    card(
      full_screen = TRUE,
      div(class = "definitions",
        div(p(input$travel), p(t))
      ),
      
      div(class = "definitions",
        div(p(input$demographic), p(d))
      ) # end div
    ) # end card
    
    
  })
  
  # Reactive dataset
  dataset <- reactive({
    req(input$travel, input$demographic, input$survey_year)  # Ensure inputs are available
    
    # Filter the dataset based on user input
    summary_tbl %>%
      filter(travel_category == input$travel, 
             demographic_category == input$demographic, 
             survey_year == input$survey_year)
  })
  
  # Reactive plot
  plot <- reactive({
    dataset()
    plot_title <- paste(input$travel, "by", input$demographic, "for", input$survey_year)
    interactive_column_chart(dataset(), x = 'travel_attribute', 
                             y = 'prop', fill = 'demographic_attribute')%>%
      layout(
        title = list(
          text = plot_title,
          font = list(family = "Poppins", size = 20),  # Set font family and size
          x = 0.5,  # Center the title
          xanchor = "center",
          yanchor = "top"
        ),
        margin = list(t = 60)  # Increase top margin to avoid cutoff
      )
    
  })
  
  # Render the filtered data as a gt table
  output$data <- renderDT({
    new_colnames <- c('Topic of Interest', 'Traveler Characteristic', 'Share', 'Total', 'Sample Size')
    
    dataset() |> 
      select('travel_attribute', 'demographic_attribute', 'prop', 'est', 'count') |> 
      datatable(rownames = FALSE,
                colnames = new_colnames,
                options = list(pageLength = 8,
                               lengthMenu = c(8, 10, 15, 20),
                               dom = 'ltip' # default is 'lftipr'
                )
      ) |> 
      formatPercentage(columns = 'prop', digits = 0) |> 
      formatRound(columns = c('est', 'count'), digits = 0)
    
  })
  
  # Render the plot
  output$plot <- renderPlotly({
    plot()
  })
  
  # Download ----
  ## Download the filtered data as an Excel file ----
  output$downloadData <- downloadHandler(
    filename = function() {
      # Use user selections in the filename
      topic_of_interest <- gsub(" ", "_", input$travel)  # Replace spaces with underscores for filename
      traveler_characteristic <- gsub(" ", "_", input$demographic)
      survey_year <- input$survey_year
      
      paste("Travel_Survey_Data_", topic_of_interest, "_", traveler_characteristic, "_", survey_year, "_", Sys.Date(), ".xlsx", sep = "")
    },
    content = function(file) {
      req(dataset())  # Ensure dataset is available
      if (nrow(dataset()) == 0) {
        stop("No data available for download.")  # Add error handling if dataset is empty
      }
      write_xlsx(dataset(), path = file)  # Write the dataset to an Excel file
    }
  )
  
  ## Download the plot as an HTML file ----
  output$downloadPlot <- downloadHandler(
    filename = function() {
      # Use user selections in the filename
      topic_of_interest <- gsub(" ", "_", input$travel)  # Replace spaces with underscores for filename
      traveler_characteristic <- gsub(" ", "_", input$demographic)
      survey_year <- input$survey_year
      
      paste("Travel_Survey_Plot_", topic_of_interest, "_", traveler_characteristic, "_", survey_year, "_", Sys.Date(), ".html", sep = "")
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
