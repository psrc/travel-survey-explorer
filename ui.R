ui <- page_navbar(
  theme = bs_theme(base_font = "Poppins",
                   heading_font = "Sintony"),
  bg = "#630460",
  title = "PSRC Travel Survey Explorer (beta)",
  nav_spacer(),
  # title = tags$div(
  #   tags$h1("BETA Travel Survey Explorer", style = "font-size: 28px; color: #ffffff; margin: 0; font-family: 'Poppins', sans-serif;"),
  #   tags$h2("A Dashboard for Analyzing Travel Behavior", style = "font-size: 16px; color: #76787A; margin-top: 5px; font-family: 'Poppins', sans-serif;")
  # ),
  # windowTitle = "Travel Survey Explorer",
  
  # Custom CSS and Google Fonts for the navbar and general styling
  # tags$head(
  #   tags$link(rel = "stylesheet", type = "text/css", href = "custom.css")
  # ),
  
  nav_panel("Dashboard",
            page_sidebar(
              
              sidebar = sidebar(width = "30%",
                                card(p("This is a dashboard for analyzing travel behavior. Visit the",
                                       tags$a(href = "https://www.psrc.org/our-work/household-travel-survey-program", 
                                              "PSRC Household Travel Survey", 
                                              target = "_blank"), "for more information."),
                                     p("Contact:",tags$a(href = "mailto:schildress@psrc.org", 
                                                         "Suzanne Childress", 
                                                         style = "color: #4a0048;"))
                                ),
                                
                                selectInput('survey_year', 'Survey Year', choices = unique(summary_tbl$survey_year), selected = 2023),
                                selectInput('travel', 'Topic of Interest', choices = unique(summary_tbl$travel_category), selected = "Trip Mode"), 
                                selectInput('demographic', 'Traveler Demographics or Second Topic', choices = unique(summary_tbl$demographic_category), selected = "Household Income"),
                                
                                # Download buttons
                                downloadButton("downloadData", "Download Table as Excel"),
                                downloadButton("downloadPlot", "Download Plot as HTML"),
                                
              ),
              column(width = 12,
                     card(plotlyOutput('plot')),
                     card(DTOutput('data'))
              )
            )
  ),
  
  # New FAQ tab
  nav_panel("FAQ",
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



