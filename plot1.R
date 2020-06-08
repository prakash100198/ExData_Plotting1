#unzipping thte downloaded dataset
list.files(recursive = T)
unzip("exdata_data_household_power_consumption.zip",exdir = "./electricity")

##reading the csv file with sep as ";"
electricity<-read.csv("./electricity/household_power_consumption.txt",sep = ";")
print(object.size(electricity),units = "Mb")
head(electricity)
str(electricity)

#converting dates to date object and time converted to posixlt format
library(lubridate)
electricity$Date<- dmy(electricity$Date)
electricity$Time<-strptime(electricity$Time,format = "%H:%M:%S")
electricity$Time<-gsub("^20-06-07 ","",electricity$Time)


#filtering out the date we are going to work with i.e. 2007-02-01 and 2007-02-02
library(plyr)
library(dplyr)
electricity_new<-filter(electricity,grepl("2007-02-01|2007-02-02",electricity$Date)==T)
str(electricity_new)
head(electricity_new)
electricity_new$Global_active_power<-as.character(electricity_new$Global_active_power)  
electricity_new$Global_active_power<-as.numeric(electricity_new$Global_active_power) 
                             
#Since our dataset that we are going to work with is stored in electricity_new,lets start with plot 1
par(mfrow=c(1,1))
hist(as.numeric(electricity_new$Global_active_power),xlab = "Global Active Power(kilowatts)",main = "Global Active Power",col="red")

#now copying it to png device graphics
dev.copy(png,file="plot1.png")
dev.off()

     