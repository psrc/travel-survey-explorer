# global.R
library(shiny)
library(dplyr)
library(gt)
library(plotly)
library(psrcplot)
library(tidyr)
library(writexl)
library(htmlwidgets)

# Load the data (assuming the same data path is used)
summary_tbl <- readRDS('data/hts_tbl_4_shiny.rds')

