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

png(filename="plot4.png",
    width     = 480,
    height    = 480,
    units     = "px",)

lim<-c(0,max(power_data$Sub_metering_1,power_data$Sub_metering_2,power_data$Sub_metering_3))
par(mfrow = c(2, 2), mar = c(4, 4, 2, 1), oma = c(0, 0, 2, 0))
with(power_data, {
  plot(Datetime, Global_active_power, type="n", xlab="", ylab = "Global Active Power")
  lines(Datetime, Global_active_power)
  plot(Datetime, Voltage, ylab = "Voltage", type="n", xlab="datetime")
  lines(Datetime, Voltage)
  plot(Datetime, Global_active_power, type="n", xlab="", ylab="Energy sub mettering", ylim=lim)
  lines(Datetime, Sub_metering_1, col="black")
  lines(Datetime, Sub_metering_2, col="red")
  lines(Datetime, Sub_metering_3, col="blue")
  legend("topright",  c("Sub_metering_1","Sub_metering_2","Sub_metering_3"), col = c("black", "red", "blue"), lty=c(1, 1, 1), bty="n",  horiz=F)
  plot(Datetime, Global_reactive_power, type="n", xlab="datetime")
  lines(Datetime, Global_reactive_power)
})
dev.off()