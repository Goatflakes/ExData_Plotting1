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
png(filename = "plot2.png", width = 480, height = 480)

# create the plot
with(powerdata, plot(Datetime, Global_active_power, type = "l",
                     xlab = "",
                     ylab = "Global Active Power (kilowatts)"))

# close the png device and write the file
dev.off()
