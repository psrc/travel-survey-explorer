link_psrc <- a(
  img(src="RegionalGem2016.png", width="30px"),
  href = "https://psrc.org",
  target = "_blank"
)

ui <- page_navbar(
  tags$head(
    tags$link(rel = "stylesheet", type = "text/css", href = "tse.css")
  ),
  theme = bs_theme(base_font = "Poppins",
                   heading_font = "Poppins"),
  bg = "#630460",
  title =  "PSRC Travel Survey Explorer (beta)",
  nav_spacer(),
  nav_panel("Dashboard",
            page_sidebar(
              
              sidebar = sidebar(width = "30%",
                                card(div(img(src="psrc-logo.png", width = "50%"), 
                                         style = "display: flex; align-items: center; justify-content: center;"),
                                     p("This is a dashboard for analyzing travel behavior in the Central Puget Sound region. Visit the",
                                       tags$a(href = "https://www.psrc.org/our-work/household-travel-survey-program", 
                                              "PSRC Household Travel Survey", 
                                              target = "_blank"), "for more information."),
                                     p("Questions? Contact:",tags$a(href = "mailto:schildress@psrc.org", 
                                                                    "Suzanne Childress", 
                                                                    style = "color: #4a0048;"))
                                ),
                                
                                selectInput('survey_year', 
                                            'Survey Year', 
                                            choices = unique(summary_tbl$survey_year), 
                                            selected = 2023),
                                selectInput('travel', 
                                            label = tooltip(
                                              trigger = list(
                                                'Topic of Interest',
                                                bsicons::bs_icon("info-circle")
                                              ),
                                              "Add variable definition"
                                            ),
                                            choices = unique(summary_tbl$travel_category), 
                                            selected = "Trip Mode"), 
                                selectInput('demographic', 
                                            label = tooltip(
                                              trigger = list(
                                                'Traveler Demographics or Second Topic',
                                                bsicons::bs_icon("info-circle")
                                              ),
                                              "Add variable definition"
                                            ),
                                            choices = unique(summary_tbl$demographic_category), 
                                            selected = "Household Income"),
                                
                                # Download buttons
                                downloadButton("downloadData", "Download Table as Excel"),
                                downloadButton("downloadPlot", "Download Plot as HTML"),
                                
              ),
              column(width = 12,
                     card(plotlyOutput('plot')),
                     DTOutput('data')
              )
            )
  ),
  
  faq_ui("faq"),
  nav_item(link_psrc)
)



