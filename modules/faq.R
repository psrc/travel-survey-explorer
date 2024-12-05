# Display FAQ nav page

faq_ui <- function(id) {
  ns <- NS(id)
  
  nav_panel("FAQ",
            fluidPage(
              h2("Frequently Asked Questions"),
              p("Here you can find answers to commonly asked questions about the Travel Survey Explorer."),
              
              div(class = "faq", style = "padding: 2rem 25%;",
                  tags$ul(
                    tags$li(
                      p("What is the purpose of the Travel Survey Explorer?"),
                      p("The Travel Survey Explorer is designed to help analyze travel behavior data from Puget Sound Region Residents collected in the regional travel surveys.")
                    ),
                    tags$li(
                      p("Where can I download the full Household Travel Survey dataset, not just summary tables?"),
                      p(
                        "The full set of household travel survey responses are available on the ",
                        tags$a(href = "https://household-travel-survey-psregcncl.hub.arcgis.com/",
                               "PSRC data portal",
                               target = "_blank"), "."
                      )
                    ),
                    tags$li(
                      p("Where can I learn more about the Puget Sound Regional Council Travel Survey Program?"),
                      p(
                        "You can learn more at the ",
                        tags$a(href = "https://www.psrc.org/our-work/household-travel-survey-program",
                               "PSRC Household Travel Survey Program page",
                               target = "_blank"), "."
                      )
                    ),
                    tags$li(
                      p("Why are some variables such as disability status or sexuality not available in all years?"),
                      p("Questions have been added to the survey over time to accommodate communities and topics of interest to planning. In the case of disability status and sexuality, these questions were added in 2023.")
                    )
                  )
              )# end div
            ) 
  )
  
  
  
}

faq_server <- function(id) {
  
  moduleServer(id, function(input, output, session) { 
    ns <- session$ns
    
    
  }) # end moduleServer
  
}
