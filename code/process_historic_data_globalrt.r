files <- list.files("data-raw/globalrt", pattern = "*_raw.csv")
for (f in files) {
    input_filename <- paste("data-raw/globalrt/", f, sep = "")
    input_dataframe <- read.csv(input_filename, sep = ",")
    output_dataframe <- data.frame()
    cnames <- c("data_version", "target", "date", "location", "type", "quantile", "value")
    for (row in seq(1, nrow(input_dataframe))) {
        output_dataframe <- rbind(output_dataframe, list(input_dataframe[nrow(input_dataframe), 9], "7 day R", input_dataframe[row, 2], "DE", "point", "NA", input_dataframe[row, 3]))
        output_dataframe <- rbind(output_dataframe, list(input_dataframe[nrow(input_dataframe), 9], "7 day R", input_dataframe[row, 2], "DE", "quantile", "0.025", input_dataframe[row, 5]))
        output_dataframe <- rbind(output_dataframe, list(input_dataframe[nrow(input_dataframe), 9], "7 day R", input_dataframe[row, 2], "DE", "quantile", "0.975", input_dataframe[row, 4]))

    }
    colnames(output_dataframe) <- cnames
    output_filename <- paste("data-processed/globalrt/",input_dataframe[nrow(input_dataframe), 9], "-globalrt.csv", sep = "")
    write.csv(output_dataframe, output_filename, row.names = FALSE)
}
