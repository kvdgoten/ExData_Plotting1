### plot1.R
###
## initializing
# setwd("c:/Users/tn93760/Desktop/Coursera/M4 Exploratory Data Analysis/")
library(readr)
library(dplyr)
library(lubridate)

### estimating the memory needed to load the file
### adapted with pride from http://stackoverflow.com/questions/25674221/predict-memory-usage-in-r
# top.size <- object.size(read.csv2("household_power_consumption.txt", nrow=1000, na.strings = "?"))
top.size <- object.size(read_csv2("household_power_consumption.txt", n_max=1000, na = "?"))
lines <- 2075260 # manually with cygwin bash
size.estimate <- lines / 1000 * top.size
size.estimate / (1024*1024) ### over-estimated to be 250 Mb

### read the file and limitting to Feb 1 and 2 2007
hpc <- read_csv2("household_power_consumption.txt", na = "?")
hpc$Date <- as.Date(strptime(hpc$Date, format = "%d/%m/%Y"))
hpcDate <- filter(hpc, 
                  year(Date)==2007,
                  month(Date)==2,
                  day(Date) >= 1,
                  day(Date) <= 2
)
### transform data in order to be usable for plotting
### add new dateTime column composed of Date and Time
### and transform columns from character to numeric -(Voltage)
hpcDate$dateTime <- paste(hpcDate$Date,
                          sprintf('%02d:%02d:%02d', 
                                  seconds_to_period(hpcDate$Time)$hour, 
                                  seconds_to_period(hpcDate$Time)$minute, 
                                  seconds_to_period(hpcDate$Time)$second))
hpcDate$dateTime <- as.POSIXct(hpcDate$dateTime)

hpcDate$Global_active_power <- as.numeric(hpcDate$Global_active_power)
hpcDate$Global_reactive_power <- as.numeric(hpcDate$Global_reactive_power)
hpcDate$Global_intensity <- as.numeric(hpcDate$Global_intensity)
hpcDate$Sub_metering_1 <- as.numeric(hpcDate$Sub_metering_1)
hpcDate$Sub_metering_2 <- as.numeric(hpcDate$Sub_metering_2)
hpcDate$Sub_metering_3 <- as.numeric(hpcDate$Sub_metering_3)



### Plot 1
png(filename = "plot1.png", width = 480, height = 480)
hist(hpcDate$Global_active_power, col = "red", main = "Global Active Power", 
     xlab = "Global Active Power (kilowatts)")
dev.off()
