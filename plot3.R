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

# Create a graph with the specified dimensions and export it.
png(file = "plot3.png", width = 480, height = 480, units = "px")
plot(dt$posix, dt$Sub_metering_1, type="l", xlab="", ylab="Global_active_power (kilowatts)")	
points(dt$posix, type = "l", dt$Sub_metering_2, col="red")
points(dt$posix, type = "l", dt$Sub_metering_3, col="blue")
legend("topright", col=c("black","blue","red"), legend=c("Sub_metering_1", "Sub_metering_2", "Sub_metering_3"), lty=1)
# Close the image device
dev.off()