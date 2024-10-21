library(magrittr)
library(psrc.travelsurvey)
library(stringr)
library(data.table)

query_vars <- c("age",
                "employment",
                "dest_purpose",
                "disability_person",
                "gender",
                "hhincome_broad",
                "hh_race_category",
                "hhsize",
                "home_county", 
                "home_jurisdiction",
                "mode_characterization",
                "rent_own",
                "sexuality",
                "telecommute_freq",
                #"vehicle_count",
                "workplace"
                )

trip_topics <- data.frame(  
  report_var = c("mode_basic",
                 "dest_purpose_bin4"),
  label =      c("Trip Mode", 
                 "Trip Purpose")
) %>% setDT()

person_topics <- data.frame(  
  report_var = c("telecommute_trichotomy"),
  label =      c("Telecommute Status")
) %>% setDT()

geography <- data.frame(
  report_var = c("home_county", 
                 "home_in_seattle"),
  label =      c("Home County",
                 "Home in Seattle")
) %>% setDT()

demography      <- data.frame(  
  report_var = c("hhincome_bin3",
                 "hhsize_bin4",
                 "age_bin5",
                 "worker",
                 "disability_person",
                 "hh_race_category",
                 #"vehicle_yn",
                 "gender_bin3",
                 "sexuality_bin3",
                 "rent_own_bin2"),
  label  =     c("Household Income",
                 "Household Size",
                 "Age Group",
                 "Worker Status",
                 "Disability Status",
                 "Household Race", 
                 #"Presence of vehicle",
                 "Gender Identity",
                 "Sexuality",
                 "Home Rent or Own")
) %>% setDT()

trip_combos <- expand.grid(c(geography$report_var, demography$report_var), trip_topics$report_var) %>%
  transpose() %>% lapply(c)

person_combos <- expand.grid(c(geography$report_var, demography$report_var), person_topics$report_var) %>%
  transpose() %>% lapply(c)

# Helper functions --------------------

explorer_counts <- function(grpvars, analysis_unit){
  pfx <- c("demographic_", "travel_")
  sfx <- c("category", "attribute")
  hts_data2 <- copy(hts_data)
  if(any("disability_person" %in% grpvars)){  # -- disability is new in 2023
    hts_data2 %<>% lapply(FUN=function(x) dplyr::filter(x, survey_year==2023))                 
  }
  rs <- psrc_hts_stat(hts_data2, analysis_unit=analysis_unit, group_vars=grpvars, incl_na=FALSE) %>% setDT()
  rs %<>% setnames(grpvars, paste0(pfx, sfx[[2]])) %>%
    .[, `:=`(demographic_category = rbind(..demography, ..geography)[report_var==(grpvars[[1]])]$label, 
             travel_category = rbind(..trip_topics, ..person_topics)[report_var==(grpvars[[2]])]$label)] %>%
    setcolorder(c("survey_year", paste0(pfx[[1]], sfx), paste0(pfx[[2]], sfx)))
}

# Retrieve HTS data & add variables ---
hts_data <- get_psrc_hts(survey_vars=query_vars)
hts_data %<>% 
  hts_bin_dest_purpose() %>% 
  hts_bin_income() %>% 
  hts_bin_hhsize() %>% 
  #  hts_bin_vehicle_count() %>% 
  hts_bin_age() %>% 
  hts_bin_worker() %>% 
  hts_bin_gender() %>% 
  hts_bin_sexuality() %>%
  hts_bin_rent_own() %>%
  hts_bin_mode() %>%
  hts_bin_telecommute_trichotomy()

hts_data$hh %<>%
  .[, home_in_seattle:=factor(fcase(home_jurisdiction=="Seattle", "Seattle",
                                    !is.na(home_jurisdiction), NA_character_),
                              levels=c("Seattle"))]

# Generate summaries ------------------
trip_summary <- lapply(trip_combos, explorer_counts, analysis_unit="trip")
person_summary <- lapply(person_combos, explorer_counts, analysis_unit="person")
summary_labeled <- rbind(trip_summary, person_summary)

saveRDS(summary_labeled, 'hts_tbl_4_shiny.rds')
