library(reshape2)
library(dplyr)
library(lubridate)

# load data file from the web

raw_data_dir <- "./raw_data"
raw_data_url <- "https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2Fhousehold_power_consumption.zip"
raw_data_filename <- "raw_data.zip"
raw_data_destfn <- paste(raw_data_dir, "/", "raw_data.zip", sep = "")
data_dir <- "./data"

if (!file.exists(raw_data_dir)) {
  dir.create(raw_data_dir)
  download.file(url = raw_data_url, destfile = raw_data_destfn)
}

if (!file.exists(data_dir)) {
  dir.create(data_dir)
  unzip(zipfile = raw_data_destfn, exdir = data_dir)
}

# read data and filter dates 2007-02-01 and 2007-02-02

init_dt <- read.table("./data/household_power_consumption.txt", header = TRUE, 
                      sep = ";", na.strings = "?", nrows = 75000)
household_dt <- as_tibble(init_dt)
energ_data <- household_dt %>%
  mutate(date_time = paste(Date, Time)) %>% 
  mutate(date_time = dmy_hms(date_time)) %>% 
  select(date_time, everything()) %>% 
  select(-(Date:Time))

subset_data <- energ_data %>% 
  filter(date_time >= as.Date("2007-02-01 00:00:00") &
           date_time < as.Date("2007-02-03 00:00:00"))

# make graph of GAP by day of the week

png(file = "plot2.png",
    width = 480, height = 480)

with(subset_data, plot(x = date_time, y = Global_active_power, type = "l",
                       xlab = "", ylab = "Global Active Power (kilowatts)"))

dev.off()