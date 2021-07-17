# OWID reports reproduction_rate only since 2020-11-13, make sure no older data is in the data-raw/owid -folder.
files <- list.files("data-raw/owid", pattern = "*_raw.csv")
for (f in files) {
    input_filename <- paste("data-raw/owid/", f, sep = "")
    input_dataframe <- read.csv(input_filename, sep = ",")
    output_dataframe <- data.frame()
    cnames <- c("data_version", "target", "date", "location", "type", "quantile", "value")
    for (row in seq(1, nrow(input_dataframe))) {
        output_dataframe <- rbind(output_dataframe, list(input_dataframe[nrow(input_dataframe), 4], "7 day R", input_dataframe[row, 4], "DE", "point", "NA", input_dataframe[row, 17]))
    }
    colnames(output_dataframe) <- cnames
    output_filename <- paste("data-processed/owid/",input_dataframe[nrow(input_dataframe), 4], "-owid.csv", sep = "")
    write.csv(output_dataframe, output_filename, row.names = FALSE)
}
