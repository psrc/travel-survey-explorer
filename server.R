server <- function(input, output, session) {
  # Reactive expressions for available choices based on any single or two combinations of inputs
  
  observe({
    # Get available travel categories based on demographic and survey year
    if (!is.null(input$demographic) & !is.null(input$survey_year)) {
      available_travel_categories <- summary_tbl %>%
        filter(demographic_category == input$demographic & survey_year == input$survey_year) %>%
        distinct(travel_category) %>%
        pull(travel_category)
    } else if (!is.null(input$demographic)) {
      available_travel_categories <- summary_tbl %>%
        filter(demographic_category == input$demographic) %>%
        distinct(travel_category) %>%
        pull(travel_category)
    } else if (!is.null(input$survey_year)) {
      available_travel_categories <- summary_tbl %>%
        filter(survey_year == input$survey_year) %>%
        distinct(travel_category) %>%
        pull(travel_category)
    } else {
      available_travel_categories <- unique(summary_tbl$travel_category)
    }
    
    updateSelectInput(session, 'travel', choices = available_travel_categories, selected = input$travel)
  })
  
  observe({
    # Get available demographic categories based on travel and survey year
    if (!is.null(input$travel) & !is.null(input$survey_year)) {
      available_demographics <- summary_tbl %>%
        filter(travel_category == input$travel & survey_year == input$survey_year) %>%
        distinct(demographic_category) %>%
        pull(demographic_category)
    } else if (!is.null(input$travel)) {
      available_demographics <- summary_tbl %>%
        filter(travel_category == input$travel) %>%
        distinct(demographic_category) %>%
        pull(demographic_category)
    } else if (!is.null(input$survey_year)) {
      available_demographics <- summary_tbl %>%
        filter(survey_year == input$survey_year) %>%
        distinct(demographic_category) %>%
        pull(demographic_category)
    } else {
      available_demographics <- unique(summary_tbl$demographic_category)
    }
    
    updateSelectInput(session, 'demographic', choices = available_demographics, selected = input$demographic)
  })
  
  observe({
    # Get available survey years based on travel and demographic
    if (!is.null(input$travel) & !is.null(input$demographic)) {
      available_years <- summary_tbl %>%
        filter(travel_category == input$travel & demographic_category == input$demographic) %>%
        distinct(survey_year) %>%
        pull(survey_year)
    } else if (!is.null(input$travel)) {
      available_years <- summary_tbl %>%
        filter(travel_category == input$travel) %>%
        distinct(survey_year) %>%
        pull(survey_year)
    } else if (!is.null(input$demographic)) {
      available_years <- summary_tbl %>%
        filter(demographic_category == input$demographic) %>%
        distinct(survey_year) %>%
        pull(survey_year)
    } else {
      available_years <- unique(summary_tbl$survey_year)
    }
    
    updateSelectInput(session, 'survey_year', choices = available_years, selected = input$survey_year)
  })
  
  # Reactive dataset based on user input
  dataset <- reactive({
    req(input$travel, input$demographic, input$survey_year)
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
                           y = 'prop', fill = 'demographic_attribute', moe='prop_moe')
    # %>%
      # layout(
      #   title = list(
      #     text = plot_title,
      #     font = list(family = "Poppins", size = 20),  # Set font family and size
      #     x = 0.5,  # Center the title
      #     xanchor = "center",
      #     yanchor = "top"
      #   ),
      #   margin = list(t = 60)  # Increase top margin to avoid cutoff
      # )
    
  })
  
  # Render the filtered data as a gt table
  output$data <- render_gt({
    dataset() %>%
      select('travel_attribute', 'demographic_attribute', 'prop', 'prop_moe', 'est', 'count') %>%
      rename('Topic of Interest' = 'travel_attribute') %>%
      rename('Traveler Characteristic' = 'demographic_attribute') %>%
      rename('Share' = 'prop') %>%
      rename('Share Margin of Error' = 'prop_moe') %>%
      rename('Sample Size' = 'count') %>%
      rename('Total' = 'est') %>%
      mutate('Total' = round(Total, -3)) %>%
      gt() %>%
      fmt_percent(columns = c('Share', 'Share Margin of Error'), scale_values = TRUE)
  })
  
  output$plot <- renderPlotly({
    plot()
  })
  
  # Download functionality
  output$downloadData <- downloadHandler(
    filename = function() {
      paste("summary_table_", input$travel, "_", input$demographic, "_", input$survey_year, ".xlsx", sep = "")
    },
    content = function(file) {
      write.xlsx(dataset(), file)
    }
  )
  
  output$downloadPlot <- downloadHandler(
    filename = function() {
      paste("plot_", input$travel, "_", input$demographic, "_", input$survey_year, ".html", sep = "")
    },
    content = function(file) {
      htmlwidgets::saveWidget(as_widget(plot()), file)
    }
  )
  
}
      
      

