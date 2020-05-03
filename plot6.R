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

# QUESTION 06

# Compare emissions from motor vehicle sources in Baltimore City with 
# emissions from motor vehicle sources in Los Angeles County, California 
# (fips == "06037"). Which city has seen greater changes over time in motor 
# vehicle emissions?

#ANSWER: It can be seen a great change in Baltimore. 

scc_vehicle <- SCC %>% 
  select(SCC, EI.Sector) %>% 
  filter(str_detect(pattern = "[Vv]ehicle", EI.Sector))

nei_vehicles <- semi_join(NEI, scc_vehicle, by = "SCC")

LA_BA_vehicles <- subset(nei_vehicles, fips == "24510" | fips == "06037")
LA_BA_vehicles[which(LA_BA_vehicles$fips == "24510"), "fips"] <- "Baltimore"
LA_BA_vehicles[which(LA_BA_vehicles$fips == "06037"), "fips"] <- "Los Angeles"

LA_BA_vehicles <- rename(LA_BA_vehicles, city = "fips")

#Create the Plot

##If File exists, remove it
if (file.exists("plot6.png")) {
  file.remove("plot6.png")
}

png("plot6.png",width = 480,height = 480)

ggplot(LA_BA_vehicles, aes(x=as.factor(year), y = Emissions)) +
  geom_bar(stat="identity") +
  facet_grid(~city) +
  labs(title="Motor vehicle emissions over the years in Baltimore"
       ,x=expression("Years")
       ,y=expression("Emissions (x 1.000 tons)"))

dev.off()