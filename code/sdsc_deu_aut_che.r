files <- list.files("data-raw/SDSC")
for (f in files) {
    input_filename <- paste("data-raw/SDSC/", f, sep = "")
    input_3_series <- read.csv(input_filename, sep = ",") 
    input_dataframe_all <- input_3_series
    output_dataframe <- data.frame()
    cnames <- c("data_version", "target", "date", "location", "type", "quantile", "value")
    # Germany
    input_dataframe <- input_dataframe_all[input_dataframe_all$country == 'Germany', ]
    for (row in seq(1, nrow(input_dataframe))) {
        output_dataframe <- rbind(output_dataframe, list(input_dataframe[nrow(input_dataframe), 2], paste(7, " day R", sep = ""), input_dataframe[row, 2], "DE", "point", "NA", input_dataframe[row, 4]))
        output_dataframe <- rbind(output_dataframe, list(input_dataframe[nrow(input_dataframe), 2], paste(7, " day R", sep = ""), input_dataframe[row, 2], "DE", "quantile", "0.025", input_dataframe[row, 3]))
        output_dataframe <- rbind(output_dataframe, list(input_dataframe[nrow(input_dataframe), 2], paste(7, " day R", sep = ""), input_dataframe[row, 2], "DE", "quantile", "0.975", input_dataframe[row, 5]))

    }
    # Austria
    input_dataframe <- input_dataframe_all[input_dataframe_all$country == 'Austria', ]
    for (row in seq(1, nrow(input_dataframe))) {
        output_dataframe <- rbind(output_dataframe, list(input_dataframe[nrow(input_dataframe), 2], paste(7, " day R", sep = ""), input_dataframe[row, 2], "AU", "point", "NA", input_dataframe[row, 4]))
        output_dataframe <- rbind(output_dataframe, list(input_dataframe[nrow(input_dataframe), 2], paste(7, " day R", sep = ""), input_dataframe[row, 2], "AU", "quantile", "0.025", input_dataframe[row, 3]))
        output_dataframe <- rbind(output_dataframe, list(input_dataframe[nrow(input_dataframe), 2], paste(7, " day R", sep = ""), input_dataframe[row, 2], "AU", "quantile", "0.975", input_dataframe[row, 5]))

    }
    # Switzerland
    input_dataframe <- input_dataframe_all[input_dataframe_all$country == 'Switzerland', ]
    for (row in seq(1, nrow(input_dataframe))) {
        output_dataframe <- rbind(output_dataframe, list(input_dataframe[nrow(input_dataframe), 2], paste(7, " day R", sep = ""), input_dataframe[row, 2], "CH", "point", "NA", input_dataframe[row, 4]))
        output_dataframe <- rbind(output_dataframe, list(input_dataframe[nrow(input_dataframe), 2], paste(7, " day R", sep = ""), input_dataframe[row, 2], "CH", "quantile", "0.025", input_dataframe[row, 3]))
        output_dataframe <- rbind(output_dataframe, list(input_dataframe[nrow(input_dataframe), 2], paste(7, " day R", sep = ""), input_dataframe[row, 2], "CH", "quantile", "0.975", input_dataframe[row, 5]))

    }
    colnames(output_dataframe) <- cnames
    output_filename <- paste("data-processed/SDSC/", input_dataframe[nrow(input_dataframe), 2], "-sdsc.csv", sep = "")
    write.csv(output_dataframe, output_filename, row.names = FALSE)
    
}
