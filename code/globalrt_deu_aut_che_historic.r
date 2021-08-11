files <- list.files("data-raw/globalrt", pattern = "*_raw.csv")
for (f in files) {
    input_filename <- paste("data-raw/globalrt/", f, sep = "")
    input_6_series <- read.csv(input_filename, sep = ",") # file contains 6 time series
    for (i in seq(5, 10)) { # create seperate files for each series
        input_dataframe_all <- input_6_series[input_6_series$days_infectious == i, ]
        output_dataframe <- data.frame()
        cnames <- c("data_version", "target", "date", "location", "type", "quantile", "value")
        # Germany
        input_dataframe <- input_dataframe_all[input_dataframe_all$Country.Region == 'Germany', ]
        for (row in seq(1, nrow(input_dataframe))) {
            output_dataframe <- rbind(output_dataframe, list(input_dataframe[nrow(input_dataframe), 9], paste(i, " day R", sep = ""), input_dataframe[row, 2], "DE", "point", "NA", input_dataframe[row, 3]))
            output_dataframe <- rbind(output_dataframe, list(input_dataframe[nrow(input_dataframe), 9], paste(i, " day R", sep = ""), input_dataframe[row, 2], "DE", "quantile", "0.025", input_dataframe[row, 5]))
            output_dataframe <- rbind(output_dataframe, list(input_dataframe[nrow(input_dataframe), 9], paste(i, " day R", sep = ""), input_dataframe[row, 2], "DE", "quantile", "0.975", input_dataframe[row, 4]))

        }
        # Austria
        input_dataframe <- input_dataframe_all[input_dataframe_all$Country.Region == 'Austria', ]
        for (row in seq(1, nrow(input_dataframe))) {
            output_dataframe <- rbind(output_dataframe, list(input_dataframe[nrow(input_dataframe), 9], paste(i, " day R", sep = ""), input_dataframe[row, 2], "AU", "point", "NA", input_dataframe[row, 3]))
            output_dataframe <- rbind(output_dataframe, list(input_dataframe[nrow(input_dataframe), 9], paste(i, " day R", sep = ""), input_dataframe[row, 2], "AU", "quantile", "0.025", input_dataframe[row, 5]))
            output_dataframe <- rbind(output_dataframe, list(input_dataframe[nrow(input_dataframe), 9], paste(i, " day R", sep = ""), input_dataframe[row, 2], "AU", "quantile", "0.975", input_dataframe[row, 4]))

        }
        # Switzerland
        input_dataframe <- input_dataframe_all[input_dataframe_all$Country.Region == 'Switzerland', ]
        for (row in seq(1, nrow(input_dataframe))) {
            output_dataframe <- rbind(output_dataframe, list(input_dataframe[nrow(input_dataframe), 9], paste(i, " day R", sep = ""), input_dataframe[row, 2], "CH", "point", "NA", input_dataframe[row, 3]))
            output_dataframe <- rbind(output_dataframe, list(input_dataframe[nrow(input_dataframe), 9], paste(i, " day R", sep = ""), input_dataframe[row, 2], "Ch", "quantile", "0.025", input_dataframe[row, 5]))
            output_dataframe <- rbind(output_dataframe, list(input_dataframe[nrow(input_dataframe), 9], paste(i, " day R", sep = ""), input_dataframe[row, 2], "CH", "quantile", "0.975", input_dataframe[row, 4]))

        }
        colnames(output_dataframe) <- cnames
        output_filename <- paste("data-processed/globalrt_", i, "d/", input_dataframe[nrow(input_dataframe), 9], "-globalrt_", i, "d.csv", sep = "")
        write.csv(output_dataframe, output_filename, row.names = FALSE)
    }
    
}
