library(shiny)
library(dplyr)
library(DT)
library(plotly)
library(psrcplot)
library(tidyr)
library(openxlsx)
library(htmlwidgets)
library(bslib)
library(shinycssloaders)

# Load the data (assuming the same data path is used)
summary_tbl <- readRDS('data/hts_tbl_4_shiny.rds')
var_def_tbl <- readRDS('data/shinyapp_var_def.rds')

# run all files in the modules sub-directory
module_files <- list.files('modules', full.names = TRUE)
sapply(module_files, source)
