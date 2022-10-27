library(data.table)
library(dplyr)
library(readr)
library(lubridate)

setwd("..")
getwd() # should contain the folder "data-raw/ETHZ DEU"

file_paths <- c("data-raw/ETHZ DEU/", "data-raw/ETHZ CHE/", "data-raw/ETHZ AUT/")
save_path <- "data-processed/ETHZ_sliding_window/"
files_raw <- list.files(file_paths[1], full.names = F, pattern = "*_raw.csv")

for (file in files_raw) {
  if (as_date(substr(file, 1, 10)) > as_date("2021-08-19")){
  rm(data_merged)
  
  for(file_path in file_paths){
    country <- tolower(substr(file_path, 15, 17))
    file_country <- paste0(file_path, substr(file, 1, 16), country, "_raw.csv")
    
    if (file.exists(file_country)) {
      data_raw <- setDT(read.csv(file_country)) %>%
        dplyr::filter(region == toupper(!!country) &
                        data_type == "Confirmed cases" &
                        estimate_type == "Cori_slidingWindow") %>%
        dplyr::select(date, median_R_mean, median_R_highHPD, median_R_lowHPD)
      
      data <- setDT(melt(data_raw, id.vars = c("date")))
      
      data[, "data_version"] <- substr(file, 1, 10)
      data[, "target"] <- "3 day R"
      data[, "location"] <- ifelse(country == "deu", "DE",
                                   ifelse(country == "che", "CH", "AT"))
      data[, "label"] <- "estimate"
      
      data[, "type"] <- "quantile"
      data$type[data$variable == "median_R_mean"] <- "point"
      
      data[, "quantile"] <- NA
      data$quantile[data$variable == "median_R_lowHPD"] <- 0.025
      data$quantile[data$variable == "median_R_highHPD"] <- 0.975
      
      data[, variable:=NULL]
      
      data %>% setcolorder(c("data_version", "target", "date", "location", "label", "type", "quantile", "value"))
      data <- data[order(date, type, quantile)]
      
      if(exists("data_merged")) {
        data_merged <- rbind(data_merged, data)
      } else
        data_merged <- data
    }
  }
  
  if (max(table(data_merged$date)) > 9) {
    print("WARNING: to many data points for one date")
  }
  
  file_output <- paste0(save_path, substr(file, 1, 10), "-ETHZ_sliding_window.csv")
  print(file_output)
  write_csv(data_merged, file_output)
  }
}


