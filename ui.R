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
                   heading_font = "Poppins",
                   bg = "white",
                   fg = "black",
                   primary = "#91268F"
                   ),
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
                                            'Topic of Interest',
                                            choices = unique(summary_tbl$travel_category), 
                                            selected = "Trip Mode"), 
                                selectInput('demographic', 
                                            'Traveler Demographics or Second Topic',
                                            choices = unique(summary_tbl$demographic_category), 
                                            selected = "Household Income"),
                                
                                # card for variable definitions & download buttons
                                accordion(
                                  open = FALSE,
                                  accordion_panel(
                                    "Defintions",
                                    icon = bsicons::bs_icon("book"),
                                    uiOutput('var_def_ui'),
                                  ),
                                  accordion_panel(
                                    "Download",
                                    icon = bsicons::bs_icon('download'),
                                    downloadButton("downloadData", "Download Table as Excel"),
                                    downloadButton("downloadPlot", "Download Plot as HTML")
                                  )
                                ),
                                
                                
                                
              ),
              column(width = 12,
                     card(withSpinner(plotlyOutput('plot'), 
                                      type = 4, 
                                      color = sample(psrc_colors$psrc_light, 1))),
                     withSpinner(DTOutput('data'), 
                                 type = 4, 
                                 color = sample(psrc_colors$psrc_light, 1))
              )
            )
  ),
  
  faq_ui("faq"),
  nav_item(link_psrc)
)



