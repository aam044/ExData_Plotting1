# Checking if we already download data in working dir
# if not we need to download and unzip

if (!length(list.files('.', pattern='household_power_consumption.txt'))>0) 
{
  fileUrl='https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2Fhousehold_power_consumption.zip'
  download.file(url = fileUrl, method = 'curl', destfile = 'power_consumption.zip')
  unzip('power_consumption.zip')  
}
# checking some required libraries are installed and install them if needed
if (!"lubridate" %in% installed.packages()) install.packages("lubridate")
if (!"readr" %in% installed.packages()) install.packages("readr")

# load required libraries
library(dplyr)
library(lubridate)
library(readr)

# reading all data keeping in mind than ? is NA
power_all <- read_delim("household_power_consumption.txt", delim=";", na='?', col_types = "ccnnnnnnn")

# creating small working data only for dates we interested
power_data <- filter(power_all, Date =="1/2/2007" | Date == "2/2/2007" ) %>% 
  mutate(Datetime=dmy_hms(paste(Date,Time))) %>% 
  select(-(Date:Time))

# removing big dataset from memory
remove(power_all)

# Creating plot 2 as specified

png(filename="plot2.png",
    width     = 480,
    height    = 480,
    units     = "px",)

with(power_data,
{ plot(Datetime, Global_active_power, type="n", xlab="", ylab="Global Active Power (kilowatts)")
  lines(Datetime, Global_active_power)},
)

dev.off()

