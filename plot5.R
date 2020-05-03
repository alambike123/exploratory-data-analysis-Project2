# load the packages
library("tidyverse")
library("dplyr")
library("data.table")
library("ggplot2")

#Unzipping and Loading Files

#path <- getwd()
#download.file(url = "https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2FNEI_data.zip"
#              , destfile = paste(path, "dataFiles.zip", sep = "/"))
#unzip(zipfile = "dataFiles.zip")

SCC <- data.table::as.data.table(x = readRDS(file = "Source_Classification_Code.rds"))
NEI <- data.table::as.data.table(x = readRDS(file = "summarySCC_PM25.rds"))

# QUESTION 05

# How have emissions from motor vehicle sources changed  
# from 1999–2008 in Baltimore City?

# ANSWER: The emissions from motor vehicle sources decreased. 

scc_vehicle <- SCC %>% 
  select(SCC, EI.Sector) %>% 
  filter(str_detect(pattern = "[Vv]ehicle", EI.Sector))

nei_vehicles <- semi_join(NEI, scc_vehicle, by = "SCC")

BA_vehicles <- subset(nei_vehicles, fips == "24510")
BA_vehicles[which(BA_vehicles$fips == "24510"), "fips"] <- "Baltimore"
BA_vehicles <- rename(BA_vehicles, city = "fips")

#Create the Plot

##If File exists, remove it
if (file.exists("plot5.png")) {
  file.remove("plot5.png")
}

png("plot5.png",width = 480,height = 480)

ggplot(BA_vehicles, aes(x=as.factor(year), y = Emissions)) +
  geom_bar(stat="identity") +
  labs(title="Motor vehicle emissions over the years in Baltimore"
       ,x=expression("Years")
       ,y=expression("Emissions (x 1.000 tons)"))

dev.off()

