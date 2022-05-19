library(data.table)

setwd("..")
getwd() # should contain the folder "data-raw/Braunschweig"

file_path <- "data-raw/Braunschweig/"
save_path <- "data-processed/Braunschweig/"
files_raw <- list.files(file_path, full.names = F)

for (file in files_raw) {
  if (file %>% endsWith(".csv")){
    print(substr(file, 1, 23))
    data_raw <- setDT(read.csv(paste0(file_path, file)))
    data <- data_raw[, as.list(quantile(.SD, c(.025, .25, .5, .75, .975), na.rm = TRUE)), by = c("date")]
    data <- setDT(melt(data, id.vars = c("date")))
    data[, "data_version"] <- substr(file, 1, 10)
    data[, "target"] <- "10 day R"
    data[, "location"] <- "DE"
    data[, "type"] <- "quantile"
    data$type[data$variable == "50%"] <- "point"
    data[, "quantile"] <- NA
    data$quantile[data$variable == "2.5%"] <- 0.025
    data$quantile[data$variable == "25%"] <- 0.25
    data$quantile[data$variable == "75%"] <- 0.75
    data$quantile[data$variable == "97.5%"] <- 0.975
    data[, variable:=NULL]
    data %>% setcolorder(c("data_version", "target", "date", "location", "type", "quantile", "value"))
    data <- data[order(date, type, quantile)]
    write_csv(data, paste0(save_path, substr(file, 1, 23), ".csv"))
  }
}
