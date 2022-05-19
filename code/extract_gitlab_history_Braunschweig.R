# This script serves to access old versions of the file
# simm/covid19/secir/img/dynamic/Rt_rawData/Germany_Rt.csv 

library(gitlabr)
library(lubridate)
library(readr)

setwd("..")

# connect as a fixed user to a GitLab instance for the session
set_gitlab_connection(
  gitlab_url = "https://gitlab.com",
  private_token = Sys.getenv("GITLAB_COM_TOKEN"))

commits <- gitlabr::gl_get_commits("17920736", max_page = 25)

dates <- as_date(commits$committed_date)
sum(duplicated(dates)) # some dates seem to be in there twice.
dates_to_load <- unique(dates)

for(i in seq_along(dates_to_load)){
  date <- dates_to_load[i]
  
  index_commit <- tail(which(dates == date), 1) # use last commit of the day
  path_commit <- paste0("https://gitlab.com/simm/covid19/secir/-/raw/",
                        commits$id[index_commit],
                        "/img/dynamic/Rt_rawData/Germany_Rt.csv")

  data <- read.csv(path_commit)
  
  write_csv(data, paste0("data-raw/Braunschweig/", date, "-Braunschweig_raw.csv"))
  
  cat(as.character(date), "...\n")
}
