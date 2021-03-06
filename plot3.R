#unzipping thte downloaded dataset
list.files(recursive = T)
unzip("exdata_data_household_power_consumption.zip",exdir = "./electricity")

##reading the csv file with sep as ";"
electricity<-read.csv("./electricity/household_power_consumption.txt",sep = ";")
print(object.size(electricity),units = "Mb")
tail(electricity)

str(electricity)

#converting dates to date object and time converted to posixlt format
library(lubridate)
electricity$Date<-as.Date(electricity$Date,"%d/%m/%Y")
electricity$Time<-strptime(electricity$Time,format = "%H:%M:%S")
electricity$Time<-gsub("^2020-06-07 ","",electricity$Time)



#filtering out the date we are going to work with i.e. 2007-02-01 and 2007-02-02
library(plyr)
library(dplyr)
library(lattice)
electricity_new<-filter(electricity,grepl("2007-02-01|2007-02-02",electricity$Date)==T)
str(electricity_new)
head(electricity_new)
tail(electricity_new)
electricity_new$Global_active_power<-as.numeric(as.character(electricity_new$Global_active_power))
electricity_new$Time<-strptime(electricity_new$Time,format = "%H:%M:%S")
electricity_new[1:1440,"Time"]<-format(electricity_new[1:1440,"Time"],"2007-02-01 %H:%M:%S")  
electricity_new[1441:2880,"Time"]<-format(electricity_new[1441:2880,"Time"],"2007-02-02 %H:%M:%S")

#plotting
with(electricity_new,{
                        plot(Time,as.numeric(as.character(Sub_metering_1)),xlab = "",ylab = "Energy sub metering",type="l")
                        points(Time,as.numeric(as.character(Sub_metering_2)),col="red",type = "l")
                        points(Time,as.numeric(as.character(Sub_metering_3)),col="blue",type="l") })
legend("topright",lty = 1,col = c("black","red","blue"),legend = c("Sub_metering_1","Sub_metering_2","Sub_metering_3"))
title(main = "Energy Submetering levels vs Time")

#copying it to png
dev.copy(png,file="plot3.png")
dev.off()
