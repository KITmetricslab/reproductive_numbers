files <- list.files("data-raw/ETH Zürich", pattern = "*_raw.csv")
for (f in files) {
    input_filename <- paste("data-raw/ETH Zürich/", f, sep = "")
    input_dataframe <- read.csv(input_filename, sep = ",")
    data_version <- substr(f, 1, 10)

    # filter 
    input_dataframe <- input_dataframe[input_dataframe$data_type == 'Confirmed cases', ]
    df1 <- input_dataframe[input_dataframe$estimate_type == 'Cori_slidingWindow', ]
    df2 <- input_dataframe[input_dataframe$estimate_type == 'Cori_step', ]

    output_dataframe1 <- data.frame()
    output_dataframe2 <- data.frame()
    cnames <- c("data_version", "target", "date", "location", "type", "quantile", "value")

    for (row in seq(1, nrow(df1))) {
        output_dataframe1 <- rbind(output_dataframe1, list(data_version, "3 day R", df1[row, 6], "DE", "point", "NA", df1[row, 7]))
        output_dataframe1 <- rbind(output_dataframe1, list(data_version, "3 day R", df1[row, 6], "DE", "quantile", "0.025", df1[row, 9]))
        output_dataframe1 <- rbind(output_dataframe1, list(data_version, "3 day R", df1[row, 6], "DE", "quantile", "0.975", df1[row, 8]))
    }
    for (row in seq(1, nrow(df2))) {
        output_dataframe2 <- rbind(output_dataframe2, list(data_version, "7 day R", df2[row, 6], "DE", "point", "NA", df2[row, 7]))
        output_dataframe2 <- rbind(output_dataframe2, list(data_version, "7 day R", df2[row, 6], "DE", "quantile", "0.025", df2[row, 9]))
        output_dataframe2 <- rbind(output_dataframe2, list(data_version, "7 day R", df2[row, 6], "DE", "quantile", "0.975", df2[row, 8]))
    }
    colnames(output_dataframe1) <- cnames
    colnames(output_dataframe2) <- cnames

    output_filename1 <- paste("data-processed/ETHZ_sliding_window/", data_version, "-ETHZ_sliding_window.csv", sep = "")
    output_filename2 <- paste("data-processed/ETHZ_step/", data_version, "-ETHZ_step.csv", sep = "")

    write.csv(output_dataframe1, output_filename1, row.names = FALSE)
    write.csv(output_dataframe2, output_filename2, row.names = FALSE)

    
}
