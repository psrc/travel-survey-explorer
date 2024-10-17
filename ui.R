ui <- navbarPage(
  title = tags$div(
    tags$h1("Travel Survey Explorer", style = "font-size: 28px; color: #ffffff; margin: 0; font-family: 'Poppins', sans-serif;"),
    tags$h4("A Dashboard for Analyzing Travel Behavior", style = "font-size: 16px; color: #76787A; margin-top: 5px; font-family: 'Poppins', sans-serif;")
  ),
  windowTitle = "Travel Survey Explorer",
  
  # Custom CSS and Google Fonts for the navbar and general styling
  # Link external CSS
  tags$head(
    tags$link(rel = "stylesheet", type = "text/css", href = "custom.css")
  ),
  
  tabPanel("",
           sidebarLayout(
             sidebarPanel(
               selectInput('survey_year', 'Survey Year', choices = unique(summary_tbl$survey_year), selected = 2023),
               selectInput('travel', 'Topic of Interest', choices = unique(summary_tbl$travel_category), selected = "Trip Mode"), 
               selectInput('demographic', 'Traveler Demographics', choices = unique(summary_tbl$demographic_category), selected = "Household Income"),
        
               
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
               plotlyOutput('plot'),
               gt_output('data')
             )
           )
  )
)
