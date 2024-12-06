library(data.table)
# library(travelSurveyTools)
# library(psrcelmer)
library(psrcplot)
library(tidyverse)
# library(table1)
# library(psrc.travelsurvey)


# open rds file to see format
# hts_rds <- readRDS('T:/2024December/christy/hts_tbl_4_shiny.rds')
hts_rds <- readRDS('data/hts_tbl_4_shiny.rds')

# view fields of interest
unique(hts_rds$demographic_category)
unique(hts_rds$travel_category)

# create data set with 2 columns: variable and defintion
# create data frame with variable
hts_data_demo <- unique(hts_rds$demographic_category)
hts_data_travel <- unique(hts_rds$travel_category)

variables_union <- union_all(hts_data_demo, hts_data_travel) |> unique()

var <- as.data.frame(variables_union)

# create definitions for each of the variables
shiny_variables <- var %>% 
  mutate(definition= case_when(var=="Regionwide" ~"A variable that includes all respondents from the four-county Central Puget Sound region.",
                               var=="Home County" ~"A variable that indicates the county in which a respondent's primary home is located, based on their reported home latitude and longitude.",
                               var=="Home in Seattle" ~"A variable that indicates if a respondent's primary home is in Seattle, based on their reported home latitude and longitude.",
                               var=="Household Income" ~"A variable that categorizes respondents based on their selected household total annual income range (from all sources, before taxes/deductions from pay). Because of sample size concerns, these choices are aggregated to three simplified income range categories.",
                               var=="Person Race" ~"A variable that categorizes respondents based on their selected race and ethnicity. Because race and ethnicity were asked in two separate questions and because of sample size concerns, these choices are aggregated to seven simplified race/ethnicity categories.",
                               var=="Household Size" ~"A variable that categorizes respondents based on their selected age range. Because of sample size concerns, these choices are aggregated to five simplified categories.",
                               var=="Age Group" ~"A variable that categorizes respondents based on their selected age range. Because of sample size concerns, these choices are aggregated to five simplified categories.",
                               var=="Worker Status" ~"A variable that categorizes respondents based on their selected employment status. Because of sample size concerns, these are aggregated to two simplified categories. 'Worker' includes respondents who are employed full-time, part-time, employed but not currently working, and self-employed.",
                               var=="Disability Status" ~"A variable that indidicates if a respondent identifies as having a disability or illness that affects their ability to travel",
                               var=="Presence of vehicle" ~"A variable that indidicates if there are registered motor vehicles in a respondent's household that are available for use. Vehicles that are away at college or broken down are not included.",
                               var=="Gender Identity" ~"A variable that categorizes respondents based on their selected gender identity. Because of sample size concerns, these choices are aggregated to three simplified categories.",
                               var=="Sexuality" ~"A variable that categorizes respondents based on their selected sexuality. Because of sample size concerns, these choices are aggregated to three simplified categories.",
                               var=="Home Rent or Own" ~"A variable that categorizes respondents based on their selected housing tenure. Because of sample size concerns, these choices are aggregated to three simplified categories.",
                               var=="Frequency of transit use" ~"A variable that categorizes how often respondents report having used transit (e.g., bus, rail, ferry) in the past 30 days. Because of sample size concerns, these choices are aggregated to four simplified categories.",
                               var=="Frequency of walking" ~"A variable that categorizes how often respondents report having walked outside for 15 or more minutes in the past 30 days. Because of sample size concerns, these are aggregated to four simplified categories.",
                               var=="Frequency of biking" ~"A variable that categorizes how often respondents report having ridden a bike outside for 15 or more minutes in the past 30 days. Because of sample size concerns, these are aggregated to four simplified categories.",
                               var=="Trip Purpose" ~"A variable that categorizes respondents based on the purpose of their trip. Respondents are provided with a range of over 50 detailed options, but because of sample size concerns, these choices are aggregated to four simplified categories.",
                               var=="Work Offers Transit Pass" ~"A variable that indicates if a respondent's employer offers fully subsidized transit passes.",
                               var=="Trip Mode" ~"A variable that categorizes respondents based on their selected mode of travel. Respondents are provided with a range of 10 detailed options, but because of sample size concerns, these choices are aggregated to four simplified categories.",
                               var=="Telecommute Status" ~"A variable that categorizes respondents based on their selected work location(s). Because of sample size concerns, these choices are aggregated to three simplified categories."))


# view new data frame
shiny_variables 
class(shiny_variables)

# write rds
# write_rds(shiny_variables, "T:/2024December/Mary/shinyapp_var_def.rds")
write_rds(shiny_variables, "data/shinyapp_var_def.rds")
