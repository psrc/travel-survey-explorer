library(shiny)
library(gt)
library(writexl)
library(htmlwidgets)
library(plotly)  # Required for rendering plots

# UI component
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

      /* Styling the download buttons */
      #downloadData, #downloadPlot {
        color: #000000 !important; /* Black font color */
        background-color: #ffffff !important; /* White background */
        font-weight: 600 !important; /* Bold text */
        border: 1px solid #FFA500 !important; /* Orange border */
        margin-right: 10px; /* Add spacing between the download buttons */
        transition: background-color 0.3s ease, color 0.3s ease;
      }
      
      /* Hover effect for download buttons */
      #downloadData:hover, #downloadPlot:hover {
        color: #ffffff !important; /* White text on hover */
        background-color: #4a0048 !important; /* Purple background on hover */
        border: 1px solid #4a0048 !important; /* Border color change on hover */
      }

      .navbar-default {
        background-color: #4a0048; 
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
        background-color: #E3C9E3; /* Slightly different color for active links */
        color: #ffffff; /* White text for active link */
      }
    "))
  ),
  
  tabPanel("Dashboard",
           sidebarLayout(
             sidebarPanel(
               # Set initial values for the dropdowns
               selectInput('travel', 'Topic of Interest', choices = unique(summary_tbl$`Travel Category`), selected = "Trip Mode"), 
               selectInput('demographic', 'Traveler Demographics', choices = unique(summary_tbl$`Demographic Category`), selected = "Household Income"),
               selectInput('survey_year', 'Survey Year', choices = unique(summary_tbl$survey_year), selected = 2023),
               
               # Wrap download buttons in divs with ids for custom styling
               div(id = "downloadDataContainer", 
                   downloadButton("downloadData", "Download Table as Excel")
               ),
               div(id = "downloadPlotContainer", 
                   downloadButton("downloadPlot", "Download Plot as HTML")
               )
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
