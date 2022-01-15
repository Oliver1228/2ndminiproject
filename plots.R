if (!file.exists("specdata")){
  dir.create ("specdata")
}

# Plot 1
#reading the csv file and marking no string as factors
data<-read.csv("specdata/household_power_consumption.txt",sep = ";",stringsAsFactors = FALSE)
#subsetting data to 2 particular dates
subSetData <- data[data$Date %in% c("1/2/2007","2/2/2007") ,]                                       
png("plot1.png")                                                                           # storing the graph in a png file
# coercing character to numeric and plotting a histogram
hist(as.numeric(subSetData$Global_active_power),                                      
     col="salmon",                                                                         # setting color of histogram
     main="Global Active Power",                                                           # setting main title of histogram
     xlab="Global Active Power (kilowatts)")                                               # setting x-label of histogram         
dev.off()                                                                                  # stop recording and save the file

# Plot 2

#pasting date and time together and coercing from character to POSIXlt
datetime <- strptime(paste(subSetData$Date, subSetData$Time, sep=" "), "%d/%m/%Y %H:%M:%S") 
#coercing the column of subsetted data from character to numeric
globalActivePower <- as.numeric(subSetData$Global_active_power)                             
png("plot2.png")                                                                           # storing the graph in a png file
plot(datetime, globalActivePower, type="l", xlab="", ylab="Global Active Power (kilowatts)")
dev.off()                                                                                  # stop recording and save the file

# Plot 3
#coercing the column of subsetted data from character to numeric
subMetering1 <- as.numeric(subSetData$Sub_metering_1)
subMetering2 <- as.numeric(subSetData$Sub_metering_2)
subMetering3 <- as.numeric(subSetData$Sub_metering_3)

png("plot3.png")                                                                         # storing the graph in a png file
plot(datetime, subMetering1, type="l", ylab="Energy Submetering", xlab="")
lines(datetime, subMetering2, type="l", col="red")                                       # setting the colors of the lines
lines(datetime, subMetering3, type="l", col="blue")
legend("topright", c("Sub_metering_1", "Sub_metering_2", "Sub_metering_3"), lty=1, lwd=2.5, col=c("black", "red", "blue"))
dev.off()                                                                                # stop recording and save the file

# Plot 4
#coercing the column of subsetted data from character to numeric
globalReactivePower <- as.numeric(subSetData$Global_reactive_power)
voltage <- as.numeric(subSetData$Voltage)

png("plot4.png")                                                                        # storing the graph in a png file

par(mfrow = c(2, 2))                                                                    # layout of the plots are 2x2 in a grid like arrangement

plot(datetime, globalActivePower, type="l", xlab="", ylab="Global Active Power", cex=0.2)

plot(datetime, voltage, type="l", xlab="datetime", ylab="Voltage")

plot(datetime, subMetering1, type="l", ylab="Energy Submetering", xlab="")
lines(datetime, subMetering2, type="l", col="red")
lines(datetime, subMetering3, type="l", col="blue")
legend("topright", c("Sub_metering_1", "Sub_metering_2", "Sub_metering_3"), lty=, lwd=2.5, col=c("black", "red", "blue"), bty="o")

plot(datetime, globalReactivePower, type="l", xlab="datetime", ylab="Global_reactive_power")
dev.off()                                                                              # stop recording and save the file
