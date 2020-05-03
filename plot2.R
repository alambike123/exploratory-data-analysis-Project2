# load the packages

library("dplyr")
library("data.table")

#Unzipping and Loading Files

#path <- getwd()
#download.file(url = "https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2FNEI_data.zip"
#              , destfile = paste(path, "dataFiles.zip", sep = "/"))
#unzip(zipfile = "dataFiles.zip")

SCC <- data.table::as.data.table(x = readRDS(file = "Source_Classification_Code.rds"))
NEI <- data.table::as.data.table(x = readRDS(file = "summarySCC_PM25.rds"))

glimpse(NEI)
glimpse(SCC)
# QUESTION 02

# Have total emissions from PM2.5 decreased in the Baltimore City,
# Maryland (fips == "24510") from 1999 to 2008? Use the base 
# plotting system to make a plot answering this question.

# ANSWER: Yes, the total emissions from PM2.5 dreased in the Batimore City.


question2 <- NEI %>%
  group_by(year) %>% 
  filter(fips == "24510") %>%
  summarize(em_year = sum(Emissions))

glimpse(question2)

class(question2)

png("plot2.png", width=480, height=480)

plot(x = question2$year, y =  question2$em_year
     , type = "o"
     , xlab = "Years", ylab = "Emissions"
     , main = "Emissions over the Years")

dev.off()
