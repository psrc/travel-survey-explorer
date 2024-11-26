# global.R
library(shiny)
library(dplyr)
# library(gt)
library(DT)
library(plotly)
library(psrcplot)
library(tidyr)
library(openxlsx)
library(htmlwidgets)
library(bslib)

# Load the data (assuming the same data path is used)
summary_tbl <- readRDS('data/hts_tbl_4_shiny.rds')
