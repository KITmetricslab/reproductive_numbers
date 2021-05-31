files <- list.files("data-raw/OWID", pattern = "*_raw.csv")
for (f in files) {
    input_filename <- paste("data-raw/OWID/", f, sep = "")
    input_dataframe <- read.csv(input_filename, sep = ",")
    output_dataframe <- data.frame()
    cnames <- c("data_version", "target", "date", "location", "type", "quantile", "value")
    for (row in seq(1, nrow(input_dataframe))) {
        output_dataframe <- rbind(output_dataframe, list(input_dataframe[nrow(input_dataframe), 4], "7 day R", input_dataframe[row, 4], "DE", "point", "NA", input_dataframe[row, 17]))
    }
    colnames(output_dataframe) <- cnames
    output_filename <- paste("data-processed/OWID/",input_dataframe[nrow(input_dataframe), 4], "-owid_processed.csv", sep = "")
    write.csv(output_dataframe, output_filename, row.names = FALSE)
}
