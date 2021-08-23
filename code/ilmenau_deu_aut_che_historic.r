files_deu <- list.files("data-raw/Ilmenau DEU", pattern = "*deu_raw.csv")

for (f in files_deu) {
    # Germany
    input_filename <- paste("data-raw/Ilmenau DEU/", f, sep = "")
    input_dataframe <- read.csv(input_filename, sep = ",")
    output_dataframe <- data.frame()
    cnames <- c("data_version", "target", "date", "location", "type", "quantile", "value")
    output_filename <- paste("data-processed/ilmenau/",input_dataframe[nrow(input_dataframe), 1], "-ilmenau.csv", sep = "")

    # some files don't exist for all countries
    if ((substr(f, 1, 10) == "2021-01-27") || (substr(f, 1, 10) == "2021-03-02")) {
       next()
    }

    for (row in seq(1, nrow(input_dataframe))) {
        output_dataframe <- rbind(output_dataframe, list(input_dataframe[nrow(input_dataframe), 1], "7 day R", input_dataframe[row, 1], "DE", "point", "NA", input_dataframe[row, 3]))
        output_dataframe <- rbind(output_dataframe, list(input_dataframe[nrow(input_dataframe), 1], "7 day R", input_dataframe[row, 1], "DE", "quantile", "0.025", input_dataframe[row, 5]))
        output_dataframe <- rbind(output_dataframe, list(input_dataframe[nrow(input_dataframe), 1], "7 day R", input_dataframe[row, 1], "DE", "quantile", "0.975", input_dataframe[row, 6]))

    }
    # Austria
    input_filename <- paste("data-raw/Ilmenau AUT/", substr(f, 1, 10), "_ilmenau_aut_raw.csv", sep = "")
    input_dataframe <- read.csv(input_filename, sep = ",")
    # fist file has a different format
    if (substr(f, 1, 10) == "2020-11-02") {
        for (row in seq(1, nrow(input_dataframe))) {
        output_dataframe <- rbind(output_dataframe, list(input_dataframe[nrow(input_dataframe), 3], "7 day R", input_dataframe[row, 3], "AU", "point", "NA", input_dataframe[row, 12]))
        output_dataframe <- rbind(output_dataframe, list(input_dataframe[nrow(input_dataframe), 3], "7 day R", input_dataframe[row, 3], "AU", "quantile", "0.025", input_dataframe[row, 14]))
        output_dataframe <- rbind(output_dataframe, list(input_dataframe[nrow(input_dataframe), 3], "7 day R", input_dataframe[row, 3], "AU", "quantile", "0.975", input_dataframe[row, 15]))

        }
    } else {
        for (row in seq(1, nrow(input_dataframe))) {
        output_dataframe <- rbind(output_dataframe, list(input_dataframe[nrow(input_dataframe), 1], "7 day R", input_dataframe[row, 3], "AU", "point", "NA", input_dataframe[row, 3]))
        output_dataframe <- rbind(output_dataframe, list(input_dataframe[nrow(input_dataframe), 1], "7 day R", input_dataframe[row, 3], "AU", "quantile", "0.025", input_dataframe[row, 5]))
        output_dataframe <- rbind(output_dataframe, list(input_dataframe[nrow(input_dataframe), 1], "7 day R", input_dataframe[row, 3], "AU", "quantile", "0.975", input_dataframe[row, 6]))

        }
    }

    # Switzerland
    input_filename <- paste("data-raw/Ilmenau CHE/", substr(f, 1, 10), "_ilmenau_che_raw.csv", sep = "")
    input_dataframe <- read.csv(input_filename, sep = ",")
    # fist file has a different format
    if (substr(f, 1, 10) == "2020-11-02") {
        for (row in seq(1, nrow(input_dataframe))) {
        output_dataframe <- rbind(output_dataframe, list(input_dataframe[nrow(input_dataframe), 3], "7 day R", input_dataframe[row, 3], "CH", "point", "NA", input_dataframe[row, 12]))
        output_dataframe <- rbind(output_dataframe, list(input_dataframe[nrow(input_dataframe), 3], "7 day R", input_dataframe[row, 3], "CH", "quantile", "0.025", input_dataframe[row, 14]))
        output_dataframe <- rbind(output_dataframe, list(input_dataframe[nrow(input_dataframe), 3], "7 day R", input_dataframe[row, 3], "CH", "quantile", "0.975", input_dataframe[row, 15]))

        }
    } else {
        for (row in seq(1, nrow(input_dataframe))) {
        output_dataframe <- rbind(output_dataframe, list(input_dataframe[nrow(input_dataframe), 1], "7 day R", input_dataframe[row, 3], "CH", "point", "NA", input_dataframe[row, 3]))
        output_dataframe <- rbind(output_dataframe, list(input_dataframe[nrow(input_dataframe), 1], "7 day R", input_dataframe[row, 3], "CH", "quantile", "0.025", input_dataframe[row, 5]))
        output_dataframe <- rbind(output_dataframe, list(input_dataframe[nrow(input_dataframe), 1], "7 day R", input_dataframe[row, 3], "CH", "quantile", "0.975", input_dataframe[row, 6]))

        }
    }

    colnames(output_dataframe) <- cnames
    write.csv(output_dataframe, output_filename, row.names = FALSE)
}
