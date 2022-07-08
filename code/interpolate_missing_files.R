library(dplyr)
library(lubridate)
library(readr)
library(data.table)
library(hablar)

setwd("..")
getwd()

methods <- c("Braunschweig", "epiforecasts", "ETHZ_sliding_window",
             "globalrt_7d", "ilmenau", "RKI_7day", "rtlive", "SDSC")

pub_delays <- read.csv("../Rt_estimate_reconstruction/otherFiles/pub_delays.csv", row.names = 1)

for (method in methods){
  print(method)
  
  path_estimates <- paste0("data-processed/", method)
  path_save <- paste0("data-processed/", method, "/interpolated")
  ifelse(!dir.exists(path_save), dir.create(path_save), FALSE)
  
  # determine existing dates
  dates <- list.files(path_estimates, pattern = "\\d{4}-\\d{2}-\\d{2}") %>%
    substr(1,10) %>%
    as_date

  # determine dates which have to be interpolated
  target_dates <- seq(min(dates), max(dates), by = "day")
  missing <- rep(NA, length(target_dates))
  names(missing) <- target_dates
  missing[as.character(dates)] <- F
  missing[is.na(missing)] <- T
  missing_dates <- as_date(names(missing[missing==T]))
  existing_dates <- as_date(names(missing[missing==F]))
  
  for (date_ in missing_dates){
    
    # max_() and min_() from hablar packages return NA if passed vector is empty
    prev_date <- max_(existing_dates[existing_dates < date_])
    next_date <- min_(existing_dates[existing_dates > date_])
    
    if (!is.na(prev_date) & !is.na(next_date)){
      prev_est <- read_csv(paste0(path_estimates, "/", prev_date, "-", method, ".csv")) %>%
        dplyr::select(!data_version)
      next_est <- read_csv(paste0(path_estimates, "/", next_date, "-", method, ".csv")) %>%
        dplyr::select(!data_version)
      
      interpolated_est <- rbindlist(list(prev_est, next_est))[,lapply(.SD, mean),
                                                              by=list(target, date, location, type, quantile)]
    } else if (!is.na(prev_date)){
      interpolated_est <- read_csv(paste0(path_estimates, "/", prev_date, "-", method, ".csv")) %>%
        dplyr::select(!data_version)
    } else if (!is.na(next_date)){
      interpolated_est <- read_csv(paste0(path_estimates, "/", next_date, "-", method, ".csv")) %>%
        dplyr::select(!data_version)
    }
    
    interpolated_est <- interpolated_est %>%
      dplyr::filter(ifelse(location == "DE", date <= date_ - pub_delays[method, "DE"],
                           ifelse(location == "AT", date <= date_ - pub_delays[method, "AT"],
                                  date <= date_ - pub_delays[method, "CH"]))) %>%
      mutate(data_version = date_) %>%
      dplyr::select(data_version, target, date, location, type, quantile, value)
    
    date_char <- as.character.Date(as_date(date_), format="%Y-%m-%d")
    write_csv(interpolated_est, paste0(path_save, "/", date_char, "-", method, ".csv"))
  }
}







