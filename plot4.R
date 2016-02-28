# load the dataset
powerdata = read.table("household_power_consumption.txt",
                       header = TRUE,
                       sep = ";",
                       na.strings = "?")

# convert the strings powerdata$Date & powerdata$Time
# into a single variable of type POSIXlt
powerdata$Datetime = strptime(paste(powerdata$Date, " ", powerdata$Time),
                              format = "%d/%m/%Y %H:%M:%S")

# drop the now redundant columns powerdata$Data and powerdata$Time
powerdata = subset(powerdata, select = -c(Date, Time))

# subset those records from the 2007-02-01 and 2007-02-02
# (1st and 2nd of February 2007)
fmt = "%Y-%m-%d %H:%M:%S"
earliest_date = strptime("2007-02-01 0:00:00", format = fmt)
too_late_date = strptime("2007-02-03 0:00:00", format = fmt)
powerdata = subset(powerdata,
                   Datetime >= earliest_date & Datetime < too_late_date)

# create the png device to plot too
png(filename = "plot4.png", width = 480, height = 480)

# instruct the device that there will be 4 plots in a 2x2 row major arrangement
par(mfrow = c(2, 2))

# Create the first plot, a plot of Global active power over time
with(powerdata, plot(Datetime, Global_active_power, type = "l",
                     xlab = "",
                     ylab = "Global Active Power"))

# Create the second plot, a plot of Voltage over time
with(powerdata, plot(Datetime, Voltage, type = "l",
                     xlab = "datetime",
                     ylab = "Voltage"))

# Create the third plot, the different energy sub meters over time
## we need to create this plot piece by piece

## create the plot background
with(powerdata, plot(Datetime, Sub_metering_1, type = "n",
                     xlab = "",
                     ylab = "Energy sub metering"))

## plot the lines for the sub meters
with(powerdata, lines(Datetime,Sub_metering_1, col = "black"))
with(powerdata, lines(Datetime,Sub_metering_2, col = "red"))
with(powerdata, lines(Datetime,Sub_metering_3, col = "blue"))

## add the legend
legend("topright",
       bty = "n",
       legend = c("Sub_metering_1","Sub_metering_2","Sub_metering_3"),
       lty = 1, col = c("black", "red", "blue"))

# Create the fourth plot, that of Global reactive power over time
with(powerdata, plot(Datetime, Global_reactive_power, type = "l",
                     xlab = "datetime",
                     ylab = "Global_reactive_power"))


# close the png device and write the file
dev.off()
