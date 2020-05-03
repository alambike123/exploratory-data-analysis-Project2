# load the packages

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

glimpse(NEI)
glimpse(SCC)

# QUESTION 04

# Across the United States, how have emissions from coal 
# combustion-related sources changed from 1999–2008?

#Merge 

NEISCC <- merge(NEI, SCC, by="SCC")

# get all the names which matches coal
coalNames  <- grepl("coal", NEISCC$Short.Name, ignore.case=TRUE)
coalNEISCC <- NEISCC[coalNames, ]

TotalEmmission <- aggregate(Emissions ~ year, coalNEISCC, sum)

png("plot4.png", width=480, height=480)

ggplot(TotalEmmission, aes(factor(year), Emissions/10^5)) +
  geom_bar(stat="identity") +
  xlab("year") +
  ylab("Total PM2.5 Emissions") +
  ggtitle("Total Emissions for coal in the US")

dev.off()
