url  <- "https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2Fhousehold_power_consumption.zip"
file <- "./household_power_consumption.txt"
zip  <- "./pc.zip"

# Download the file if necessary
if (!file.exists("./household_power_consumption.txt")) {
    download.file(url, destfile = zip)
    unzip(zip)
    file.remove(zip)
}

# Load the required library and read the file
library(data.table)
dt <- fread(file, sep = ";", header = TRUE, colClasses = rep("character",9))

# Convert missing values to NA
dt[dt == "?"] <- NA

# Convert date to desired format
dt$Date <- as.Date(dt$Date, format = "%d/%m/%Y")
#  Use only rows with dates from 2007-02-01 and 2007-02-02
dt <- dt[dt$Date >= as.Date("2007-02-01") & dt$Date <= as.Date("2007-02-02"),]

# Create a new posix date
dt$posix <- as.POSIXct(strptime(paste(dt$Date, dt$Time, sep = " "),
	format = "%Y-%m-%d %H:%M:%S"))

# Convert column that we will use to correct class
dt$Global_active_power <- as.numeric(dt$Global_active_power)

# Use par() set 4 graphs.
png(file = "plot4.png", width = 480, height = 480, units = "px")
par(mfrow = c(2,2))

plot(dt$posix, dt$Global_active_power, type="l", xlab="", ylab="Global active power")	
plot(dt$posix, dt$Voltage, type = "l", xlab="datetime", ylab="Voltage")

plot(dt$posix, dt$Sub_metering_1, type = "l", xlab="", ylab="Energy sub metering")
points(dt$posix, type = "l", dt$Sub_metering_2, col="red")
points(dt$posix, type = "l", dt$Sub_metering_3, col="blue")

plot(dt$posix, dt$Global_reactive_power, type = "l", xlab = "datetime", ylab = "Global reactive power")
# Close the image device
dev.off()