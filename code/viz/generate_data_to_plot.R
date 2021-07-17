# Pulling data relevant for plotting together in one csv file

# setwd("/home/johannes/Documents/Projects/reproductive_numbers/code/viz")

# Path where processed outputs are stored:
path_data_processed <- "../../data-processed"
# names of models
models <- list.dirs(path_data_processed, full.names = FALSE, recursive = FALSE)

# initialize object where results will be stored
data_to_plot <- NULL

# run through models and put together data set
for(model in models[-1]){
  cat("Starting", model, "\n")
  
  # identify files to be processed
  files <- list.files(paste0(path_data_processed, "/", model))
  files <- files[grepl(".csv", files)]
  
  # runthrough files
  for(file in files){
    # cat("   ", file, "\n")
    # wrapped in try() as some files still contain errors
    try({
      # read file in
      dat_temp <- read.csv(paste0(path_data_processed, "/", model, "/", file), 
                           colClasses = c(date = "Date", data_version = "Date"))
      # add column with model name
      dat_temp$model <- model
      # remove row numbers if present
      dat_temp$X <- NULL
      # correct a typo present in some files (should be fixed soon)
      colnames(dat_temp)[colnames(dat_temp) == "quantil"] <- "quantile"
      # some models have commas instead of points as decimal delimiter (should be fixed soon)
      if(!is.numeric(dat_temp$value)){
        print(file)
        dat_temp$value <- as.numeric(gsub(",", ".", dat_temp$value))
      }
      # point forecasts
      to_add <- subset(dat_temp, type == "point")
      to_add$target <- to_add$type <- NULL
      
      # add upper ends of CIs:
      if(any(dat_temp$quantile == 0.025, na.rm = TRUE)){
        subset_lower <- subset(dat_temp, quantile == 0.025)
        subset_lower <- subset_lower[, c("date", "value")]
        colnames(subset_lower) <- c("date", "value_0.025")
        to_add <- merge(to_add, subset_lower, by = "date", all.x = TRUE)
      }else{
        to_add$value_0.025 <- NA
      }
      
      # add upper ends of CIs:
      if(any(dat_temp$quantile == 0.975, na.rm = TRUE)){
        subset_upper <- subset(dat_temp, quantile == 0.975)
        subset_upper <- subset_upper[, c("date", "value")]
        colnames(subset_upper) <- c("date", "value_0.975")
        to_add <- merge(to_add, subset_upper, by = "date", all.x = TRUE)
      }else{
        to_add$value_0.975 <- NA
      }
      
      # append to data_to_plot
      if(is.null(data_to_plot)){
        data_to_plot <- to_add
      }else{
        data_to_plot <- rbind(data_to_plot, to_add)
      }
    })
  }
}

nrow(data_to_plot)
# remove superfluous columns
data_to_plot$quantile <- data_to_plot$location <- NULL
# write out full file (currently not committed to repo)
write.csv(data_to_plot, "data_to_plot_long.csv", row.names = FALSE)
# data_to_plot <- read.csv("data_to_plot.csv", colClasses = c(data_version = "Date", "date" = "Date"))

# subset to last 60 days for each time point to reduce size:
data_to_plot_short <- subset(data_to_plot, date >= data_version - 60)
nrow(data_to_plot_short)
# write that out
write.csv(data_to_plot_short, "data_to_plot_short.csv", row.names = FALSE)
