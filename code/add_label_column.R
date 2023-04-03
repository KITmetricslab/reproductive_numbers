library(readr)
library(dplyr)

setwd("..")
getwd()

# methods with no labels
methods <- c("Braunschweig", "ETHZ_sliding_window","RKI_7day", "rtlive", "globalrt_7d")

for (method in methods){
  data_dir <- paste0("data-processed/", method, "/")
  files <- list.files(data_dir, pattern = "*.csv", full.names = T)

  if ("label" %in% (read_csv(files[100], show_col_types = FALSE) %>% colnames())){
    print(paste("Label column already exists for method:", method))
  } else {
    
    print(paste("Adding label column for method:", method))
    for (file in files){
      read_csv(file, show_col_types = FALSE) %>%
        mutate(label = "estimate") %>%
        relocate(data_version, target, date, location, label, type, quantile, value) %>%
        write_csv(file)
    } 
  }
}


# manually for single files
method <- "ETHZ_sliding_window"
date <- "2021-03-12"
file <- paste0("data-processed/", method, "/", date, "-", method, ".csv")
read_csv(file, show_col_types = FALSE) %>%
  mutate(label = "estimate") %>%
  relocate(data_version, target, date, location, label, type, quantile, value) %>%
  write_csv(file)
