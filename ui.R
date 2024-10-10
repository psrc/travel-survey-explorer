library(shiny)
library(gt)
library(writexl)
library(htmlwidgets)
library(plotly)  # Required for rendering plots

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
      
      .btn-primary {
        background-color: #FFA500; /* Set the Update button to orange */
        color: #ffffff; /* White text */
        border: none; /* Remove border */
        font-weight: 600;
      }

      #goButton {
        margin-bottom: 15px; /* Add some space below the Update button */
      }

      #downloadData, #downloadPlot {
        margin-right: 10px; /* Add spacing between the download buttons */
        margin-bottom: 15px;
      }

      .navbar-default {
        background-color: #000000; /* Set navbar background to black */
        border-color: #000000; /* Remove border */
      }
      
      .navbar-default .navbar-brand, 
      .navbar-default .navbar-brand:hover {
        color: #ffffff; /* White color for the brand title */
      }
      
      .navbar-default .navbar-nav > li > a {
        color: #dddddd; /* Light gray color for nav links */
        font-size: 16px;
      }
      
      .navbar-default .navbar-nav > li > a:hover {
        color: #ffffff; /* Change to white on hover */
        background-color: transparent; /* Remove hover background */
      }
      
      .navbar-default .navbar-nav > li.active > a {
        background-color: #222222; /* Slightly different color for active links */
        color: #ffffff; /* White text for active link */
      }
    "))
  ),
  
  tabPanel("Dashboard",
           sidebarLayout(
             sidebarPanel(
               selectInput('travel', 'Topic', unique(summary_tbl$`Travel Category`)), 
               selectInput('demographic', 'Traveler Characteristics', unique(summary_tbl$`Demographic Category`)),
               selectInput('survey_year', 'Year', unique(summary_tbl$survey_year)),
               
               # Download buttons with styling
               downloadButton("downloadData", "Download Table as Excel"),
               downloadButton("downloadPlot", "Download Plot as HTML")
             ),
             mainPanel(
               plotlyOutput('plot'),
               gt_output('data')
             )
           )
  ),
  
  # New tab for the PSRC Household Travel Survey
  tabPanel("PSRC Household Travel Survey",
           tags$div(style = "text-align: center; margin-top: 20px;",
                    tags$a(href = "https://www.psrc.org/our-work/household-travel-survey-program", 
                           "Visit the PSRC Household Travel Survey Website", 
                           target = "_blank", style = "font-size: 20px; color: #FFA500; font-weight: bold;"))
  )
)

