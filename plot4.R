# Data downloading and reading
fileURL<-"https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2Fhousehold_power_consumption.zip"
download.file(fileURL, destfile="./exdata-data-household_power_consumption.zip", method="curl")
unzip("exdata-data-household_power_consumption.zip")
conn <- file("household_power_consumption.txt", "r")

data <- read.table(conn, 
                   sep = ";", 
                   comment.char = "", 
                   na.strings = "?",
                   header = TRUE, 
                   colClasses = c("character", "character", "numeric", "numeric", "numeric", "numeric", "numeric", "numeric", "numeric"))

#Convert Date and Time into one single DateAndTime variable
data$DateAndTime <- as.POSIXct(paste(data$Date, data$Time), format="%d/%m/%Y %H:%M:%S")
data$Time <- NULL
data$Date <- NULL

#Subset the dataset to the following date range: 2007-02-01 and 2007-02-02
libary(dplyr)
dateFrom <- as.POSIXct("01/02/2007 00:00:00", format="%d/%m/%Y %H:%M:%S")
dateUntil <- as.POSIXct("03/02/2007 00:00:00", format="%d/%m/%Y %H:%M:%S")
data <- filter(data, DateAndTime >= dateFrom & DateAndTime < dateUntil)

# Plot it into a png file
png(file = "plot4.png", width = 480, height = 480, bg = "transparent")

par(mfrow = c(2, 2), mar = c(5,4,3,2))

# Topleft plot

with(data, plot(DateAndTime, Global_active_power, type = "l", xlab = "", ylab = "Global Active Power"))

# Topright plot

with(data, plot(DateAndTime, Voltage, type = "l", xlab = "datetime"))

# Bottomleft plot

with(data, {plot(DateAndTime, Sub_metering_1, type = "n", xlab = "", ylab = "Energy sub metering");
            lines(DateAndTime, Sub_metering_1, col = "black");
            lines(DateAndTime, Sub_metering_2, col = "red");
            lines(DateAndTime, Sub_metering_3, col = "blue");
            legend("topright", col = c("black", "red", "blue"), lwd = 1, bty = "n", legend = c("Sub_metering_1","Sub_metering_2","Sub_metering_3"))})

# Bottomright plot

with(data, plot(DateAndTime, Global_reactive_power, type = "l", xlab = "datetime"))


dev.off()
