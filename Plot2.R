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
electricity_new<-filter(electricity,grepl("2007-02-01|2007-02-02",electricity$Date)==T)
str(electricity_new)
head(electricity_new)
tail(electricity_new)
electricity_new$Global_active_power<-as.numeric(as.character(electricity_new$Global_active_power))
electricity_new$Time<-strptime(electricity_new$Time,format = "%H:%M:%S")
electricity_new[1:1440,"Time"]<-format(electricity_new[1:1440,"Time"],"2007-02-01 %H:%M:%S")  
electricity_new[1441:2880,"Time"]<-format(electricity_new[1441:2880,"Time"],"2007-02-02 %H:%M:%S")
 
#now lets plot      
plot(electricity_new$Time,electricity_new$Global_active_power,xlab = "",ylab = "Global Active Power(killowatts)",type = "l")
title(main="Global Active Power vs Time")

#copy it in png format
dev.copy(png,file="plot2.png")
dev.off()
