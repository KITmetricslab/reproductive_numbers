input_filename <- "https://github.com/crondonm/TrackingR/blob/main/Estimates-Database/database.csv"
input_dataframe <- read.csv(input_filename, header = TRUE, sep = ",")
write.csv(input_dataframe, paste("data-raw/globalrt/", input_dataframe[nrow(input_dataframe), 9], "_globalrt_raw.csv", sep = ""), row.names = FALSE)
output_dataframe <- data.frame()
cnames <- c("data_version", "target", "date", "location", "type", "quantile", "value")
help <- c(NA, 0.025, 0.975)
for (row in seq(1, nrow(input_dataframe))) {
    output_dataframe <- rbind(output_dataframe, list(input_dataframe[row, 9], "7 day R", input_dataframe[row, 2], "DE", "point", help[1], input_dataframe[row, 3]))
    output_dataframe <- rbind(output_dataframe, list(input_dataframe[row, 9], "7 day R", input_dataframe[row, 2], "DE", "quantile", help[2], input_dataframe[row, 5]))
    output_dataframe <- rbind(output_dataframe, list(input_dataframe[row, 9], "7 day R", input_dataframe[row, 2], "DE", "quantile", help[3], input_dataframe[row, 4]))
}
colnames(output_dataframe) <- cnames
output_filename <- paste("data-processed/globalrt/", input_dataframe[nrow(input_dataframe), 9], "-globalrt.csv", sep = "")
write.csv(output_dataframe, output_filename, row.names = FALSE)
