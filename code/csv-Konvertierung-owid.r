input_filename <- "https://covid.ourworldindata.org/data/owid-covid-data.csv"
input_dataframe <- read.csv(input_filename, sep = ",")
data_germany <- input_dataframe[which(input_dataframe$iso_code == "DEU"), ]
write.csv(data_germany, paste("data-raw/OWID/", input_dataframe[nrow(input_dataframe), 4], "-owid_raw.csv", sep = ""), row.names = FALSE)
output_dataframe <- data.frame()
cnames <- c("data_version", "target", "date", "location", "type", "quantile", "value")
for (row in seq(1, nrow(data_germany))) {
   output_dataframe <- rbind(output_dataframe, list(data_germany[nrow(data_germany), 4], "7 day R", data_germany[row, 4], "DE", "point", "NA", data_germany[row, 17]))
}
colnames(output_dataframe) <- cnames
output_filename <- paste("data-processed/OWID/",data_germany[nrow(data_germany), 4], "-owid_processed.csv", sep = "")
write.csv(output_dataframe, output_filename, row.names = FALSE)
