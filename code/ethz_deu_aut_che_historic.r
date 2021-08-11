files <- list.files("data-raw/ETHZ DEU", pattern = "*_raw.csv")

for (f in files) {
    # Germany
    input_filename <- paste("data-raw/ETHZ DEU/", f, sep = "")
    input_dataframe <- read.csv(input_filename, sep = ",")
    data_version <- substr(f, 1, 10)

    # filter 
    input_dataframe_cc <- input_dataframe[input_dataframe$data_type == 'Confirmed cases', ]
    df1 <- input_dataframe_cc[input_dataframe_cc$estimate_type == 'Cori_slidingWindow', ]
    df2 <- input_dataframe_cc[input_dataframe_cc$estimate_type == 'Cori_step', ]

    input_dataframe_death <- input_dataframe[input_dataframe$data_type == 'Deaths', ]
    df3 <- input_dataframe_death[input_dataframe_death$estimate_type == 'Cori_slidingWindow', ]
    df4 <- input_dataframe_death[input_dataframe_death$estimate_type == 'Cori_step', ]

    output_dataframe1 <- data.frame()
    output_dataframe2 <- data.frame()
    output_dataframe3 <- data.frame()
    output_dataframe4 <- data.frame()
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
    if(nrow(df3) > 0) {
        for (row in seq(1, nrow(df3))) {
            output_dataframe3 <- rbind(output_dataframe3, list(data_version, "3 day R", df3[row, 6], "DE", "point", "NA", df3[row, 7]))
            output_dataframe3 <- rbind(output_dataframe3, list(data_version, "3 day R", df3[row, 6], "DE", "quantile", "0.025", df3[row, 9]))
            output_dataframe3 <- rbind(output_dataframe3, list(data_version, "3 day R", df3[row, 6], "DE", "quantile", "0.975", df3[row, 8]))
        }
    }
    if(nrow(df4) > 0) {
        for (row in seq(1, nrow(df4))) {
            output_dataframe4 <- rbind(output_dataframe4, list(data_version, "7 day R", df4[row, 6], "DE", "point", "NA", df4[row, 7]))
            output_dataframe4 <- rbind(output_dataframe4, list(data_version, "7 day R", df4[row, 6], "DE", "quantile", "0.025", df4[row, 9]))
            output_dataframe4 <- rbind(output_dataframe4, list(data_version, "7 day R", df4[row, 6], "DE", "quantile", "0.975", df4[row, 8]))
        }
    }

    # Austria
    # test if corresponding file exists for Austria
    if (file_test( "-f", paste("data-raw/ETHZ AUT/", substr(f, 1, 10), "_ethz_aut_raw.csv", sep = ""))) {
        input_filename <- paste("data-raw/ETHZ AUT/", substr(f, 1, 10), "_ethz_aut_raw.csv", sep = "")
        input_dataframe <- read.csv(input_filename, sep = ",")
        data_version <- substr(f, 1, 10)

        # filter 
        input_dataframe_cc <- input_dataframe[input_dataframe$data_type == 'Confirmed cases', ]
        df1 <- input_dataframe_cc[input_dataframe_cc$estimate_type == 'Cori_slidingWindow', ]
        df2 <- input_dataframe_cc[input_dataframe_cc$estimate_type == 'Cori_step', ]

        input_dataframe_death <- input_dataframe[input_dataframe$data_type == 'Deaths', ]
        df3 <- input_dataframe_death[input_dataframe_death$estimate_type == 'Cori_slidingWindow', ]
        df4 <- input_dataframe_death[input_dataframe_death$estimate_type == 'Cori_step', ]


        for (row in seq(1, nrow(df1))) {
            output_dataframe1 <- rbind(output_dataframe1, list(data_version, "3 day R", df1[row, 6], "AU", "point", "NA", df1[row, 7]))
            output_dataframe1 <- rbind(output_dataframe1, list(data_version, "3 day R", df1[row, 6], "AU", "quantile", "0.025", df1[row, 9]))
            output_dataframe1 <- rbind(output_dataframe1, list(data_version, "3 day R", df1[row, 6], "AU", "quantile", "0.975", df1[row, 8]))
        }
        for (row in seq(1, nrow(df2))) {
            output_dataframe2 <- rbind(output_dataframe2, list(data_version, "7 day R", df2[row, 6], "AU", "point", "NA", df2[row, 7]))
            output_dataframe2 <- rbind(output_dataframe2, list(data_version, "7 day R", df2[row, 6], "AU", "quantile", "0.025", df2[row, 9]))
            output_dataframe2 <- rbind(output_dataframe2, list(data_version, "7 day R", df2[row, 6], "AU", "quantile", "0.975", df2[row, 8]))
        }
        if(nrow(df3) > 0) {
            for (row in seq(1, nrow(df3))) {
                output_dataframe3 <- rbind(output_dataframe3, list(data_version, "3 day R", df3[row, 6], "AU", "point", "NA", df3[row, 7]))
                output_dataframe3 <- rbind(output_dataframe3, list(data_version, "3 day R", df3[row, 6], "AU", "quantile", "0.025", df3[row, 9]))
                output_dataframe3 <- rbind(output_dataframe3, list(data_version, "3 day R", df3[row, 6], "AU", "quantile", "0.975", df3[row, 8]))
            }
        }
        if(nrow(df4) > 0) {
            for (row in seq(1, nrow(df4))) {
                output_dataframe4 <- rbind(output_dataframe4, list(data_version, "7 day R", df4[row, 6], "AU", "point", "NA", df4[row, 7]))
                output_dataframe4 <- rbind(output_dataframe4, list(data_version, "7 day R", df4[row, 6], "AU", "quantile", "0.025", df4[row, 9]))
                output_dataframe4 <- rbind(output_dataframe4, list(data_version, "7 day R", df4[row, 6], "AU", "quantile", "0.975", df4[row, 8]))
            }
        }
    }

    # Switzerland
    # test if corresponding file exists for Switzerland
    if (file_test( "-f", paste("data-raw/ETHZ CHE/", substr(f, 1, 10), "_ethz_che_raw.csv", sep = ""))) {

        input_filename <- paste("data-raw/ETHZ CHE/", substr(f, 1, 10), "_ethz_che_raw.csv", sep = "")
        input_dataframe <- read.csv(input_filename, sep = ",")
        data_version <- substr(f, 1, 10)

        # filter 
        input_dataframe <- input_dataframe[input_dataframe$region == 'CHE', ]

        input_dataframe_cc <- input_dataframe[input_dataframe$data_type == 'Confirmed cases', ]
        df1 <- input_dataframe_cc[input_dataframe_cc$estimate_type == 'Cori_slidingWindow', ]
        df2 <- input_dataframe_cc[input_dataframe_cc$estimate_type == 'Cori_step', ]

        input_dataframe_death <- input_dataframe[input_dataframe$data_type == 'Deaths', ]
        df3 <- input_dataframe_death[input_dataframe_death$estimate_type == 'Cori_slidingWindow', ]
        df4 <- input_dataframe_death[input_dataframe_death$estimate_type == 'Cori_step', ]


        for (row in seq(1, nrow(df1))) {
            output_dataframe1 <- rbind(output_dataframe1, list(data_version, "3 day R", df1[row, 6], "CH", "point", "NA", df1[row, 7]))
            output_dataframe1 <- rbind(output_dataframe1, list(data_version, "3 day R", df1[row, 6], "CH", "quantile", "0.025", df1[row, 9]))
            output_dataframe1 <- rbind(output_dataframe1, list(data_version, "3 day R", df1[row, 6], "CH", "quantile", "0.975", df1[row, 8]))
        }
        for (row in seq(1, nrow(df2))) {
            output_dataframe2 <- rbind(output_dataframe2, list(data_version, "7 day R", df2[row, 6], "CH", "point", "NA", df2[row, 7]))
            output_dataframe2 <- rbind(output_dataframe2, list(data_version, "7 day R", df2[row, 6], "CH", "quantile", "0.025", df2[row, 9]))
            output_dataframe2 <- rbind(output_dataframe2, list(data_version, "7 day R", df2[row, 6], "CH", "quantile", "0.975", df2[row, 8]))
        }
        if(nrow(df3) > 0) {
            for (row in seq(1, nrow(df3))) {
                output_dataframe3 <- rbind(output_dataframe3, list(data_version, "3 day R", df3[row, 6], "CH", "point", "NA", df3[row, 7]))
                output_dataframe3 <- rbind(output_dataframe3, list(data_version, "3 day R", df3[row, 6], "CH", "quantile", "0.025", df3[row, 9]))
                output_dataframe3 <- rbind(output_dataframe3, list(data_version, "3 day R", df3[row, 6], "CH", "quantile", "0.975", df3[row, 8]))
            }
        }
        if(nrow(df4) > 0) {
            for (row in seq(1, nrow(df4))) {
                output_dataframe4 <- rbind(output_dataframe4, list(data_version, "7 day R", df4[row, 6], "CH", "point", "NA", df4[row, 7]))
                output_dataframe4 <- rbind(output_dataframe4, list(data_version, "7 day R", df4[row, 6], "CH", "quantile", "0.025", df4[row, 9]))
                output_dataframe4 <- rbind(output_dataframe4, list(data_version, "7 day R", df4[row, 6], "CH", "quantile", "0.975", df4[row, 8]))
            }
        }
    }

    colnames(output_dataframe1) <- cnames
    colnames(output_dataframe2) <- cnames
    if (nrow(df3) > 0) {
        colnames(output_dataframe3) <- cnames
    }
    if (nrow(df4) > 0) {
        colnames(output_dataframe4) <- cnames
    }

    output_filename1 <- paste("data-processed/ETHZ_sliding_window/", data_version, "-ETHZ_sliding_window.csv", sep = "")
    output_filename2 <- paste("data-processed/ETHZ_step/", data_version, "-ETHZ_step.csv", sep = "")
    output_filename3 <- paste("data-processed/ETHZ_sliding_window_deaths/", data_version, "-ETHZ_sliding_window_deaths.csv", sep = "")
    output_filename4 <- paste("data-processed/ETHZ_step_deaths/", data_version, "-ETHZ_step_deaths.csv", sep = "")

    write.csv(output_dataframe1, output_filename1, row.names = FALSE)
    write.csv(output_dataframe2, output_filename2, row.names = FALSE)
    if(nrow(df3) > 0) {
        write.csv(output_dataframe3, output_filename3, row.names = FALSE)
    }
    if(nrow(df4) > 0) {
        write.csv(output_dataframe4, output_filename4, row.names = FALSE)
    }
    

    
}