# This script extracts the eestimated effective reproductive numbers and uncertainty intervals
# from the svg files of the plots provided in the PDF reports (svgs generated using OpenOffice Draw
# unfortunately the conversion to svg seems to depend on the software used)

setwd("/home/johannes/Documents/Projects/reproductive_numbers/code")

# function to extract coordinates from lines:
extract_coordinates <- function(str){
  M <- strsplit(str, split = c('\"M ', ' L '), fixed = TRUE)[[1]][2]
  M <- gsub(pattern = '\"/>', "", M)
  M <- gsub(pattern = ' Z', "", M)
  M <- gsub(pattern = ' L ', ",", M)
  M <- gsub(pattern = " ", ",", M)
  M <- as.numeric(strsplit(M, ",")[[1]])
  M <- matrix(M, ncol = 2, byrow = TRUE)
  M
}

# get files in the data-raw folder:
path_raw <- "../data-raw/AGES"
all_files <- list.files(path_raw)
svgs <- all_files[grepl(".svg", all_files)]

# extract dates from file names:
data_versions <- as.Date(gsub(".svg", "", gsub("Update_Epidemiologische_Parameter_des_COVID19_Ausbruchs_", "", svgs)))

for(i in seq_along(data_versions)){
  file <- svgs[i]
  
  cat("Starting", file, "...\n")
  
  # read in entire svg file as text:
  all_lines <- readLines(paste0(path_raw, "/", file), warn = FALSE)
  
  # extract relevant lines:
  # line with horizontal line at R0 = 0
  line_y0 <- all_lines[which(grepl('fill="none" stroke="rgb(217,217,217)" stroke-width="37" stroke-linejoin="round"', all_lines, fixed = TRUE))[1]]
  # line with horizontal line at R0 = 1
  line_y1 <- all_lines[which(grepl('fill="none" stroke="rgb(255,0,0)" stroke-width="37" stroke-linejoin="round"', all_lines, fixed = TRUE))[1]]
  # line with point estimates:
  line_points <- all_lines[which(grepl('fill="none" stroke="rgb(131,36,36)" stroke-width="90" stroke-linejoin="round"', all_lines, fixed = TRUE) |
                                   grepl('fill="none" stroke="rgb(131,36,36)" stroke-width="105" stroke-linejoin="round"', all_lines, fixed = TRUE))][1]
  # lines with polygon for intervals:
  line_shaded <- all_lines[which(grepl('fill="rgb(51,51,51)" fill-opacity="0.2" stroke="rgb(255,255,255)" stroke-opacity="0.2"', all_lines, fixed = TRUE))[1]]
  
  # check if extraction of information worked:
  if(all(!is.na(c(line_y0, line_y1, line_points, line_shaded)))){
    # extract the coordinates stored in the respective lines:
    coords_y0 <- extract_coordinates(line_y0)
    coords_y1 <- extract_coordinates(line_y1)
    coords_points <- extract_coordinates(line_points)
    coords_shaded <- extract_coordinates(line_shaded)
    coords_shaded <- coords_shaded[1:(2*nrow(coords_points)), ]
    
    # compute the dates:
    n_dates <- nrow(coords_points)
    dates <- seq(from = as.Date("2020-03-10"), by = 1, length.out = n_dates) # aöways starts at 10 March 2020
    # transform point estimates to actual scale:
    point_estimates <- (coords_points[, 2] - coords_y0[1, 2]) / (coords_y1[1, 2] - coords_y0[1, 2])
    # transform interval ends to actual scale:
    upper <- (head(coords_shaded[, 2], n_dates) - coords_y0[1, 2]) / (coords_y1[1, 2] - coords_y0[1, 2])
    lower <- (rev(tail(coords_shaded[, 2], n_dates)) - coords_y0[1, 2]) / (coords_y1[1, 2] - coords_y0[1, 2])
    
    # plot(dates, point_estimates, type = "l")
    # lines(dates, upper, lty = 3)
    # lines(dates, lower, lty = 3)
    
    # format:
    result <- data.frame(data_version = data_version[i],
                         target = "R_t",
                         location = "AT",
                         date = rep(dates, 3),
                         type = rep(c("point", "quantile", "quantile"), each = n_dates),
                         quantile = rep(c(NA, 0.025, 0.975), each = n_dates),
                         value = c(point_estimates, lower, upper))
    result <- result[order(result$date), ] #re-order
    
    # write out:
    write.csv(result, file = paste0("../data-processed/AGES/", data_version[i], "-AGES.csv"), row.names = FALSE)
  }else{
    cat(file, "could not be processed.")
  }
}






