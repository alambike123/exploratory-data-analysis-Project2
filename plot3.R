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

# QUESTION 03

# Of the four types of sources indicated by the type (point, nonpoint, onroad,
# nonroad) variable, which of these four sources have seen decreases in emissions
# from 1999–2008 for Baltimore City? Which have seen increases in emissions from 1999–2008? 
# Use the ggplot2 plotting system to make a plot answer this question.

#ANSWER: The nonpoint type have seen decreases in emissions from 1998-2008 for Baltimore city.
# On the other hand, the point type incresed in this period. 

question3 <- NEI %>%
  filter(fips == "24510") %>%
  select(year, type, Emissions) %>%
  group_by(type, year) %>%
  summarize(em_year = sum(Emissions))

png("plot3.png", width=480, height=480)

ggplot(question3, aes(x = factor(year), y=em_year)) +
  geom_bar(stat = "identity") +
  facet_grid(~type) +
  labs(x="year", y=expression("Total PM"[2.5]*" Emission (Tons)")) + 
  labs(title=expression("PM"[2.5]*" Emissions, Baltimore City 1999-2008 by Source Type"))

dev.off()
