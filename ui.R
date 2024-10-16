ui <- navbarPage(
  title = tags$div(
    tags$h1("Travel Survey Explorer", style = "font-size: 28px; color: #ffffff; margin: 0; font-family: 'Poppins', sans-serif;"),
    tags$h4("A Dashboard for Analyzing Travel Behavior", style = "font-size: 16px; color: #dddddd; margin-top: 5px; font-family: 'Poppins', sans-serif;")
  ),
  windowTitle = "Travel Survey Explorer",
  
  # Custom CSS and Google Fonts for the navbar and general styling
  tags$head(
    tags$link(href = "https://fonts.googleapis.com/css2?family=Poppins:wght@300;400;600&display=swap", rel = "stylesheet"),
    tags$style(HTML("
      body, .navbar, .form-control, .btn, .gt_table, .well {
        font-family: 'Poppins', sans-serif;
      }
      
      /* Styling for the contact info box */
      .contact-info-box {
        background-color: #4a0048; /* Purple background */
        color: white; /* White text */
        padding: 15px;
        margin-top: 15px;
        font-size: 14px;
        border-radius: 5px;
      }

      /* Styling the download buttons */
      #downloadData, #downloadPlot {
        color: #000000 !important;
        background-color: #ffffff !important;
        font-weight: 600 !important;
        border: 1px solid #FFA500 !important;
        margin-right: 10px;
        transition: background-color 0.3s ease, color 0.3s ease;
      }
      
      #downloadData:hover, #downloadPlot:hover {
        color: #ffffff !important;
        background-color: #4a0048 !important;
        border: 1px solid #4a0048 !important;
      }
      
      .navbar-default {
        background-color: #4a0048;
        border-color: #000000;
      }
      
      .navbar-default .navbar-brand,
      .navbar-default .navbar-brand:hover {
        color: #ffffff;
      }
      
      .navbar-default .navbar-nav > li > a {
        color: #dddddd;
        font-size: 16px;
      }
      
      .navbar-default .navbar-nav > li > a:hover {
        color: #ffffff;
        background-color: transparent;
      }
      
      .navbar-default .navbar-nav > li.active > a {
        background-color: #E3C9E3;
        color: #ffffff;
      }
    "))
  ),
  
  tabPanel("Dashboard",
           sidebarLayout(
             sidebarPanel(
               selectInput('travel', 'Topic of Interest', choices = unique(summary_tbl$travel_category), selected = "Trip Mode"), 
               selectInput('demographic', 'Traveler Demographics', choices = unique(summary_tbl$demographic_category), selected = "Household Income"),
               selectInput('survey_year', 'Survey Year', choices = unique(summary_tbl$survey_year), selected = 2023),
               
               # Download buttons
               downloadButton("downloadData", "Download Table as Excel"),
               downloadButton("downloadPlot", "Download Plot as HTML"),
               
               # External link in the sidebar
               tags$div(style = "margin-top: 15px;",
                        tags$a(href = "https://www.psrc.org/our-work/household-travel-survey-program", 
                               "Visit the PSRC Household Travel Survey Website", 
                               target = "_blank", style = "font-size: 16px; color: #FFA500; font-weight: bold;")),
               
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
