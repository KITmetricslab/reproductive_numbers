library(dplyr)
library(tidyr)
library(readr)
library(lubridate)

setwd("..")
getwd()

data_dir <- "data-raw/Ilmenau "
countries <- c("AUT", "CHE", "DEU")

files <- list.files(paste0(data_dir, "DEU"), pattern = ("*.csv"))

for(file in files[207:385]){
  rm(data_DEU, data_AUT, data_CHE, data)
  for (country in countries){
    f <- gsub("deu", tolower(country), file)
    try(assign(paste0("data_", country),
               read_csv(paste0(data_dir, country, "/", f)) %>%
                 select(date, repronum, ci.lower, ci.upper) %>%
                 mutate(data_version=substr(f, 1, 10),
                        target="7 day",
                        location=ifelse(country=="DEU", "DE",
                                        ifelse(country=="AUT", "AT", "CH"))) %>%
                 pivot_longer(cols=c("repronum", "ci.lower", "ci.upper"), names_to = "type")))
  }
  data <- rbind(data_DEU, if(exists("data_AUT")) data_AUT, if(exists("data_CHE")) data_CHE) %>%
    na.omit() %>%
    mutate(quantile = ifelse(type == "ci.lower", 0.025,
                             ifelse(type =="ci.upper", 0.975, NA)),
           type = ifelse(type == "repronum", "point", "quantile"),
           label = ifelse(as_date(data_version) - as_date(date) <= 10, "estimate based on partial data", "estimate")) %>%
    select(data_version, target, date, location, label, type, quantile, value)
  write_csv(data, paste0("data-processed/ilmenau/", substr(file, 1, 10), "-ilmenau.csv"))
}
