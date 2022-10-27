library(readr)
library(data.table)

setwd("..")
getwd()

data_dir <- "data-raw/SDSC"
files <- list.files(data_dir, pattern = "*_re_*", full.names = T)

for (f in files) {
    pub_date <- regmatches(f, gregexpr("\\d{4}-\\d{2}-\\d{2}", f))[[1]]
    
    data_raw <- read_csv(f, show_col_types = F) %>% setDT()
    data <- melt(data_raw, id.vars = c("date", "country", "observed")) %>%
      mutate(data_version = pub_date,
             target = "7 day R",
             location = ifelse(country == "Austria", "AT",
                               ifelse(country == "Germany", "DE",
                                      ifelse(country == "Switzerland", "CH", NA))),
             label = ifelse(observed == "Observed", "estimate", "forecast"),
             type = ifelse(variable == "R_mean", "point", "quantile"),
             quantile = ifelse(variable == "R_low", 0.025,
                               ifelse(variable == "R_high", 0.975, NA))) %>%
      select("data_version", "target", "date", "location", "label", "type", "quantile", "value") %>%
      arrange(date)

    write_csv(data, paste0("data-processed/SDSC/", pub_date, "-sdsc.csv"))
    
    cat(pub_date, "... \n")
}
