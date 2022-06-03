library(data.table)
library(dplyr)
library(readr)

setwd("..")
getwd() # should contain the folder "data-raw/"

file_paths <- paste0("data-raw/globalrt ", c("DE", "AT", "CH"), "/")
save_path_default <- "data-processed/globalrt_"

files_raw <- list.files(file_paths[1], full.names = F)

for (file in files_raw[40:267]) {
  cat(substr(file, 1, 10), "... \n")
  
  if (exists("data_proc")) rm(data_proc)
  
  for(file_path in file_paths){
    country <- substr(file_path, 19, 20)
    
    if (file %in% list.files(file_path, full.names = F)){
      print(country)
      
      data_raw <- setDT(read.csv(paste0(file_path, file)))
      data <- data_raw %>%
        dplyr::select(last_updated, days_infectious, Date, R, ci_95_l, ci_95_u) %>%
        rename(data_version = last_updated, target = days_infectious, date = Date) %>%
        #mutate(target = paste(target, "day R")) %>%
        melt(measure.vars = c("R", "ci_95_l", "ci_95_u")) %>%
        mutate(type = plyr::mapvalues(variable,
                                      c("R", "ci_95_l", "ci_95_u"),
                                      c("point", "quantile", "quantile")),
               quantile =  plyr::mapvalues(variable,
                                           c("R", "ci_95_l", "ci_95_u"),
                                           c(NA,   0.025,     0.975)),
               location = country) %>%
        dplyr::select(-variable) %>%
        setcolorder(c("data_version", "target", "date", "location", "type", "quantile", "value"))
      data <- data[order(data$target, data$date, data$type, data$quantile),]
      
      if (!exists("data_proc")){
        data_proc <- data
      } else
        data_proc <- rbind(data_proc, data)
    }
  }
  
  for (t in 5:10){
    save_path <- paste0(save_path_default, t, "d/")
    data_proc_t <- data_proc[data_proc$target == t,] %>%
      mutate(target = paste(t, "day R"))
    write_csv(data_proc_t, paste0(save_path, substr(file, 1, 10), "-globalrt_", t, "d.csv"))
  }
}
