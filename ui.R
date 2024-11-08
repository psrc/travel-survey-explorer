ui <- navbarPage(
  title = tags$div(
    tags$h1("Travel Survey Explorer", style = "font-size: 28px; color: #ffffff; margin: 0; font-family: 'Poppins', sans-serif;"),
    tags$h4("A Dashboard for Analyzing Travel Behavior", style = "font-size: 16px; color: #76787A; margin-top: 5px; font-family: 'Poppins', sans-serif;")
  ),
  windowTitle = "Travel Survey Explorer",
  
  # Custom CSS and Google Fonts for the navbar and general styling
  tags$head(
    tags$link(rel = "stylesheet", type = "text/css", href = "custom.css")
  ),
  
  tabPanel("Dashboard",
           sidebarLayout(
             sidebarPanel(
               selectInput('survey_year', 'Survey Year', choices = unique(summary_tbl$survey_year), selected = 2023),
               selectInput('travel', 'Topic of Interest', choices = unique(summary_tbl$travel_category), selected = "Trip Mode"), 
               selectInput('demographic', 'Traveler Demographics or Second Topic', choices = unique(summary_tbl$demographic_category), selected = "Household Income"),
               # Add custom hover effect for the button within the UI
               tags$head(
                 tags$style(HTML("
                  #reset_filters:hover {
                  background-color: #4D4D4D; /* Darker gray for hover */
                  cursor: pointer;
                  }
                      "))
               ),
               actionButton("reset_filters", "Reset Filters", class = "btn", 
                            style = "background-color: #6E6E6E; color: white; border: none; font-weight: bold;")
               
               ,
               
               # Download buttons
               downloadButton("downloadData", "Download Table as Excel"),
               downloadButton("downloadPlot", "Download Plot as HTML"),
               
               # External link in the sidebar
               tags$div(style = "margin-top: 15px;",
                        tags$a(href = "https://www.psrc.org/our-work/household-travel-survey-program", 
                               "Visit the PSRC Household Travel Survey Website", 
                               target = "_blank", style = "font-size: 16px; color: #F4835E; font-weight: bold;")),
               
               # Contact info box
               tags$div(
                 style = "margin-top: 20px; padding: 10px; background-color: #E6D1E6; color: #4a0048; border-radius: 5px; text-align: center;",
                 tags$p("Contact Information:"),
                 tags$a(href = "mailto:schildress@psrc.org", 
                        "Suzanne Childress", 
                        style = "color: #4a0048; font-weight: bold;")
               )
             ),
             mainPanel(
               plotlyOutput('plot'),  # Interactive Plot
               gt_output('data')  # Update this to gt_output for the gt table
             )
           )
  ),
  
  # New FAQ tab
  tabPanel("FAQ",
           fluidPage(
             h3("Frequently Asked Questions"),
             p("Here you can find answers to commonly asked questions about the Travel Survey Explorer."),
             
             # Example FAQs
             tags$ul(
               tags$li(
                 tags$b("What is the purpose of the Travel Survey Explorer?"),
                 tags$p("The Travel Survey Explorer is designed to help analyze travel behavior data from Puget Sound Region Residents collected in the regional travel surveys.")
               ),
               tags$li(
                 tags$b("Where can I download the full Household Travel Survey dataset, not just summary tables?"),
                 tags$p(
                   "The full set of household travel survey responses are available on the ", 
                   tags$a(href = "https://household-travel-survey-psregcncl.hub.arcgis.com/", 
                          "PSRC data portal", 
                          target = "_blank"), "."
                 )
               ),
               tags$li(
                 tags$b("Where can I learn more about the Puget Sound Regional Council Travel Survey Program?"),
                 tags$p(
                   "You can learn more at the ", 
                   tags$a(href = "https://www.psrc.org/our-work/household-travel-survey-program", 
                          "PSRC Household Travel Survey Program page", 
                          target = "_blank"), "."
                 )
               ),
               tags$li(
                 tags$b("Why are some variables such as disability status or sexuality not available in all years?"),
                 tags$p("Questions have been added to the survey over time to accommodate communities and topics of interest to planning. In the case of disability status and sexuality, these questions were added in 2023.")
               )
             )
           )
  )
)



